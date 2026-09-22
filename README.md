# 🛒 E-Commerce DevOps & Cloud Deployment

A production-oriented DevOps and Cloud engineering project built around a full-stack **MERN e-commerce application**.

This repository documents the transformation of an existing MERN application into a containerized, orchestrated, automated, monitored, and AWS-oriented deployment platform using modern DevOps practices.

The project was completed as part of a **22-task DevOps internship**, progressing from Git and containerization through Kubernetes, CI/CD, GitOps, Infrastructure as Code, AWS services, monitoring, database infrastructure, CDN delivery, and security.

---

## 📌 Project Overview

The underlying application is a full-stack e-commerce platform built with:

* **React.js** frontend
* **Node.js / Express.js** backend
* **MongoDB** database
* JWT authentication
* Role-based access control
* Product management
* Image uploads
* Shopping cart and purchase functionality
* Product search and reviews

The primary objective of this project was not to rewrite the application, but to build a reliable **DevOps delivery and infrastructure platform around it**.

The application evolved through the following engineering path:

```text
MERN Application
       │
       ▼
Git & Branching
       │
       ▼
Docker
       │
       ▼
Docker Compose
       │
       ▼
Kubernetes
       │
       ▼
Helm
       │
       ▼
Jenkins CI/CD
       │
       ▼
Argo CD / GitOps
       │
       ▼
Monitoring & Alerting
       │
       ▼
Terraform / AWS
       │
       ├── EC2
       ├── ALB
       ├── ECS / ECR
       ├── EKS
       ├── RDS
       ├── S3
       └── CloudFront
```

---

# 🏗️ Application Architecture

The original application follows a three-tier architecture:

```text
                    ┌──────────────────┐
                    │     Browser      │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │ React Frontend   │
                    │      Nginx       │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │ Node.js /        │
                    │ Express Backend  │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │     MongoDB      │
                    └──────────────────┘
```

The DevOps implementation adds the infrastructure and delivery layers around this application.

---

# 🚀 Application Features

## Authentication

* JWT-based authentication
* Secure HTTP-only cookie handling
* User registration and login
* Role-based authorization

## User Roles

### Retailer

* Add products
* Upload product images
* Manage product information
* Browse and purchase other products

### Consumer

* Browse products
* Search products
* View product information
* Add products to cart
* Purchase products
* Submit reviews

## Backend Security

The backend includes security-related improvements such as:

* Password hashing with bcrypt
* JWT middleware
* Protected routes
* Role-based authorization
* Rate limiting
* Environment-based configuration

---

# 🛠️ Technology Stack

| Category            | Technology                                            |
| ------------------- | ----------------------------------------------------- |
| Frontend            | React.js                                              |
| Frontend Web Server | Nginx                                                 |
| Backend             | Node.js / Express.js                                  |
| Database            | MongoDB                                               |
| Authentication      | JWT                                                   |
| Containers          | Docker                                                |
| Local Orchestration | Docker Compose                                        |
| Container Registry  | GitHub Container Registry                             |
| Container Registry  | Docker Hub                                            |
| Kubernetes          | Kubernetes / Kind                                     |
| Packaging           | Helm                                                  |
| GitOps              | Argo CD                                               |
| CI/CD               | Jenkins                                               |
| Monitoring          | Prometheus / Grafana                                  |
| AWS Monitoring      | CloudWatch / SNS                                      |
| IaC                 | Terraform                                             |
| AWS Compute         | EC2 / ECS / EKS                                       |
| AWS Database        | RDS PostgreSQL                                        |
| AWS Storage         | S3                                                    |
| AWS CDN             | CloudFront                                            |
| AWS Secrets         | Secrets Manager                                       |
| Load Balancing      | Application Load Balancer                             |
| Networking          | VPC / Subnets / Route Tables / NAT / Internet Gateway |

---

# 🌿 Git Branching Strategy

The project uses a promotion-based branching model:

```text
feature/hzdevops
       │
       │ Pull Request
       ▼
      dev
       │
       │ Pull Request
       ▼
     stage
       │
       │ Pull Request
       ▼
      main
```

