#!/bin/bash
set -Eeuo pipefail

APP="ecommerce"
CLUSTER="ecommerce-cluster"
NS="ecommerce"
REPO="https://github.com/hzdevops52/ecommerce-deployment.git"
BRANCH="feature/hzdevops"
REPO_DIR="/home/ec2-user/ecommerce-deployment"
REGION="us-east-1"
LOG="/var/log/ecommerce-bootstrap.log"

exec > >(tee -a "$LOG") 2>&1
trap 'echo "[ERROR] Bootstrap failed at line $LINENO (exit $?)"' ERR
export AWS_DEFAULT_REGION="$REGION"

echo "=== Ecommerce bootstrap started ==="

# ---------------------------------------------------------------------------
# Swap: 3 GiB
# ---------------------------------------------------------------------------
SWAP="/swapfile"

if ! swapon --show | grep -q "$SWAP"; then
    if [ ! -f "$SWAP" ]; then
        fallocate -l 3G "$SWAP"
        chmod 600 "$SWAP"
        mkswap "$SWAP"
    fi
    swapon "$SWAP"
fi

grep -q "^$SWAP " /etc/fstab || \
    echo "$SWAP swap swap defaults 0 0" >> /etc/fstab

cat >/etc/sysctl.d/99-ecommerce.conf <<'EOF'
vm.swappiness=10
EOF

sysctl --system >/dev/null 2>&1 || true

echo "Memory:"
free -h
echo "Disk:"
df -h /

# ---------------------------------------------------------------------------
# Packages
# ---------------------------------------------------------------------------
dnf install -y git unzip tar gzip shadow-utils util-linux jq

# ---------------------------------------------------------------------------
# AWS CLI
# ---------------------------------------------------------------------------
if ! command -v aws >/dev/null 2>&1; then
    cd /tmp
    curl -fsSL \
        https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
        -o awscliv2.zip
    rm -rf aws
    unzip -q awscliv2.zip
    ./aws/install
    rm -rf aws awscliv2.zip
fi

# ---------------------------------------------------------------------------
# CloudWatch Agent
# ---------------------------------------------------------------------------
echo "Installing Amazon CloudWatch Agent..."

dnf install -y amazon-cloudwatch-agent

cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<'EOF'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {
    "namespace": "Ecommerce/EC2",
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "resources": [
          "/"
        ],
        "metrics_collection_interval": 60
      },
      "swap": {
        "measurement": [
          "swap_used_percent"
        ],
        "metrics_collection_interval": 60
      }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/ecommerce/ec2",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s

# ---------------------------------------------------------------------------
# Docker
# ---------------------------------------------------------------------------
if ! command -v docker >/dev/null 2>&1; then
    dnf install -y docker
fi

systemctl enable --now docker
usermod -aG docker ec2-user

for i in {1..30}; do
    docker info >/dev/null 2>&1 && break
    sleep 2
done

docker info >/dev/null 2>&1

# ---------------------------------------------------------------------------
# kubectl
# ---------------------------------------------------------------------------
if ! command -v kubectl >/dev/null 2>&1; then
    curl -fsSL \
        https://dl.k8s.io/release/v1.34.0/bin/linux/amd64/kubectl \
        -o /usr/local/bin/kubectl
    chmod 755 /usr/local/bin/kubectl
fi

# ---------------------------------------------------------------------------
# Kind
# ---------------------------------------------------------------------------
if ! command -v kind >/dev/null 2>&1; then
    curl -fsSL \
        https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64 \
        -o /usr/local/bin/kind
    chmod 755 /usr/local/bin/kind
fi

# ---------------------------------------------------------------------------
# Helm
# ---------------------------------------------------------------------------
if ! command -v helm >/dev/null 2>&1; then
    curl -fsSL \
        https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
        | bash
fi

# ---------------------------------------------------------------------------
# Docker config
# ---------------------------------------------------------------------------
install -d -m 700 -o ec2-user -g ec2-user /home/ec2-user/.docker

# ---------------------------------------------------------------------------
# GitHub repository token from SSM
# ---------------------------------------------------------------------------
GITHUB_TOKEN="$(
    aws ssm get-parameter \
        --name /ecommerce/github/repo-token \
        --with-decryption \
        --query Parameter.Value \
        --output text
)"

[ -n "$GITHUB_TOKEN" ]

ASKPASS="/home/ec2-user/.git-askpass"

