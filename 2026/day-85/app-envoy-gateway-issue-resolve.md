# App Envoy Gateway Issue Resolution

This Root Cause Analysis (RCA) document outlines the conflict between manual resource management and GitOps enforcement, and the verified resolution steps we implemented.

## 1. The Incident
The **envoy-gateway** application was stuck in an *OutOfSync* state in ArgoCD.  
Attempts to force a sync failed with the error:

```bash
 Deployment.apps "envoy-gateway" is invalid: spec.selector: Invalid value: ... field is immutable
 ```

## 2. The Root Cause
- **Manual vs. GitOps State Mismatch**  
  The Envoy Gateway was initially installed manually via Helm (**v1.2.6**). When the ArgoCD Application attempted to manage the same deployment, it tried to enforce its own `spec.selector` labels.

- **Kubernetes Immutability**  
  Kubernetes forbids changing the `spec.selector` of a Deployment after it has been created. Because the labels in the ArgoCD-managed Helm chart differed slightly from the labels applied by the manual Helm install, the API server rejected the update.

- **Ownership Conflict**  
  The existing resources were labeled with `app.kubernetes.io/managed-by=Helm`, which signaled to Kubernetes and ArgoCD that the resources were already owned, creating a conflict when ArgoCD tried to apply its own server-side configurations.

## 3. Working Solution
We performed a **non-disruptive adoption**, breaking the link to the old management configuration and allowing ArgoCD to "claim" the running infrastructure.

## 4. Final Remediation Steps

### Step 1: Orphan the Deployment
Delete the Deployment object from the API while keeping the Pods alive:

```bash
kubectl delete deployment envoy-gateway -n envoy-gateway-system --cascade=orphan
```
This ensured zero downtime for existing traffic.

### Step 2: Strip Legacy Ownership
Remove the Helm-specific management label:

```bash
kubectl label deployment envoy-gateway -n envoy-gateway-system app.kubernetes.io/managed-by-
```

### Step 3: Synchronize with ArgoCD
Trigger a sync to create a fresh Deployment object:

```bash
argocd app sync envoy-gateway
```

### Step 4: Adopt Running Pods
Because the new Deployment’s `spec.selector` matched the labels on the already-running Pods, the new Deployment **adopted them immediately.**


### 5. Prevention Strategy
To avoid recurrence, we updated the GitOps manifest to:

- **Set metadata overrides**  
Use `fullnameOverride` and `nameOverride` to ensure generated labels always match the expected format.

- **Disable CRD management**
Explicitly set `crds.install: "false"` to prevent ArgoCD from re-applying cluster-wide resources already managed manually or at a higher level.

- **Prioritize ServerSideApply**
Use `ServerSideApply=true` to allow ArgoCD to merge its changes with existing cluster state more gracefully than the standard strategic merge patch.

---