### Branch responsibilities

| Branch             | Purpose                                          |
| ------------------ | ------------------------------------------------ |
| `feature/hzdevops` | Active development and internship implementation |
| `dev`              | Development/integration environment              |
| `stage`            | Staging validation                               |
| `main`             | Final release branch                             |

The final repository preserves these branches because they demonstrate the complete promotion workflow rather than treating Git as a single-branch storage system.

The final Git history contains the promotion chain:

```text
feature/hzdevops → dev → stage → main
```

---

# 📚 DevOps Internship Journey

## Task 1 — Git Repository & Version Control

### What

The application was placed under a structured Git workflow suitable for collaborative DevOps development.

### Why

Version control provides:

* Traceability
* Collaboration
* Rollback capability
* Pull-request based review
* Environment promotion

### How

The repository was organized around:

```text
feature/hzdevops
        ↓
      dev
        ↓
      stage
        ↓
      main
```

Changes were developed in the feature branch and promoted through the higher environments.

---

# Task 2 — Development Environment & Repository Preparation

The existing MERN application was reviewed and prepared for DevOps automation.

The project structure separates:

```text
frontend/
backend/
k8s/
ecommerce-chart/
terraform/
scripts/
docs/
```

Configuration and secrets were separated from source code using environment variables and Git ignore rules.

---

# Task 3 — Containerization

The frontend and backend were containerized so the application could run consistently across environments.

The implementation is represented in Git by:

```text
cfe1927 task-3 dockerization
```

The commit introduced containerized versions of:

* Frontend
* Backend

The original Dockerfiles were retained as:

```text
Dockerfile.original
```

while the working Dockerfiles were optimized for the deployment workflow.

### Frontend

The frontend is built as a production React application and served through Nginx.

### Backend

The backend runs as a Node.js/Express container.

---

# Task 4 — Secure Containerization

The containerization process was improved with production-oriented practices including:

* Multi-stage builds
* Smaller runtime images
* Non-root container execution
* `.dockerignore`
* Separation of build and runtime concerns
* Environment-based configuration

The repository also documents container security and registry usage.

---

# Task 5 — Container Registries

Container images were prepared for registry-based delivery.

The project used:

* Docker Hub
* GitHub Container Registry
* Google Cloud Artifact Registry for validation

Temporary cloud resources used for experimentation were removed after validation to avoid unnecessary ongoing cost.

---

# Task 6 — Docker Compose Orchestration

Docker Compose was introduced to run the complete application stack locally.

The implementation is represented by:

```text
97a274d adding compose file
```

The Compose architecture contains:

```text
                  Browser
                     │
                     ▼
            ┌─────────────────┐
            │    Frontend     │
            │      Nginx      │
            └────────┬────────┘
                     │
                     ▼
            ┌─────────────────┐
            │     Backend     │
            │ Node / Express  │
            └────────┬────────┘
                     │
                     ▼
            ┌─────────────────┐
            │     MongoDB     │
            └─────────────────┘
```

### Compose features

* Custom bridge network
* MongoDB named volume
* Health checks
* Service dependencies
* Restart policies
* Configurable ports
* Log rotation
* Environment variables
* Persistent MongoDB storage

### Network

```text
ecommerce_network
```

### Volume

```text
ecommerce_mongo_data
```

The named MongoDB volume survives:

```bash
docker compose down
```

and is removed only intentionally with:

```bash
docker compose down -v
```

---

# Task 7 — Docker Verification & Troubleshooting

The Compose implementation includes validation for:

* Container state
* Service health
* Frontend HTTP access
* Backend `/health`
* Frontend-to-backend communication
* Backend-to-MongoDB communication
* Network configuration
* Persistent storage
* Rootless execution

A dedicated verification script is included:

```text
scripts/verify-compose.sh
```

This makes the local deployment reproducible rather than relying only on manual inspection.

---

# Task 8 — Jenkins CI/CD

Jenkins was introduced as the CI/CD engine.

The initial pipeline was added through:

```text
a270499 adding jenkinsfile
```

The pipeline was subsequently refined through multiple commits.

The deployment pipeline evolved through:

```text
Build
  ↓
Container Image
  ↓
Registry
  ↓
Deployment
```

The repository contains:

```text
Jenkinsfile
```

which acts as the pipeline definition.

---

# Task 9 — Jenkins Deployment Automation

A deployment stage was added through:

```text
3e1d6ce adding deploy stage in jenkinsfile
```

The Jenkins pipeline was subsequently debugged and improved through several commits.

This demonstrated an important DevOps principle:

> CI/CD pipelines are treated as code and continuously improved through version control.

---

# Task 10 — Kubernetes Deployment

The application was migrated from local containers to Kubernetes.

The initial Kubernetes implementation was introduced through:

```text
5dfd816 adding k8s files
```

The Kubernetes environment includes:

```text
k8s/
├── namespace.yml
├── backend-deployment.yml
├── backend-service.yml
├── backend-configmap.yml
├── frontend-deployment.yml
├── frontend-service.yml
├── mongodb-deployment.yml
├── mongodb-service.yml
└── mongodb-pvc.yml
```

The application was deployed into a dedicated Kubernetes namespace.

---

# Task 11 — Kubernetes Storage & Networking

MongoDB was deployed with persistent storage using:

```text
mongodb-pvc.yml
```

Kubernetes Services were used to provide stable service discovery:

```text
backend-service
frontend-service
mongodb-service
```

The application therefore moved from Docker Compose networking to Kubernetes service-based networking.

---

# Task 12 — Kubernetes HPA

Horizontal Pod Autoscaling was introduced through:

```text
06fbfbb adding hpa and fixed issues k8s
```

The backend received an HPA configuration:

```text
k8s/backend-hpa.yml
```

The purpose of HPA is to automatically adjust the number of backend replicas based on resource utilization.

Conceptually:

```text
              Traffic
                 │
                 ▼
          Backend Pods
          ┌────┬────┐
          │ P1 │ P2 │
          └────┴────┘
                 │
                 ▼
                HPA
                 │
       ┌─────────┴─────────┐
       ▼                   ▼
   Scale Up              Scale Down
```

---

# Task 13 — Kubernetes Ingress

Ingress was introduced through:

```text
b2806c5 add ingress fix hpa and validate
```

The project includes:

```text
k8s/ingress.yaml
```

Ingress provides an HTTP entry point for the Kubernetes application instead of exposing every service independently.

The Kind configuration was also adjusted to support the ingress workflow.

---

# Task 14 — Helm Packaging

The Kubernetes manifests were converted into a reusable Helm chart.

The chart is located at:

```text
ecommerce-chart/
```

The chart contains templates for:

* Backend
* Frontend
* MongoDB
* Services
* ConfigMap
* PVC
* HPA
* Ingress

Configuration is centralized through:

```text
values.yaml
```

This makes deployment parameters configurable without modifying every Kubernetes manifest individually.

---

# Task 15 — Argo CD & GitOps

Argo CD was introduced to move deployment responsibility toward a GitOps model.

The deployment flow became:

```text
Developer
    │
    ▼
Git
    │
    ▼
Jenkins
    │
    ▼
Container Registry
    │
    ▼
Git / Deployment Configuration
    │
    ▼
Argo CD
    │
    ▼
Kubernetes
```

Instead of manually applying Kubernetes manifests after every build, Argo CD provides a declarative deployment model.

---

# Task 16 — Argo CD Image Updater

Automated image update handling was added through:

```text
d083d68 add Argo CD image updater
```

The repository contains:

```text
k8s/image-updater.yml
```

This extended the GitOps workflow so that container image changes could be detected and propagated into the Kubernetes deployment process.

---

# Task 17 — Blue/Green Deployment

Blue/Green deployment was explored and implemented at the infrastructure/configuration level.

Relevant commits include:

```text
1856bd4 adding blue-green deployments
754c503 feat: prepare EC2 bootstrap for blue-green deployment
```

The project contains:

```text
values-blue.yaml
values-green.yaml
setup-task17-bluegreen.sh
```

The architecture separates the two deployment environments:

```text
              Traffic
                 │
                 ▼
          ┌─────────────┐
          │   Service   │
          └──────┬──────┘
                 │
          ┌──────┴──────┐
          ▼             ▼
       Blue            Green
      Version          Version
```

The task demonstrated the mechanics and infrastructure required for Blue/Green deployment.

Because the internship environment had resource and infrastructure constraints, this should not be presented as a fully production-grade zero-downtime implementation.

---

# Task 18 — Monitoring & Alerting

AWS monitoring and alerting were introduced through:

```text
90862f2 cloudwatch & SNS $ alarms
```

The implementation includes:

```text
cloudwatch.tf
alarms.tf
SNS.tf
```

and a CloudWatch Agent configuration:

```text
scripts/cloudwatch-agent-config.json
```

The monitoring architecture was:

```text
AWS Resources
      │
      ▼
CloudWatch
      │
      ▼
CloudWatch Alarms
      │
      ▼
SNS
      │
      ▼
Notification
```

The implementation also included Prometheus and Grafana for Kubernetes/application observability.

---

# Task 19 — Amazon ECS & ECR

Amazon ECS and ECR were introduced through:

```text
e94242c ECS and ECR files added
```

The Terraform implementation includes:

```text
ECR.tf
ECS.tf
ecs-alb.tf
ecs-iam.tf
ecs-services.tf
ecs-task-definitions.tf
ecs-service-discovery.tf
ecs-sg.tf
```

The ECS architecture included:

```text
                    Internet
                       │
                       ▼
                Application LB
                       │
                       ▼
                  ECS Service
                  ┌────┴────┐
                  ▼         ▼
               Backend   Frontend
                  │
                  ▼
               Database
```

ECR was used as the AWS-native container image registry.

The ECS environment was used for learning and validation and was not kept running unnecessarily after the task was completed.

---

# Task 20 — Amazon EKS

Amazon EKS infrastructure was introduced using Terraform.

The repository contains:

```text
eks.tf
eks-iam.tf
eks-node-group.tf
eks-oidc.tf
eks-addons.tf
eks-load-balancer-controller.tf
eks-outputs.tf
scripts/eks-bootstrap.sh
```

The EKS implementation covered:

* EKS cluster
* Node group
* IAM integration
* OIDC
* AWS Load Balancer Controller
* Kubernetes/AWS integration
* Bootstrap automation

This demonstrated the transition from a local Kind cluster to a managed Kubernetes platform on AWS.

---

# Task 21 — Secure Terraform State & RDS

Task 21 was isolated into:

```text
terraform/aws/task21-rds/
```

This separation was intentional so the database/state infrastructure would not interfere with the other Terraform configurations.

## Remote Terraform State

Terraform state was moved to an encrypted S3 backend with:

* S3 versioning
* Server-side encryption
* Public access blocking
* Locking support
* Dedicated state key

The state backend uses:

```text
S3
  │
  ├── Encryption
  ├── Versioning
  ├── Public access blocked
  └── State locking
```

## Amazon RDS

A PostgreSQL RDS instance was provisioned with:

* PostgreSQL 17
* `db.t3.micro`
* 20 GB gp3 storage
* Encryption enabled
* Private access
* Public access disabled

## Secrets Manager

Database credentials were stored in:

```text
task21/rds/credentials
```

instead of being placed directly in Terraform configuration or source code.

### Important architecture distinction

The application itself remains a **MERN application using MongoDB**.

The Task 21 PostgreSQL RDS infrastructure was a separate AWS database infrastructure exercise and should not be interpreted as the application's MongoDB replacement.

---

# Task 22 — S3, EC2, CloudFront & HTTPS

The final task was isolated into:

```text
terraform/aws/task22-cloudfront/
```

This prevented Task 22 experimentation from accidentally modifying the earlier Terraform infrastructure.

## Static Website Storage

The React production build was uploaded to Amazon S3.

The S3 bucket contained the generated frontend assets.

## CloudFront

CloudFront was configured in front of the S3 origin using:

* Origin Access Control
* HTTPS redirect
* TLS 1.2
* Compression
* Cache behavior
* SPA error handling
* CloudFront invalidation