cat >"$ASKPASS" <<EOF
#!/bin/bash
case "\$1" in
    *Username*) echo "hzdevops52" ;;
    *Password*) echo "${GITHUB_TOKEN}" ;;
esac
EOF

chown ec2-user:ec2-user "$ASKPASS"
chmod 700 "$ASKPASS"

# ---------------------------------------------------------------------------
# Clone application repository
# ---------------------------------------------------------------------------
if [ -d "$REPO_DIR/.git" ]; then
    chown -R ec2-user:ec2-user "$REPO_DIR"

    runuser -l ec2-user -c \
        "GIT_ASKPASS='$ASKPASS' \
         GIT_TERMINAL_PROMPT=0 \
         git -C '$REPO_DIR' fetch origin '$BRANCH'"

    runuser -l ec2-user -c \
        "git -C '$REPO_DIR' checkout '$BRANCH'"

    runuser -l ec2-user -c \
        "git -C '$REPO_DIR' reset --hard 'origin/$BRANCH'"
else
    rm -rf "$REPO_DIR"

    runuser -l ec2-user -c \
        "GIT_ASKPASS='$ASKPASS' \
         GIT_TERMINAL_PROMPT=0 \
         git clone \
         --branch '$BRANCH' \
         --single-branch \
         '$REPO' \
         '$REPO_DIR'"
fi

rm -f "$ASKPASS"
unset GITHUB_TOKEN

chown -R ec2-user:ec2-user "$REPO_DIR"

# ---------------------------------------------------------------------------
# Validate Kind config
# ---------------------------------------------------------------------------
KIND_CONFIG="$REPO_DIR/kind-config.yaml"

if [ ! -f "$KIND_CONFIG" ]; then
    echo "[ERROR] Missing $KIND_CONFIG"
    exit 1
fi

# ---------------------------------------------------------------------------
# Create Kind cluster
# ---------------------------------------------------------------------------
if ! runuser -l ec2-user -c "kind get clusters" 2>/dev/null \
    | grep -qx "$CLUSTER"; then

    runuser -l ec2-user -c \
        "sg docker -c \
        'kind create cluster \
        --name $CLUSTER \
        --config $KIND_CONFIG'"
fi

runuser -l ec2-user -c \
    "kubectl config use-context kind-$CLUSTER"

# ---------------------------------------------------------------------------
# Wait for Kubernetes
# ---------------------------------------------------------------------------
READY=false

for i in {1..60}; do
    if runuser -l ec2-user -c \
        "kubectl get nodes --no-headers 2>/dev/null" \
        | grep -q " Ready "; then
        READY=true
        break
    fi
    sleep 5
done

if [ "$READY" != "true" ]; then
    runuser -l ec2-user -c "kubectl get nodes -o wide" || true
    exit 1
fi

runuser -l ec2-user -c "kubectl get nodes -o wide"

# ---------------------------------------------------------------------------
# Namespace
# ---------------------------------------------------------------------------
runuser -l ec2-user -c \
    "kubectl create namespace $NS \
     --dry-run=client -o yaml \
     | kubectl apply -f -"

# ---------------------------------------------------------------------------
# GHCR secret
# ---------------------------------------------------------------------------
GHCR_TOKEN="$(
    aws ssm get-parameter \
        --name /ecommerce/ghcr/pull-token \
        --with-decryption \
        --query Parameter.Value \
        --output text
)"

[ -n "$GHCR_TOKEN" ]

printf '%s' "$GHCR_TOKEN" \
    | runuser -l ec2-user -c \
        "sg docker -c \
        'docker login ghcr.io \
        --username hzdevops52 \
        --password-stdin'"

unset GHCR_TOKEN

runuser -l ec2-user -c "
    kubectl create secret generic ghcr-secret \
        --from-file=.dockerconfigjson=/home/ec2-user/.docker/config.json \
        --type=kubernetes.io/dockerconfigjson \
        -n $NS \
        --dry-run=client -o yaml \
    | kubectl apply -f -
"

runuser -l ec2-user -c \
    "sg docker -c 'docker logout ghcr.io' || true"

rm -f /home/ec2-user/.docker/config.json

# ---------------------------------------------------------------------------
# Backend secrets
# ---------------------------------------------------------------------------
APP_PASSWORD="$(
    aws ssm get-parameter \
        --name /ecommerce/backend/app-password \
        --with-decryption \
        --query Parameter.Value \
        --output text
)"

