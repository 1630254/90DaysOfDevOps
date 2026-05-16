# Introduction to Amazon EKS with Terraform

### Task 1: Understand EKS Architecture
Research and write notes on:

1. **What does "managed Kubernetes" mean?**
   - AWS manages the **control plane** (API server, etcd, scheduler, controller manager)
   - You manage the **data plane** (worker nodes where your pods run)
   - AWS handles control plane upgrades, patching, and high availability across multiple AZs

2. **EKS components:**
   - **EKS Control Plane** -- managed by AWS, runs in AWS-owned VPC, accessible via API endpoint
   - **Node Groups** -- EC2 instances that run your pods
     - **Managed Node Groups** -- AWS handles provisioning, scaling, and updates
     - **Self-Managed Nodes** -- you manage the EC2 instances yourself
     - **Fargate Profiles** -- serverless, no nodes to manage at all
   - **VPC and Networking** -- EKS runs inside your VPC with subnets across AZs
   - **IAM Integration** -- EKS uses IAM roles for cluster access and pod-level permissions (IRSA)

3. **EKS add-ons the AI-BankApp uses** (from `terraform/eks.tf`):
   - `coredns` -- DNS resolution inside the cluster
   - `kube-proxy` -- network routing for services
   - `vpc-cni` -- AWS VPC CNI plugin, assigns VPC IPs to pods
   - `eks-pod-identity-agent` -- enables pod-level IAM roles
   - `aws-ebs-csi-driver` -- allows pods to use EBS volumes (needed for MySQL and Ollama storage)
   - `metrics-server` -- enables `kubectl top` and HPA

---

### Task 2: Study the AI-BankApp Terraform Configuration
Clone the repo and examine the `terraform/` directory:

```bash
git clone -b feat/gitops https://github.com/TrainWithShubham/AI-BankApp-DevOps.git
cd AI-BankApp-DevOps/terraform
ls
```
![](./images/task-2/2.1.png)

```
argocd.tf           # ArgoCD Helm release
eks.tf              # EKS cluster + node group + IRSA
outputs.tf          # Cluster info and helper commands
provider.tf         # AWS + Helm providers, locals
terraform.tfvars    # Default variable values
variables.tf        # Input variables
vpc.tf              # VPC with public/private/intra subnets
```

**Study each file and understand what it provisions:**

**`variables.tf` and `terraform.tfvars`:**
```hcl
# The defaults:
aws_region         = "us-west-2"
cluster_name       = "bankapp-eks"
cluster_version    = "1.35"
node_instance_type = "t3.medium"
node_desired_count = 3
node_max_count     = 5
```

**`vpc.tf`** -- Networking foundation:
- Uses the `terraform-aws-modules/vpc/aws` module
- 3 Availability Zones with:
  - **Public subnets** (10.0.1-3.0/24) -- for load balancers, tagged with `kubernetes.io/role/elb`
  - **Private subnets** (10.0.4-6.0/24) -- for worker nodes, tagged with `kubernetes.io/role/internal-elb`
  - **Intra subnets** (10.0.7-9.0/24) -- for EKS control plane ENIs
- NAT Gateway enabled for outbound internet from private subnets

**`eks.tf`** -- The cluster itself:
- Uses the `terraform-aws-modules/eks/aws` module (version ~> 21.0)
- AL2023 AMI for nodes (Amazon Linux 2023)
- 3x `t3.medium` instances (min 3, max 5)
- All 6 EKS add-ons installed as cluster add-ons
- IRSA configured for the EBS CSI driver
- Public + private API endpoint access

**`argocd.tf`** -- ArgoCD via Helm:
- Installs ArgoCD using the `argo-cd` Helm chart
- Exposed as a LoadBalancer service
- Depends on the EKS module (created after the cluster is ready)

**`outputs.tf`** -- Helper commands:
- Outputs the `aws eks update-kubeconfig` command
- Outputs the ArgoCD initial password retrieval command