Architecture:

```text
                    Browser
                       │
                       │ HTTPS
                       ▼
                ┌──────────────┐
                │  CloudFront  │
                └──────┬───────┘
                       │
                 Origin Access
                    Control
                       │
                       ▼
                ┌──────────────┐
                │      S3      │
                │ React Build  │
                └──────────────┘
```

The S3 bucket was kept private and CloudFront was given controlled access through OAC.

This is preferable to making the S3 bucket publicly readable when CloudFront is the intended delivery layer.

## HTTPS

A custom domain was intentionally **not purchased** for this internship deployment in order to avoid unnecessary domain-registration costs.

Therefore, a custom ACM certificate and Route 53 domain delegation were not provisioned.

Instead, CloudFront's AWS-managed default certificate was used with the CloudFront-generated:

```text
*.cloudfront.net
```

hostname.

This still allowed HTTPS and CDN functionality to be demonstrated without incurring domain-registration costs.

## EC2 Backend

The backend was also deployed to EC2 together with MongoDB.

The architecture was:

```text
EC2
│
├── Docker
│
├── MongoDB container
│
└── Backend container
       │
       └── Node.js / Express
```

The backend container used MongoDB through the Docker network rather than exposing MongoDB publicly.

The EC2 bootstrap process also retrieved the private GHCR credentials through AWS Secrets Manager.

## CloudFront Cache Validation

CloudFront behavior was validated through HTTP requests.

The first request demonstrated a cache miss, while subsequent requests demonstrated CloudFront cache/revalidation behavior.

An explicit CloudFront invalidation was also created and completed successfully.

---

# ☁️ AWS Architecture

Across the AWS tasks, the project explored:

```text
                         AWS
                          │
          ┌───────────────┼────────────────┐
          │               │                │
         EC2             ECS              EKS
          │               │                │
          │              ECR          Load Balancer
          │                                │
          │                                ▼
          │                           Kubernetes
          │
          ├── Docker
          ├── MongoDB
          └── Backend

       Terraform
          │
          ├── VPC
          ├── Subnets
          ├── IAM
          ├── Security Groups
          ├── ALB
          ├── ECS
          ├── EKS
          ├── RDS
          ├── S3
          └── CloudFront
```

---

# 🧱 Infrastructure as Code

Terraform became the primary infrastructure automation tool for AWS.

The main Terraform directory contains resources covering:

```text
terraform/aws/
├── VPC
├── Subnets
├── Route Tables
├── Internet Gateway
├── NAT Gateway
├── Security Groups
├── IAM
├── EC2
├── ALB
├── ECS
├── ECR
├── EKS
├── CloudWatch
├── SNS
├── RDS
├── S3
└── CloudFront
```

Terraform provides:

* Reproducibility
* Declarative infrastructure
* Version-controlled infrastructure
* Consistent environments
* Reduced manual configuration
* Easier teardown of temporary infrastructure

---

# 🔐 Security Practices

Security was considered throughout the project.

## Application

* JWT authentication
* HTTP-only authentication cookies
* bcrypt password hashing
* Rate limiting
* Protected routes
* Role-based authorization

## Containers

* Non-root runtime users
* Multi-stage builds
* `.dockerignore`
* Minimal runtime images
* Secrets excluded from images

## Kubernetes

* Namespaces
* Secrets
* ConfigMaps
* PersistentVolumeClaims
* Service-based communication
* HPA
* Controlled ingress

## AWS

* IAM roles instead of unnecessary long-lived credentials
* Secrets Manager for sensitive credentials
* Private RDS
* Encrypted RDS storage
* Encrypted EC2 root volume
* S3 public-access blocking
* CloudFront Origin Access Control
* HTTPS
* Security groups
* Terraform state encryption

---

# 💰 Cost-Control Strategy

This project was intentionally designed as a **learning and portfolio environment**, not as a permanently running production system.

Temporary AWS resources were destroyed after validation where appropriate.

Examples include:

* ECS resources
* EKS experimentation
* Task 22 temporary infrastructure

The custom domain purchase was intentionally skipped.