JWT_SECRET="$(
    aws ssm get-parameter \
        --name /ecommerce/backend/jwt-secret \
        --with-decryption \
        --query Parameter.Value \
        --output text
)"

[ -n "$APP_PASSWORD" ]
[ -n "$JWT_SECRET" ]

SECRET_FILE="/home/ec2-user/.backend-secret.env"

umask 077

cat >"$SECRET_FILE" <<EOF
APP_PASSWORD=$APP_PASSWORD
JWT_SECRET=$JWT_SECRET
EOF

chown ec2-user:ec2-user "$SECRET_FILE"
chmod 600 "$SECRET_FILE"

runuser -l ec2-user -c "
    kubectl create secret generic backend-secret \
        --from-env-file='$SECRET_FILE' \
        -n $NS \
        --dry-run=client -o yaml \
    | kubectl apply -f -
"

rm -f "$SECRET_FILE"

unset APP_PASSWORD
unset JWT_SECRET

# ---------------------------------------------------------------------------
# Blue/Green namespaces and secrets
# ---------------------------------------------------------------------------
for BLUE_GREEN_NS in ecommerce-blue ecommerce-green; do

    runuser -l ec2-user -c \
        "kubectl create namespace $BLUE_GREEN_NS \
         --dry-run=client -o yaml \
         | kubectl apply -f -"

    runuser -l ec2-user -c \
        "kubectl get secret ghcr-secret \
         -n $NS \
         -o json \
        | jq 'del(
            .metadata.namespace,
            .metadata.resourceVersion,
            .metadata.uid,
            .metadata.creationTimestamp,
            .metadata.managedFields
          )' \
        | jq --arg ns '$BLUE_GREEN_NS' '.metadata.namespace = \$ns' \
        | kubectl apply -f -"

    runuser -l ec2-user -c \
        "kubectl get secret backend-secret \
         -n $NS \
         -o json \
        | jq 'del(
            .metadata.namespace,
            .metadata.resourceVersion,
            .metadata.uid,
            .metadata.creationTimestamp,
            .metadata.managedFields
          )' \
        | jq --arg ns '$BLUE_GREEN_NS' '.metadata.namespace = \$ns' \
        | kubectl apply -f -"

done

# ---------------------------------------------------------------------------
# Validate Helm chart
# ---------------------------------------------------------------------------
CHART="$REPO_DIR/ecommerce-chart"

[ -d "$CHART" ]

runuser -l ec2-user -c "helm lint '$CHART'"

# ---------------------------------------------------------------------------
# Deploy application
# ---------------------------------------------------------------------------
runuser -l ec2-user -c "
    helm upgrade --install $APP '$CHART' \
        --namespace $NS \
        --create-namespace \
        --set backend.replicaCount=1 \
        --set frontend.replicaCount=1 \
        --wait \
        --timeout 15m
"

# ---------------------------------------------------------------------------
# Deployment verification
# ---------------------------------------------------------------------------
runuser -l ec2-user -c \
    "kubectl rollout status \
     deployment/backend-deployment \
     -n $NS \
     --timeout=300s"

runuser -l ec2-user -c \
    "kubectl rollout status \
     deployment/frontend-deployment \
     -n $NS \
     --timeout=300s"

# ---------------------------------------------------------------------------
# Frontend verification
# ---------------------------------------------------------------------------
FRONTEND_READY=false

for i in {1..60}; do
    if curl -fsS \
        --max-time 5 \
        http://127.0.0.1:30081 \
        >/dev/null 2>&1; then

        FRONTEND_READY=true
        break
    fi

    sleep 5
done

if [ "$FRONTEND_READY" != "true" ]; then

    echo "=== APPLICATION DIAGNOSTICS ==="

    runuser -l ec2-user -c \
        "kubectl get pods -n $NS -o wide" || true

    runuser -l ec2-user -c \
        "kubectl get svc -n $NS" || true

    runuser -l ec2-user -c \
        "kubectl get events -n $NS \
         --sort-by=.lastTimestamp | tail -30" || true

    exit 1
fi

# ---------------------------------------------------------------------------
# Final status
# ---------------------------------------------------------------------------
echo "=== Kubernetes ==="

runuser -l ec2-user -c \
    "kubectl get nodes -o wide"

runuser -l ec2-user -c \
    "kubectl get pods -n $NS -o wide"

runuser -l ec2-user -c \
    "kubectl get svc -n $NS"

echo "=== Resources ==="

free -h
df -h /
swapon --show

echo "=== Ecommerce bootstrap completed successfully ==="