**Document:** Draw the architecture: VPC -> Subnets -> EKS Control Plane -> Node Group -> Pods

![](./images/task-2/2.2.png)

---

### Task 3: Provision the EKS Cluster
Make sure you have the required tools:
```bash
terraform --version    # >= 1.0
aws --version          # AWS CLI v2
kubectl version --client
helm version
```
![](./images/task-3/3-1.png)

Configure AWS credentials:
```bash
aws configure
# Enter: Access Key ID, Secret Access Key, Region (us-west-2), Output (json)

# Verify
aws sts get-caller-identity
```
![](./images/task-3/3-2.png)

Initialize and apply:
```bash
cd terraform

terraform init
terraform plan
```

Review the plan carefully. It will create:
- 1 VPC with 9 subnets, NAT gateway, internet gateway
- 1 EKS cluster with control plane
- 1 managed node group (3x t3.medium)
- 6 EKS add-ons
- IAM roles and policies for the cluster, nodes, and EBS CSI driver
- ArgoCD Helm release

```bash
terraform apply
```

This takes 15-20 minutes. While waiting, review the Terraform output for CloudFormation-like progress.

After completion, note the outputs:
```bash
terraform output
```
![](./images/task-3/3-3.png)

---

### Task 4: Connect to Your Cluster
Update kubeconfig using the Terraform output:
```bash
aws eks update-kubeconfig --name bankapp-eks --region us-west-2
```
![](./images/task-4/4-1.png)

Verify the connection:
```bash
# Check context
kubectl config current-context

# Cluster info
kubectl cluster-info

# List nodes
kubectl get nodes -o wide
```
You should see 3 nodes with status `Ready`, instance type `t3.medium`, spread across 3 AZs.

![](./images/task-4/4-2.png)

![](./images/task-4/4-3.png)

Explore the cluster:
```bash
# System pods
kubectl get pods -n kube-system

# All the add-ons are running
kubectl get daemonsets -n kube-system

# EBS CSI driver
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver

# Metrics server (enables kubectl top and HPA)
kubectl top nodes
```
![](./images/task-4/4-4.png)

Check ArgoCD is running:
```bash
kubectl get pods -n argocd
kubectl get svc -n argocd
```
![](./images/task-4/4-5.png)

Get the ArgoCD admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
![](./images/task-4/4-6.png)

Get the ArgoCD LoadBalancer URL:
```bash
kubectl get svc -n argocd argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```
![](./images/task-4/4-7.png)

Open the URL in your browser and log in with `admin` and the password from above. You will use ArgoCD on Days 84-86.

![](./images/task-4/4-8.png)

![](./images/task-4/4-9.png)

---

### Task 5: Deploy the AI-BankApp Manually (Before ArgoCD)
Before setting up GitOps, deploy the app manually to validate the cluster works.

Apply the raw manifests from the `k8s/` directory:
```bash
cd ../  # Back to the repo root

kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/pv.yml
kubectl apply -f k8s/pvc.yml
kubectl apply -f k8s/configmap.yml
kubectl apply -f k8s/secrets.yml
kubectl apply -f k8s/mysql-deployment.yml
kubectl apply -f k8s/service.yml
kubectl apply -f k8s/ollama-deployment.yml
kubectl apply -f k8s/bankapp-deployment.yml
kubectl apply -f k8s/hpa.yml
```
![](./images/task-5/5-1.png)

Watch the pods come up:
```bash
kubectl get pods -n bankapp -w
```
![](./images/task-5/5-2.png)

The startup order is:
1. MySQL starts and becomes healthy (15-30 seconds)
2. Ollama starts and pulls the TinyLlama model (2-5 minutes)
3. BankApp init containers wait for both, then the app starts (30-60 seconds after dependencies)

Check PVCs are bound to EBS volumes:
```bash
kubectl get pvc -n bankapp
kubectl get pv
```
You should see 5Gi and 10Gi EBS volumes in the correct AZs.