This avoided unnecessary recurring costs while still demonstrating:

* AWS networking
* EC2
* ECS
* EKS
* RDS
* S3
* CloudFront
* Terraform
* Monitoring
* Security

---

# 🧪 Validation Strategy

Validation was performed at multiple layers rather than relying only on Terraform's successful execution.

## Application

* Frontend accessibility
* Backend health endpoint
* Database connectivity
* API functionality

## Docker

* Container state
* Health checks
* Network connectivity
* Volume persistence
* Non-root execution

## Kubernetes

* Pod status
* Services
* HPA
* Ingress
* Application connectivity

## CI/CD

* Jenkins pipeline execution
* Image building
* Registry publishing
* Deployment stages

## AWS

* Terraform plans/applies
* EC2 health
* Backend `/health`
* MongoDB connectivity
* S3 object upload
* CloudFront HTTPS response
* CloudFront caching
* CloudFront invalidation
* RDS provisioning
* Secrets Manager integration

---

# 📁 Repository Structure

The final repository is organized around the application and its DevOps infrastructure:

```text
.
├── backend/
├── frontend/
├── k8s/
├── ecommerce-chart/
├── terraform/
│   └── aws/
├── scripts/
├── docs/
├── Jenkinsfile
├── docker-compose.yml
├── kind-config.yaml
├── setup-task17-bluegreen.sh
├── .env.example
├── SECURITY.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── LICENSE
└── README.md
```

### Kubernetes

```text
k8s/
├── backend-configmap.yml
├── backend-deployment.yml
├── backend-hpa.yml
├── backend-secret.yml
├── backend-service.yml
├── frontend-deployment.yml
├── frontend-service.yml
├── image-updater.yml
├── ingress.yaml
├── mongodb-deployment.yml
├── mongodb-pvc.yml
├── mongodb-service.yml
└── namespace.yml
```

### Helm

```text
ecommerce-chart/
├── Chart.yaml
├── values.yaml
├── values-blue.yaml
├── values-green.yaml
└── templates/
```

### Terraform

```text
terraform/aws/
├── VPC
├── EC2
├── ALB
├── IAM
├── ECS
├── ECR
├── EKS
├── CloudWatch
├── SNS
├── task21-rds/
└── task22-cloudfront/
```

---

# 🔄 Complete CI/CD & GitOps Flow

The complete delivery process developed during the internship can be represented as:

```text
Developer
    │
    ▼
Feature Branch
    │
    ▼
Pull Request
    │
    ▼
dev
    │
    ▼
stage
    │
    ▼
main
```

For application delivery:

```text
Git
 │
 ▼
Jenkins
 │
 ├── Build
 ├── Test
 ├── Docker Build
 └── Push Image
        │
        ▼
Container Registry
        │
        ▼
Argo CD / Image Updater
        │
        ▼
Helm
        │
        ▼
Kubernetes
        │
        ▼
Application
```

For infrastructure:

```text
Terraform
    │
    ▼
AWS APIs
    │
    ├── VPC
    ├── EC2
    ├── ECS
    ├── EKS
    ├── RDS
    ├── S3
    └── CloudFront
```

---

# 🧠 Key Engineering Lessons

This project provided practical experience with several important DevOps principles.

### Infrastructure should be reproducible

Terraform replaced repeated manual AWS configuration with version-controlled infrastructure.

### Containers should be immutable

Application dependencies and runtime environments were packaged into container images.

### Configuration should be separated from code

Environment variables, ConfigMaps, Secrets Manager, and Kubernetes Secrets were used for configuration and sensitive data.

### Git should be the source of truth

The promotion workflow and GitOps implementation demonstrate how deployment state can be managed declaratively.

### Monitoring is part of deployment

Deployment is incomplete without health checks, metrics, logs, and alerting.

### Security should be layered

Security was addressed at application, container, Kubernetes, IAM, storage, networking, and AWS service levels.

### Temporary infrastructure should be disposable

Cloud resources used for learning were destroyed after validation to control cost.

---

# ⚠️ Production Considerations

Although this project follows production-oriented practices, some configurations were intentionally simplified for an internship/lab environment.

