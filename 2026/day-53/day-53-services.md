# Kubernetes Services

### Task 1: Deploy the Application
First, create a Deployment that you will expose with Services. Create `app-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
```
![](./images/task-1/1-1.png)

```bash
kubectl apply -f app-deployment.yaml
kubectl get pods -o wide
```
![](./images/task-1/1-2.png)

Note the individual Pod IPs. These will change if pods restart — that is the problem Services fix.

**Verify:** Are all 3 pods running? Note down their IP addresses.

![](./images/task-1/1-3.png)

---

### Task 2: ClusterIP Service (Internal Access)
ClusterIP is the default Service type. It gives your Pods a stable internal IP that is only reachable from within the cluster.

Create `clusterip-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-clusterip
spec:
  type: ClusterIP
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
```

Key fields:
- `selector.app: web-app` — this Service routes traffic to all Pods with the label `app: web-app`
- `port: 80` — the port the Service listens on
- `targetPort: 80` — the port on the Pod to forward traffic to

![](./images/task-2/2-1.png)

```bash
kubectl apply -f clusterip-service.yaml
kubectl get services
```
![](./images/task-2/2-2.png)

You should see `web-app-clusterip` with a CLUSTER-IP address. This IP is stable — it will not change even if Pods restart.

Now test it from inside the cluster:
```bash
# Run a temporary pod to test connectivity
kubectl run test-client --image=busybox:latest --rm -it --restart=Never -- sh

# Inside the test pod, run:
wget -qO- http://web-app-clusterip
exit
```
You should see the Nginx welcome page. The Service load-balanced your request to one of the 3 Pods.

![](./images/task-2/2-3.png)

**Verify:** Does the Service respond? Try running the wget command multiple times — the Service distributes traffic across all healthy Pods.

---

### Task 3: Discover Services with DNS
Kubernetes has a built-in DNS server. Every Service gets a DNS entry automatically:

```
<service-name>.<namespace>.svc.cluster.local
```

Test this:
```bash
kubectl run dns-test --image=busybox:latest --rm -it --restart=Never -- sh

# Inside the pod:
# Short name (works within the same namespace)
wget -qO- http://web-app-clusterip

# Full DNS name
wget -qO- http://web-app-clusterip.default.svc.cluster.local

# Look up the DNS entry
nslookup web-app-clusterip
exit
```
![](./images/task-3/3-1.png)

![](./images/task-3/3-2.png)

Both the short name and the full DNS name resolve to the same ClusterIP. In practice, you use the short name when communicating within the same namespace and the full name when reaching across namespaces.

**Verify:** What IP does `nslookup` return? Does it match the CLUSTER-IP from `kubectl get services`?

![](./images/task-3/3-3.png)

![](./images/task-3/3-4.png)

---

### Task 4: NodePort Service (External Access via Node)
A NodePort Service exposes your application on a port on every node in the cluster. This lets you access the Service from outside the cluster.

Create `nodeport-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-nodeport
spec:
  type: NodePort
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
```

- `nodePort: 30080` — the port opened on every node (must be in range 30000-32767)
- Traffic flow: `<NodeIP>:30080` -> Service -> Pod:80

![](./images/task-4/4-1.png)

```bash
kubectl apply -f nodeport-service.yaml
kubectl get services
```
![](./images/task-4/4-2.png)

Access the service:
```bash
# If using Minikube
minikube service web-app-nodeport --url

# If using Kind, get the node IP first
kubectl get nodes -o wide
# Then curl <node-internal-ip>:30080

# If using Docker Desktop
curl http://localhost:30080
```
![](./images/task-4/4-3.png)

**Verify:** Can you see the Nginx welcome page from your browser or terminal using the NodePort?

![](./images/task-4/4-4.png)

---

### Task 5: LoadBalancer Service (Cloud External Access)
In a cloud environment (AWS, GCP, Azure), a LoadBalancer Service provisions a real external load balancer that routes traffic to your nodes.

Create `loadbalancer-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
```
![](./images/task-5/5-1.png)

```bash
kubectl apply -f loadbalancer-service.yaml
kubectl get services
```
![](./images/task-5/5-2.png)

On a local cluster (Minikube, Kind, Docker Desktop), the EXTERNAL-IP will show `<pending>` because there is no cloud provider to create a real load balancer. This is expected.

If you are using Minikube:
```bash
# Minikube can simulate a LoadBalancer
minikube tunnel
# In another terminal, check again:
kubectl get services
```

In a real cloud cluster, the EXTERNAL-IP would be a public IP address or hostname provisioned by the cloud provider.

**Verify:** What does the EXTERNAL-IP column show? Why is it `<pending>` on a local cluster?

**What the EXTERNAL-IP Column Shows**
- 	The **EXTERNAL-IP** field in `kubectl get services` represents the public IP address assigned to a service of type LoadBalancer.
- 	This is the IP that external clients (outside the cluster) would use to access our service.
- 	For **ClusterIP** and **NodePort** services, this field is usually `<none>` because they don’t automatically get a public IP.

⚠️ **Why It’s `<pending>` on a Local Cluster**
- 	In cloud environments (AWS, GCP, Azure), the Kubernetes control plane integrates with the cloud provider’s load balancer service. When we create a **LoadBalancer** service, the cloud provider provisions a real external IP.
-	On a **local cluster** (like Minikube, kind, or Docker Desktop), there’s no cloud provider to allocate a load balancer. Kubernetes still tries to request one, but since there’s no external load balancer integration, the IP stays `<pending>` indefinitely.
- 	That’s why we see `<pending>` — our cluster doesn’t have the infrastructure to assign a real external IP.

---

### Task 6: Understand the Service Types Side by Side
Check all three services:

```bash
kubectl get services -o wide
```
![](./images/task-6/6-1.png)

Compare them:

| Type | Accessible From | Use Case |
|------|----------------|----------|
| ClusterIP | Inside the cluster only | Internal communication between services |
| NodePort | Outside via `<NodeIP>:<NodePort>` | Development, testing, direct node access |
| LoadBalancer | Outside via cloud load balancer | Production traffic in cloud environments |

Each type builds on the previous one:
- LoadBalancer creates a NodePort, which creates a ClusterIP
- So a LoadBalancer service also has a ClusterIP and a NodePort

Verify this:
```bash
kubectl describe service web-app-loadbalancer
```
![](./images/task-6/6-2.png) 

You should see all three: a ClusterIP, a NodePort, and the LoadBalancer configuration.

**Verify:** Does the LoadBalancer service also have a ClusterIP and NodePort assigned?

👉 Yes — **a LoadBalancer service in Kubernetes actually includes both a ClusterIP and a NodePort under the hood**.

---

### Task 7: Clean Up
```bash
kubectl delete -f app-deployment.yaml
kubectl delete -f clusterip-service.yaml
kubectl delete -f nodeport-service.yaml
kubectl delete -f loadbalancer-service.yaml

kubectl get pods
kubectl get services
```

Only the built-in `kubernetes` service in the default namespace should remain.

![](./images/task-7/7-1.png)

**Verify:** Is everything cleaned up?

✅ Yes, everything looks fully cleaned up.

Here’s a quick summary of what we’ve done:

- 	Deleted the **web-app deployment** and all three service types: `ClusterIP`,`NodePort`, and `LoadBalancer`.
- 	Verified with `kubectl get pods` → no pods remain.
- 	Verified with `kubectl get services` → only the default `kubernetes` service is left.

This means our namespace is now clean and ready for a fresh deployment. If we’re planning to redeploy or restructure our services, we’re starting from a blank slate.


---