![](./images/task-5/5-3.png)

Once all pods are running, access the app:
```bash
kubectl port-forward svc/bankapp-service -n bankapp 8080:8080
```
![](./images/task-5/5-6.png)

Open `http://localhost:8080` -- you should see the AI-BankApp login page. Register an account, log in, and try the AI chatbot.

![](./images/task-5/5-4.png)

![](./images/task-5/5-5.png)

**Verify the HPA:**
```bash
kubectl get hpa -n bankapp
```
![](./images/task-5/5-7.png)
---

### Task 6: Understand EKS Costs and Clean Up Strategy
EKS is not free. The AI-BankApp cluster costs:

| Component                   | Cost Specification                                         | Monthly Total (Approx.)        |
|-----------------------------|------------------------------------------------------------|--------------------------------|
| **EKS Control Plane**       | Standard Support Tier ($0.10/hr)                           | ~$73.00                        |
| **t3.medium Worker Nodes (3x)** | On-Demand ($0.0416/hr each)                            | ~$91.10                        |
| **NAT Gateway**             | Base hourly fee ($0.045/hr) + baseline data processing     | ~$33.00                        |
| **EBS Storage volumes**     | 15 GiB total GP3 storage allocation ($0.08/GB-month)       | ~$1.20                         |
| **Application Load Balancer** | ArgoCD ingress baseline ($0.0225/hr + minimal LCU)       | ~$20.50                        |
| **Public IPv4 Addresses**   | Charged per public interface (3x nodes + 1x NAT = 4 IPs)   | ~$14.60                        |
| **Total Lab Infrastructure**| **Estimated Run Rate**                                     | **~$233.40 / month**<br>*(~$7.78 / day)* |


**Important:** Do NOT leave the cluster running when you are not using it.

Delete the BankApp workload (keep the cluster for Days 82-83):
```bash
kubectl delete -f k8s/hpa.yml
kubectl delete -f k8s/bankapp-deployment.yml
kubectl delete -f k8s/ollama-deployment.yml
kubectl delete -f k8s/mysql-deployment.yml
kubectl delete -f k8s/service.yml
kubectl delete -f k8s/secrets.yml
kubectl delete -f k8s/configmap.yml
kubectl delete -f k8s/pvc.yml
kubectl delete -f k8s/pv.yml
kubectl delete -f k8s/namespace.yml
```
![](./images/task-6/6-1.png)

To destroy everything (do this at the end of Day 83 or if taking a break):
```bash
cd terraform
terraform destroy
```

**Document:** What are the cost components of the AI-BankApp EKS setup? Why is the NAT Gateway surprisingly expensive?

👉 Here is the direct breakdown of the five core cost components for our AI-BankApp EKS setup:

- **EKS Control Plane:** A flat fee of **$0.10/hour** (~$73/month) charged by AWS to manage the Kubernetes API and master nodes.

- **Worker Nodes (EC2 Compute):** The hourly cost of the virtual machines (like our t3.medium instances) running our active application, database, and Ollama pods.

- **VPC NAT Gateways:** A baseline fee of **$0.045/hour per gateway plus** a **$0.045/GB data processing fee** for all outbound traffic from private subnets (such as pulling large LLM models or Docker images).

- **Persistent Storage (EBS):** The monthly per-GB cost (~$0.08/GB for `gp3`) used for node boot disks, the MySQL database state, and the cached AI model weights.

- **Load Balancer (ALB):** A baseline hourly fee (~$16–$22/month) plus usage metrics to securely route external user traffic into our `bankapp-service`.


👉 The NAT Gateway is surprisingly expensive because AWS charges you twice for it:

- 1. **Uptime Fee:** 

- 2. **Data Processing Fee:** An extra **$0.045 per GB** for all data passing through it. This includes internal traffic like pulling large container images or downloading massive AI model weights (like for `ollama`) from external registries into your private subnets.

---
