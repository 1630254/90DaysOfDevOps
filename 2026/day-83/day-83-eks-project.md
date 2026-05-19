# EKS Project: Production Deployment of AI-BankApp

### Task 1: Deploy the Complete AI-BankApp Stack
Make sure your EKS cluster is running:
```bash
kubectl get nodes
```

If you destroyed the cluster, re-provision it:
```bash
cd AI-BankApp-DevOps/terraform
terraform apply
aws eks update-kubeconfig --name bankapp-eks --region us-west-2
```
![](./images/task-1/1-1.png)

Deploy the entire application stack in order:
```bash
cd AI-BankApp-DevOps

# 1. Namespace and storage
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/pv.yml
kubectl apply -f k8s/pvc.yml

# 2. Configuration
kubectl apply -f k8s/configmap.yml
kubectl apply -f k8s/secrets.yml

# 3. Database and AI service
kubectl apply -f k8s/mysql-deployment.yml
kubectl apply -f k8s/service.yml
kubectl apply -f k8s/ollama-deployment.yml


# 4. Wait for dependencies
echo "Waiting for MySQL..."
kubectl wait --for=condition=ready pod -l app=mysql -n bankapp --timeout=120s

echo "Waiting for Ollama (this takes 2-5 minutes for model pull)..."
kubectl wait --for=condition=ready pod -l app=ollama -n bankapp --timeout=600s

# 5. Application
kubectl apply -f k8s/bankapp-deployment.yml
kubectl apply -f k8s/hpa.yml

# 6. Wait for BankApp
echo "Waiting for BankApp..."
kubectl wait --for=condition=ready pod -l app=bankapp -n bankapp --timeout=300s
```
> Note:If the BankApp gives timeout error we can patch this immediately to see our pods go green, we can use kubectl expose to generate the service on the fly:

```bash
kubectl expose deployment ollama --name=ollama-service --port=11434 --target-port=11434 -n bankapp
```

![](./images/task-1/1-2.png)

![](./images/task-1/1-3.png)

![](./images/task-1/1-4.png)

Verify everything is running:
```bash
kubectl get all -n bankapp
kubectl get pvc -n bankapp
```
![](./images/task-1/1-5.png)

You should see:
- MySQL: 1 pod running with 5Gi PVC bound
- Ollama: 1 pod running with 10Gi PVC bound
- BankApp: 2-4 pods running (managed by HPA)
- Services: 3 ClusterIP services

---

### Task 2: Set Up Gateway API and Access the App
Install Envoy Gateway (if not done on Day 82):
```bash
helm install envoy-gateway oci://docker.io/envoyproxy/gateway-helm \
  --version v1.4.0 \
  -n envoy-gateway-system --create-namespace \
  --wait 2>/dev/null || echo "Already installed"
```

Apply the Gateway configuration:
```bash
kubectl apply -f k8s/gateway.yml
```
![](./images/task-2/2-1.png)

Wait for the NLB:
```bash
kubectl get gateway -n bankapp -w
```

Get the external address:
```bash
export APP_URL=$(kubectl get gateway bankapp-gateway -n bankapp -o jsonpath='{.status.addresses[0].value}')
echo "AI-BankApp URL: http://$APP_URL"
```
![](./images/task-2/2-2.png)

Test the application:
```bash
# Health check (Spring Boot Actuator)
curl -s http://$APP_URL/actuator/health | python3 -m json.tool

# Load the home page
curl -s -o /dev/null -w "%{http_code}" http://$APP_URL
```

![](./images/task-2/2-3.png)

Open `http://$APP_URL` in your browser:
1. Click "Register" and create an account
2. Log in with your credentials
3. Perform banking operations (deposit, withdraw, transfer)
4. Try the AI chatbot -- ask a financial question
5. Toggle dark/light mode

![](./images/task-2/2-4.png)

![](./images/task-2/2-5.png)

![](./images/task-2/2-6.png)

![](./images/task-2/2-7.png)

![](./images/task-2/2-8.png)


**The full stack is running on EKS:** Spring Boot serves the UI, MySQL stores accounts and transactions, Ollama's TinyLlama model powers the AI chatbot -- all on managed Kubernetes with persistent storage and autoscaling.

---