For a real production deployment, the following improvements would be appropriate:

* Use a registered production domain
* Use ACM with a validated custom domain
* Use Route 53 for DNS
* Keep all application traffic behind HTTPS
* Restrict security-group ingress
* Avoid exposing backend ports publicly
* Use private subnets for application workloads
* Use managed MongoDB such as MongoDB Atlas or an appropriate AWS architecture
* Use highly available database infrastructure
* Configure automated backups
* Use centralized secrets management
* Add stronger Kubernetes network policies
* Configure PodDisruptionBudgets
* Define resource requests and limits for all workloads
* Add comprehensive CI test stages
* Implement automated rollback
* Use separate AWS accounts/environments for development, staging, and production
* Add centralized log aggregation
* Implement stronger disaster-recovery procedures

---

# 📸 Project Evidence

Screenshots and validation evidence are stored under:

```text
docs/images/
```

Current evidence includes:

* Docker containers running
* Frontend running
* Backend running
* Rootless containers
* Container registries
* GCP Artifact Registry validation

Additional screenshots can be added as the project evolves.

---

# 🐳 Local Docker Compose Quick Start

Clone the repository:

```bash
git clone https://github.com/hzdevops52/ecommerce-deployment.git
cd ecommerce-deployment
```

Create the environment file:

```bash
cp .env.example .env
```

Generate a secure JWT secret:

```bash
openssl rand -hex 32
```

Place the generated value in `.env`.

Start the complete stack:

```bash
docker compose up --build -d
```

Check the services:

```bash
docker compose ps
```

Run the verification script:

```bash
./scripts/verify-compose.sh
```

Frontend:

```text
http://localhost:3000
```

Backend health:

```text
http://localhost:5000/health
```

Stop the stack while preserving MongoDB data:

```bash
docker compose down
```

To intentionally delete the MongoDB volume:

```bash
docker compose down -v
```

> **Warning:** `docker compose down -v` permanently removes the named MongoDB volume and its stored data.

---

# 🛠️ Troubleshooting

## Check container logs

```bash
docker compose logs --tail=100 frontend
docker compose logs --tail=100 backend
docker compose logs --tail=100 mongo
```

## Check running containers

```bash
docker compose ps
```

## Check Kubernetes resources

```bash
kubectl get pods
kubectl get services
kubectl get deployments
kubectl get ingress
```

## Check Terraform

```bash
terraform plan
terraform output
```

Always review a Terraform plan before applying infrastructure changes.

---

# 📈 Project Outcome

The project progressed from a conventional MERN application into a complete DevOps learning environment covering the major stages of a modern software delivery lifecycle:

```text
Source Code
    ↓
Version Control
    ↓
Containerization
    ↓
Local Orchestration
    ↓
Kubernetes
    ↓
Helm
    ↓
CI/CD
    ↓
GitOps
    ↓
Monitoring
    ↓
Infrastructure as Code
    ↓
AWS Cloud
    ↓
Managed Services
    ↓
Secure & Observable Deployment
```

The final repository demonstrates practical experience with:

* Git
* GitHub
* Docker
* Docker Compose
* Kubernetes
* Kind
* Helm
* Jenkins
* Argo CD
* Argo CD Image Updater
* Prometheus
* Grafana
* Terraform
* AWS EC2
* AWS ECS
* AWS EKS
* Amazon ECR
* Amazon RDS
* Amazon S3
* Amazon CloudFront
* AWS Secrets Manager
* CloudWatch
* SNS
* IAM
* VPC networking
* Load balancing
* CI/CD
* GitOps
* Infrastructure as Code

---

# 📄 License

This project is licensed under the [MIT License](./LICENSE).

---

# 👨‍💻 Author

**Hassan Zubair**

BS Information Technology

DevOps / Cloud Engineering

GitHub: `hzdevops52`

---

# ⭐ Final Note

This repository represents the complete DevOps implementation developed throughout the internship.

The goal was not simply to make the application run, but to progressively understand how a software system moves from source code to a repeatable, automated, observable, secure, and cloud-oriented deployment platform.
