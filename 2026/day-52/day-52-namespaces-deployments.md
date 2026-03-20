# Kubernetes Namespaces and Deployments

### Task 1: Explore Default Namespaces
Kubernetes comes with built-in namespaces. List them:

```bash
kubectl get namespaces
```

You should see at least:
- `default` — where your resources go if you do not specify a namespace
- `kube-system` — Kubernetes internal components (API server, scheduler, etc.)
- `kube-public` — publicly readable resources
- `kube-node-lease` — node heartbeat tracking

Check what is running inside `kube-system`:
```bash
kubectl get pods -n kube-system
```
![](./images/task-1/1-1.png) 

These are the control plane components keeping your cluster alive. Do not touch them.

**Verify:** How many pods are running in `kube-system`?

---

### Task 2: Create and Use Custom Namespaces
Create two namespaces — one for a development environment and one for staging:

```bash
kubectl create namespace dev
kubectl create namespace staging
```

Verify they exist:
```bash
kubectl get namespaces
```
![](./images/task-2/2-1.png) 

You can also create a namespace from a manifest:
```yaml
# namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: production
```
![](./images/task-2/2-2.png) 

```bash
kubectl apply -f namespace.yaml
```
Now run a pod in a specific namespace:
```bash
kubectl run nginx-dev --image=nginx:latest -n dev
kubectl run nginx-staging --image=nginx:latest -n staging
```
![](./images/task-2/2-3.png) 

List pods across all namespaces:
```bash
kubectl get pods -A
```
![](./images/task-2/2-4.png) 

Notice that `kubectl get pods` without `-n` only shows the `default` namespace. You must specify `-n <namespace>` or use `-A` to see everything.

**Verify:** Does `kubectl get pods` show these pods? What about `kubectl get pods -A`?

![](./images/task-2/2-5.png) 

---

### Task 3: Create Your First Deployment
A Deployment tells Kubernetes: "I want X replicas of this Pod running at all times." If a Pod crashes, the Deployment controller recreates it automatically.

Create a file `nginx-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80
```
![](./images/task-3/3-1.png) 

Key differences from a standalone Pod:
- `kind: Deployment` instead of `kind: Pod`
- `apiVersion: apps/v1` instead of `v1`
- `replicas: 3` tells Kubernetes to maintain 3 identical pods
- `selector.matchLabels` connects the Deployment to its Pods
- `template` is the Pod template — the Deployment creates Pods using this blueprint

Apply it:
```bash
kubectl apply -f nginx-deployment.yaml
```

Check the result:
```bash
kubectl get deployments -n dev
kubectl get pods -n dev
```
![](./images/task-3/3-2.png) 

You should see 3 pods with names like `nginx-deployment-xxxxx-yyyyy`.

**Verify:** What do the READY, UP-TO-DATE, and AVAILABLE columns mean in the deployment output?

# Breakdown of Deployment Columns

| Column       | Meaning | Example Output | Why It Matters |
|--------------|---------|----------------|----------------|
| **READY**    | Shows the number of pods that are running and have passed readiness probes, compared to the desired replicas. | `3/3` → All 3 desired pods are running and ready.| Ensures our app is actually serving requests, not just running containers. |
| **UP-TO-DATE** | Indicates how many pods have been updated to match the latest deployment spec. | `3` → All pods match the latest deployment spec. | Confirms rollout progress; if less than desired, rollout is still in progress. |
| **AVAILABLE** | Number of pods available to serve traffic (passed readiness and not in crash loop). | `3` → All pods are serving traffic successfully.| Critical for load balancing and user-facing reliability. |

---

### Task 4: Self-Healing — Delete a Pod and Watch It Come Back
This is the key difference between a Deployment and a standalone Pod.

```bash
# List pods
kubectl get pods -n dev

# Delete one of the deployment's pods (use an actual pod name from your output)
kubectl delete pod <pod-name> -n dev

# Immediately check again
kubectl get pods -n dev
```

The Deployment controller detects that only 2 of 3 desired replicas exist and immediately creates a new one. The deleted pod is replaced within seconds.

![](./images/task-4/4-1.png)

**Verify:** Is the replacement pod's name the same as the one you deleted, or different?

👉 Pod names are not reused. Each replacement pod gets a fresh, unique name.

---

### Task 5: Scale the Deployment
Change the number of replicas:

```bash
# Scale up to 5
kubectl scale deployment nginx-deployment --replicas=5 -n dev
kubectl get pods -n dev

# Scale down to 2
kubectl scale deployment nginx-deployment --replicas=2 -n dev
kubectl get pods -n dev
```
![](./images/task-5/5-1.png)

Watch how Kubernetes creates or terminates pods to match the desired count.

You can also scale by editing the manifest — change `replicas: 4` in your YAML file and run `kubectl apply -f nginx-deployment.yaml` again.

![](./images/task-5/5-2.png)

![](./images/task-5/5-3.png)

**Verify:** When you scaled down from 5 to 2, what happened to the extra pods?

👉 When we scale a Deployment down from 5 replicas to 2, Kubernetes reconciles the desired state with the current state. The extra 3 pods are terminated by the ReplicaSet controller.

---

### Task 6: Rolling Update
Update the Nginx image version to trigger a rolling update:

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.25 -n dev
```

Watch the rollout in real time:
```bash
kubectl rollout status deployment/nginx-deployment -n dev
```

Kubernetes replaces pods one by one — old pods are terminated only after new ones are healthy. This means zero downtime.

Check the rollout history:
```bash
kubectl rollout history deployment/nginx-deployment -n dev
```
![](./images/task-6/6-1.png)

Now roll back to the previous version:
```bash
kubectl rollout undo deployment/nginx-deployment -n dev
kubectl rollout status deployment/nginx-deployment -n dev
```

Verify the image is back to the previous version:
```bash
kubectl describe deployment nginx-deployment -n dev | grep Image
```
![](./images/task-6/6-2.png)

**Verify:** What image version is running after the rollback?

![](./images/task-6/6-3.png)
---

### Task 7: Clean Up
```bash
kubectl delete deployment nginx-deployment -n dev
kubectl delete pod nginx-dev -n dev
kubectl delete pod nginx-staging -n staging
kubectl delete namespace dev staging production
```
![](./images/task-7/7-1.png)

Deleting a namespace removes everything inside it. Be very careful with this in production.

```bash
kubectl get namespaces
kubectl get pods -A
```
![](./images/task-7/7-2.png)

**Verify:** Are all your resources gone?

👉 Now we can only see pods running in system namespaces (like DNS, metrics-server, CNI plugins). Nothing from `dev`,`staging`, or `production` will remain.

---