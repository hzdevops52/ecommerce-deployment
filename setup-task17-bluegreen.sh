#!/bin/bash
set -euo pipefail

CHART_DIR="ecommerce-chart"

echo "==> Configuring Task 17 Blue/Green Helm support..."

cd "$CHART_DIR"

cat > values-blue.yaml <<'YAML'
frontend:
  service:
    type: ClusterIP
YAML

cat > values-green.yaml <<'YAML'
frontend:
  service:
    type: ClusterIP
YAML

cat > templates/frontend-service.yaml <<'YAML'
apiVersion: v1
kind: Service

metadata:
  name: frontend-service
  namespace: {{ .Release.Namespace }}

spec:
  type: {{ .Values.frontend.service.type }}

  selector:
    app: frontend-deployment

  ports:
    - port: {{ .Values.frontend.service.port }}
      targetPort: {{ .Values.frontend.service.targetPort }}
      {{- if eq .Values.frontend.service.type "NodePort" }}
      nodePort: {{ .Values.frontend.service.nodePort }}
      {{- end }}
YAML

echo "==> Running Helm lint..."
helm lint .

echo "==> Validating Task 16 default rendering..."
helm template ecommerce . --namespace ecommerce > /tmp/task16-rendered.yaml

echo "==> Checking Task 16 frontend Service..."
grep -A10 -B2 "name: frontend-service" /tmp/task16-rendered.yaml | head -20

echo "==> Validating Blue rendering..."
helm template ecommerce-blue . \
  --namespace ecommerce-blue \
  -f values-blue.yaml \
  > /tmp/blue-rendered.yaml

echo "==> Task 17 files prepared successfully."