### Task 3: Deploy the Monitoring Stack
Deploy Prometheus and Grafana to monitor the AI-BankApp on EKS.

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace \
  --set grafana.adminPassword=admin123 \
  --set prometheus.prometheusSpec.retention=3d \
  --set prometheus.prometheusSpec.resources.requests.memory=256Mi \
  --set prometheus.prometheusSpec.resources.requests.cpu=100m \
  --wait --timeout 600s
```
![](./images/task-3/3-1.png)

![](./images/task-3/3-2.png)

Verify:
```bash
kubectl get pods -n monitoring
```
![](./images/task-3/3-3.png)

**Access Grafana:**
```bash
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80
```
![](./images/task-3/3-4.png)

Open `http://localhost:3000`. Login: `admin` / `admin123`.

**The AI-BankApp exposes Prometheus metrics natively.** The Spring Boot Actuator endpoint at `/actuator/prometheus` provides JVM metrics, HTTP request metrics, and more.

![](./images/task-3/3-5.png)

![](./images/task-3/3-6.png)

Create a ServiceMonitor to scrape the BankApp:
```yaml
# bankapp-servicemonitor.yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: bankapp-monitor
  namespace: monitoring
  labels:
    release: monitoring
spec:
  namespaceSelector:
    matchNames:
      - bankapp
  selector:
    matchLabels:
      app: bankapp
  endpoints:
    - port: "8080"
      path: /actuator/prometheus
      interval: 15s
```
> To make this work we need to update both `k8s/service.yaml` and `bankapp-servicemonitor.yaml` accordingly

```yaml
# k8s/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: bankapp-service
  namespace: bankapp
  labels:
    app: bankapp
spec:
  type: ClusterIP
  selector:
    app: bankapp
  ports:
    - name: http
      port: 8080
      targetPort: 8080
```
```yaml
# bankapp-servicemonitor.yaml
spec:
  namespaceSelector:
    matchNames:
      - bankapp
  selector:
    matchLabels:
      app: bankapp
  endpoints:
    - port: http
      path: /actuator/prometheus
      interval: 15s
```
```bash
kubectl apply -f bankapp-servicemonitor.yaml
```

**Access Prometheus:**
```bash
kubectl port-forward svc/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090
```
![](./images/task-3/3-7.png)


Query AI-BankApp metrics:
```promql
# JVM memory usage
jvm_memory_used_bytes{namespace="bankapp"}

# HTTP request rate
rate(http_server_requests_seconds_count{namespace="bankapp"}[5m])

# HTTP request latency (95th percentile)
histogram_quantile(0.95, rate(http_server_requests_seconds_bucket{namespace="bankapp"}[5m]))

The 95th percentile latency metric could not be calculated because http_server_requests_seconds_bucket histogram metrics were disabled; average latency values were substituted.

Resolution: Set management.metrics.distribution.percentiles-histogram.http.server.requests=true within application.properties and redeployed the application.

rate(http_server_requests_seconds_sum[5m]) /
rate(http_server_requests_seconds_count[5m])
```

![](./images/task-3/3-8.png)

![](./images/task-3/3-9.png)

![](./images/task-3/3-10.png)

Explore the pre-built Grafana dashboards:
- **Kubernetes / Compute Resources / Namespace (Pods)** -- select the `bankapp` namespace
- **Kubernetes / Compute Resources / Pod** -- drill into individual pods
- **Node Exporter / Nodes** -- EKS worker node health

![](./images/task-3/3-11.png)

![](./images/task-3/3-12.png)

![](./images/task-3/3-13.png)

![](./images/task-3/3-14.png)

![](./images/task-3/3-15.png)

![](./images/task-3/3-16.png)

![](./images/task-3/3-17.png)

---

### Task 4: End-to-End Validation Checklist
Run through the complete validation:

**Application layer:**
```bash
# All pods running and ready
kubectl get pods -n bankapp
echo "---"

# App responds on health endpoint
curl -s http://$APP_URL/actuator/health
echo "---"

# HPA is active and monitoring CPU
kubectl get hpa -n bankapp
echo "---"

# Prometheus metrics endpoint works
curl -s http://$APP_URL/actuator/prometheus | head -10
```
![](./images/task-4/4-1.png)

**Data layer:**
```bash
# MySQL is healthy with persistent storage
kubectl exec -n bankapp deploy/mysql -- mysqladmin ping -h localhost -uroot -pTest@123
echo "---"

# PVCs are bound to EBS volumes
kubectl get pvc -n bankapp
echo "---"

# Ollama has the model loaded
kubectl exec -n bankapp deploy/ollama -- ollama list
```
![](./images/task-4/4-2.png)

**Infrastructure layer:**
```bash
# Nodes are healthy
kubectl get nodes
kubectl top nodes
echo "---"

# Gateway is serving traffic
kubectl get gateway -n bankapp
echo "---"

# Monitoring is running
kubectl get pods -n monitoring | head -5
```
![](./images/task-4/4-3.png)

**Security layer:**
```bash
# BankApp runs as non-root (devsecops user)
kubectl exec -n bankapp deploy/bankapp -- whoami

# Secrets are not exposed in environment
kubectl get secret bankapp-secret -n bankapp -o yaml | grep -c "MYSQL_ROOT_PASSWORD"
```
![](./images/task-4/4-4.png)
---

### Task 5: Reflect on the Full EKS Journey
Map each concept to the day you learned it:

| Day | What You Built | AI-BankApp Connection |
|-----|---------------|----------------------|
| 81 | EKS cluster via Terraform, kubectl connection, manual deploy | Used the project's `terraform/` configs to provision infra |
| 82 | Gateway API, Envoy, TLS, EBS storage, session persistence | Used `k8s/gateway.yml`, `k8s/cert-manager.yml`, `k8s/pv.yml` |
| 83 | Full production deployment, monitoring, validation | Complete stack: app + DB + AI + networking + observability |

**What the AI-BankApp's EKS setup includes that you have now seen:**
- Terraform-provisioned VPC with 3-AZ networking
- Managed node group with auto-scaling
- 6 EKS add-ons (CoreDNS, VPC CNI, kube-proxy, Pod Identity, EBS CSI, Metrics Server)
- ArgoCD pre-installed (used on Days 84-86)
- Gateway API with Envoy for traffic management
- cert-manager for automated HTTPS
- Cookie-based session persistence for stateful app
- EBS persistent storage for MySQL and Ollama
- HPA with scale-up/down policies
- Spring Boot Actuator metrics for Prometheus
- Init containers for dependency ordering
- PostStart lifecycle hooks for Ollama model pull

**What you would add for a real production deployment:**
- DNS with Route 53 and ExternalDNS
- Network Policies for pod-to-pod isolation
- Pod Disruption Budgets for safe node draining
- External Secrets Operator for AWS Secrets Manager integration
- Database backups (automated MySQL dumps to S3)
- Log aggregation with Loki (you built this on Day 75)
- Multi-environment clusters (dev + prod)

---

### Task 6: Complete Teardown
**This is critical -- do not leave resources running.**

Delete workloads first:
```bash
# Delete monitoring
helm uninstall monitoring -n monitoring

# Delete Gateway resources (releases the NLB)
kubectl delete -f k8s/gateway.yml 2>/dev/null

# Delete the BankApp stack
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

# Delete Envoy Gateway
helm uninstall envoy-gateway -n envoy-gateway-system 2>/dev/null

# Delete cert-manager
helm uninstall cert-manager -n cert-manager 2>/dev/null

# Delete namespaces
kubectl delete namespace monitoring envoy-gateway-system cert-manager 2>/dev/null
```
![](./images/task-6/6-1.png)

![](./images/task-6/6-2.png)

Wait for all LoadBalancers and EBS volumes to be released:
```bash
# Check for lingering load balancers
kubectl get svc -A | grep LoadBalancer

# Check for lingering PVCs
kubectl get pvc -A
```
![](./images/task-6/6-3.png)

**Destroy the infrastructure with Terraform:**
```bash
cd terraform
terraform destroy
```

This takes 10-15 minutes. It deletes:
- EKS cluster and control plane
- All node groups and EC2 instances
- ArgoCD Helm release
- VPC, subnets, NAT gateway, internet gateway
- IAM roles and policies

**Verify in the AWS Console:**
- EKS: no clusters
- EC2: no instances, no load balancers, no EBS volumes
- VPC: the `bankapp-eks` VPC is gone
- CloudFormation: no lingering stacks

![](./images/task-6/6-4.png)

![](./images/task-6/6-5.png)

![](./images/task-6/6-6.png)

![](./images/task-6/6-7.png)

![](./images/task-6/6-8.png)

![](./images/task-6/6-9.png)

**Check your AWS bill** in the Billing Dashboard. All charges should stop within the hour.

![](./images/task-6/6-11.png)

**Cost for this 3-day lab (approximate):** $15-25 depending on how long you kept the cluster running.

![](./images/task-6/6-10.png)

---