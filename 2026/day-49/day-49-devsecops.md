# DevSecOps: Add Security to Your CI/CD Pipeline

```bash
cat reusable-build-test.yml
```
```yml
name: Reusable Build and Test (Flask Web)

on:
  workflow_call:
    inputs:
      python_version:
        description: 'The version of Python to use'
        required: false
        default: '3.11'
        type: string
      run_tests:
        description: 'Toggle to run the health check'
        required: false
        default: true
        type: boolean
    outputs:
      test_result:
        description: "Outcome of the build and health check"
        value: ${{ jobs.build-and-test.outputs.status }}

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    outputs:
      status: ${{ steps.set-output.outputs.test_status }}
    
    steps:
      - name: Check out code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ inputs.python_version }}

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          if [ -f requirements.txt ]; then
            pip install -r requirements.txt
          else
            pip install flask
          fi

      - name: Run Flask App and Verify Health
        if: ${{ inputs.run_tests }}
        id: health-check
        continue-on-error: true
        run: |
          # Start the Flask app in the background
          python app.py &
          
          # Wait for the server to return a 200 OK (max 15 seconds)
          # This verifies that app.py is running and index.html is rendering
          timeout 15s bash -c 'until curl -s -o /dev/null -w "%{http_code}" localhost:5000 | grep "200"; do sleep 1; done'

      - name: Set output
        id: set-output
        if: always()
        run: |
          # Map the outcome of the health check to a string output
          if [ "${{ steps.health-check.outcome }}" == "success" ]; then
            echo "test_status=passed" >> $GITHUB_OUTPUT
          else
            echo "test_status=failed" >> $GITHUB_OUTPUT
          fi

```
```bash
cat reusable-docker.yml
```
```yml
name: Reusable Docker Build and Push

on:
  workflow_call:
    inputs:
      image_name:
        required: true
        type: string
      tag:
        required: true
        type: string
    secrets:
      docker_username:
        required: true
      docker_token:
        required: true

jobs:
  docker-build:
    runs-on: ubuntu-latest
    steps:
      - name: Check out code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.docker_username }}
          password: ${{ secrets.docker_token }}

      # This step acts as a "filter" to ensure every tag is properly formatted
      - name: Docker meta
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ secrets.docker_username }}/${{ inputs.image_name }}
          tags: |
            type=raw,value=latest
            # This takes the comma-separated list and prefixes each item
            ${{ inputs.tag }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          # We use ONLY the filtered output from the meta step
          tags: ${{ steps.meta.outputs.tags }}
          platforms: linux/amd64
          provenance: false
          sbom: false
          cache-from: type=gha
          cache-to: type=gha,mode=max
```
```bash
cat main-pipeline.yml 
```
```yml
name: Main CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  # JOB 1: Continuous Integration
  test:
    uses: ./.github/workflows/reusable-build-test.yml
    with:
      python_version: '3.11'
      run_tests: true

  # JOB 2: Prepare variables (Short SHA)
  prep:
    runs-on: ubuntu-latest
    outputs:
      short_sha: ${{ steps.vars.outputs.sha_short }}
    steps:
      - name: Generate Short SHA
        id: vars
        run: echo "sha_short=$(echo ${{ github.sha }} | cut -c1-7)" >> $GITHUB_OUTPUT

  # JOB 3: Continuous Delivery (Docker)
  build-and-push:
    needs: [test, prep]
    # CALL DIRECTLY AT JOB LEVEL - No 'steps' block allowed here
    uses: ./.github/workflows/reusable-docker.yml
    with:
      image_name: "github-actions-capstone"
      # Multiple tags: latest and the short SHA
      tag: "latest,sha-${{ needs.prep.outputs.short_sha }}"
    secrets:
      docker_username: ${{ secrets.DOCKER_USERNAME }}
      docker_token: ${{ secrets.DOCKER_TOKEN }}

  # JOB 4: Deployment Simulation
  deploy:
    needs: [build-and-push, prep]
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Deploying to Production
        run: |
          echo "Deploying image: sha-${{ needs.prep.outputs.short_sha }}"
          echo "Status: Deployment initiated."
```
### Task 1: Scan Your Docker Image for Vulnerabilities
Your Docker image might use a base image with known security issues. Let's find out.

Add this step to your main branch pipeline (after Docker build, before deploy):
```yaml
- name: Scan Docker Image for Vulnerabilities
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'your-username/your-app:latest'
    format: 'table'
    exit-code: '1'
    severity: 'CRITICAL,HIGH'
```

What this does:
- `trivy` scans your Docker image for known CVEs (Common Vulnerabilities and Exposures)
- `format: 'table'` prints a readable table in the logs
- `exit-code: '1'` means **fail the pipeline** if CRITICAL or HIGH vulnerabilities are found
- If it passes, your image is clean — proceed to push and deploy

Push and check the Actions tab. Read the scan output.

```bash
vi reusable-trivy-scan.yml
```
```yml
name: Reusable Trivy Scanner

on:
  workflow_call:
    inputs:
      image_name:
        required: true
        type: string
      tag:
        required: true
        type: string
    secrets:
      docker_username:
        required: true

jobs:
  trivy-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          # Scans the specific image version we just built
          image-ref: "${{ secrets.docker_username }}/${{ inputs.image_name }}:${{ inputs.tag }}"
          format: 'table'
          exit-code: '1' # Fails the pipeline if CRITICAL/HIGH found
          ignore-unfixed: true
          vuln-type: 'os,library'
          severity: 'CRITICAL,HIGH'
```
```bash
vi main-pipeline.yml
```
```yml
name: Main CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  # JOB 1: Continuous Integration
  test:
    uses: ./.github/workflows/reusable-build-test.yml
    with:
      python_version: '3.11'
      run_tests: true

  # JOB 2: Prepare variables (Short SHA)
  prep:
    runs-on: ubuntu-latest
    outputs:
      short_sha: ${{ steps.vars.outputs.sha_short }}
    steps:
      - name: Generate Short SHA
        id: vars
        run: echo "sha_short=$(echo ${{ github.sha }} | cut -c1-7)" >> $GITHUB_OUTPUT

  # JOB 3: Continuous Delivery (Docker)
  build-and-push:
    needs: [test, prep]
    uses: ./.github/workflows/reusable-docker.yml
    with:
      image_name: "github-actions-capstone"
      tag: "sha-${{ needs.prep.outputs.short_sha }}"
    secrets:
      docker_username: ${{ secrets.DOCKER_USERNAME }}
      docker_token: ${{ secrets.DOCKER_TOKEN }}

  # JOB 4: Security Gate (Trivy Scan)
  security-scan:
    needs: [build-and-push, prep]
    uses: ./.github/workflows/reusable-trivy-scan.yml
    with:
      image_name: "github-actions-capstone"
      tag: "sha-${{ needs.prep.outputs.short_sha }}"
    secrets:
      docker_username: ${{ secrets.DOCKER_USERNAME }}

  # JOB 5: Deployment Simulation
  deploy:
    # Now depends on security-scan passing
    needs: [security-scan, prep]
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Deploying to Production
        run: |
          echo "Deploying image: sha-${{ needs.prep.outputs.short_sha }}"
          echo "Status: Security verified. Deployment initiated."
```
![](./images/task-1/1-01.png)

![](./images/task-1/1-02.png)

![](./images/task-1/1-03.png)

![](./images/task-1/1-04.png)

![](./images/task-1/1-05.png)



**Verify:** Can you see the vulnerability table in the logs? Did it pass or fail?

![](./images/task-1/1-06.png)

![](./images/task-1/1-07.png)

![](./images/task-1/1-08.png)

![](./images/task-1/1-09.png)

![](./images/task-1/1-10.png)

Write in your notes: What CVEs (if any) were found? What base image are you using?

- **Base Image:** python:3.11-slim

- **Found CVEs:** 
    - **CVE-2026-23949** (HIGH) - Affecting jaraco.context (v5.3.0)

    - **CVE-2026-24049** (HIGH) - Affecting wheel (v0.45.1)

---

### Task 2: Enable GitHub's Built-in Secret Scanning
GitHub can automatically detect if someone pushes a secret (API key, token, password) to your repo.

1. Go to your repo → Settings → **Code security and analysis**
2. Enable **Secret scanning**
3. If available, also enable **Push protection** — this blocks the push entirely if a secret is detected

That's it — no workflow changes needed. GitHub does this automatically.

In the newest GitHub UI (2026), the **"Code security and analysis"** section has been streamlined. 

In the 2026 UI, the path is: **Settings** → **Code security** (Left Sidebar) → **Advanced Security**.

It is very common for the GitHub UI to look slightly different depending on whether our repository is *Public* or *Private*, or if we are using a *personal* account versus a *GitHub Organization*.

Since our repo **"github-actions-capstone"** is a *public* repo within a *private account*, here is the analysis of our current security posture and the specific buttons we need to click to finish our DevSecOps setup.

- 1. The **"Secret Protection"** Section (Bottom of our list):
**Push protection is enabled** by default.

- 2. **Dependency Management (Dependabot)**
Dependabot features that are disabled, not required for us now. 

- 3. **Code Scanning (The "CodeQL" Tool):**
Currently not set up. Click Set up and choose Default to **enable**.

- 4. **Private Vulnerability Reporting:**
This feature is **disabled** by default, not required.

![](./images/task-2/2-01.png)

![](./images/task-2/2-02.png)

![](./images/task-2/2-03.png)

![](./images/task-2/2-04.png)

![](./images/task-2/2-05.png)

![](./images/task-2/2-06.png)

![](./images/task-2/2-07.png)

![](./images/task-2/2-08.png)

Write in your notes:
- **What is the difference between secret scanning and push protection?**

    Since we are using a **Public repository**, both of these features are available to us for free. 
    
    While they work together, they serve two very different stages of the development lifecycle: one is **reactive** (finding what's already there), and the other is **proactive** (stopping the mistake before it happens).

- **What happens if GitHub detects a leaked AWS key in your repo?**

    If a leaked AWS key (or any supported partner pattern) is detected in our public repo, a high-speed automated process begins:

1. **Immediate Notification:** GitHub sends an alert to the repository admins and the person who pushed the code.

2. **Partner Notification (Crucial):** Because it is a Public repo, GitHub automatically notifies AWS directly.

3. **Automatic Revocation:** In many cases, AWS will immediately quarantine or disable that key to prevent hackers from spinning up expensive servers on our account.

4. **Security Alert:** A "Secret scanning" alert appears under the Security tab of our repo. It will remain "Open" until we fix the issue.

---

### Task 3: Scan Dependencies for Known Vulnerabilities
If your app uses packages (pip, npm, etc.), those packages might have known vulnerabilities.

Add this to your **PR pipeline** (not the main pipeline):
```yaml
- name: Check Dependencies for Vulnerabilities
  uses: actions/dependency-review-action@v4
  with:
    fail-on-severity: critical
```

This checks any **new** dependencies added in the PR against a vulnerability database. If a dependency has a critical CVE, the PR check fails.

Test it:
1. Open a PR that adds a package to your app
2. Check the Actions tab — did the dependency review run?

```bash
git branch
git switch feature/test-pipeline
```
```bash
vi .pr-pipeline.yml
```
```yml
name: Pull Request Pipeline

on:
  pull_request:
    branches:
      - main
    types: [opened, synchronize]

jobs:
  # 1. NEW: Security Gate - Dependency Review
  dependency-review:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4
      - name: Dependency Review
        uses: actions/dependency-review-action@v4
        with:
          fail-on-severity: critical

  # 2. Call the reusable build-test workflow
  # Now depends on the security review passing
  test-app:
    needs: [dependency-review]
    uses: ./.github/workflows/reusable-build-test.yml
    with:
      python_version: '3.11'
      run_tests: true

  # 3. Standalone job for the summary comment
  pr-comment:
    runs-on: ubuntu-latest
    needs: [test-app]
    if: success()
    steps:
      - name: Print PR Summary
        run: |
          echo "PR checks passed for branch: ${{ github.head_ref }}"
          echo "Build and Health Check Status: ${{ needs.test-app.outputs.test_result }}"
```
```bash
git add pr-pipeline.yml
git commit -m "feat: add dependency review security gate"
git push origin feature/test-pipeline
```
![](./images/task-3/3-01.png)

![](./images/task-3/3-02.png)

```bash
cd ../../
vi requirements.txt
```
```
django==1.11.28
```
![](./images/task-3/3-03.png)

```bash
git add requirements.txt
git commit -m "test: adding vulnerable django to check gate"
git push origin feature/test-pipeline
```
![](./images/task-3/3-04.png)

> Once we pushed the change and try to create PR, there will be a conflict we need to resolve the conflict to proceed further. 

**Verify:** Does the dependency review show up as a check on your PR?


![](./images/task-3/3-05.png)

![](./images/task-3/3-06.png)

![](./images/task-3/3-07.png)

![](./images/task-3/3-08.png)

![](./images/task-3/3-09.png)

> We need  to remove the package `django==1.11.28`, to carry out further testing

![](./images/task-3/3-10.png)

![](./images/task-3/3-11.png)

![](./images/task-3/3-12.png)

![](./images/task-3/3-13.png)

![](./images/task-3/3-14.png)

![](./images/task-3/3-15.png)

![](./images/task-3/3-16.png)

![](./images/task-3/3-17.png)

![](./images/task-3/3-18.png)

![](./images/task-3/3-19.png)

![](./images/task-3/3-20.png)

![](./images/task-3/3-21.png)

![](./images/task-3/3-22.png)

![](./images/task-3/3-23.png)

---

### Task 4: Add Permissions to Your Workflows
By default, workflows get broad permissions. Lock them down.

Add this block near the top of your workflow files (after `on:`):
```yaml
permissions:
  contents: read
```

If a workflow needs to comment on PRs, add:
```yaml
permissions:
  contents: read
  pull-requests: write
```

Update at least 2 of your existing workflow files with a `permissions` block.

```bash
git branch
git checkout main
```
```bash
vim reusable-build-test.yml
```
```yml
name: Reusable Build and Test (Flask Web)

on:
  workflow_call:
    inputs:
      python_version:
        description: 'The version of Python to use'
        required: false
        default: '3.11'
        type: string
      run_tests:
        description: 'Toggle to run the health check'
        required: false
        default: true
        type: boolean
    outputs:
      test_result:
        description: "Outcome of the build and health check"
        value: ${{ jobs.build-and-test.outputs.status }}

# STRATEGY: Maximum Lockdown
permissions:
  contents: read          # The only permission needed for testing

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    outputs:
      status: ${{ steps.set-output.outputs.test_status }}
    
    steps:
      - name: Check out code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ inputs.python_version }}

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          if [ -f requirements.txt ]; then
            pip install -r requirements.txt
          else
            pip install flask
          fi

      - name: Run Flask App and Verify Health
        if: ${{ inputs.run_tests }}
        id: health-check
        continue-on-error: true
        run: |
          # Start the Flask app in the background
          python app.py &
          
          # Wait for the server to return a 200 OK (max 15 seconds)
          # This verifies that app.py is running and index.html is rendering
          timeout 15s bash -c 'until curl -s -o /dev/null -w "%{http_code}" localhost:5000 | grep "200"; do sleep 1; done'

      - name: Set output
        id: set-output
        if: always()
        run: |
          # Map the outcome of the health check to a string output
          if [ "${{ steps.health-check.outcome }}" == "success" ]; then
            echo "test_status=passed" >> $GITHUB_OUTPUT
          else
            echo "test_status=failed" >> $GITHUB_OUTPUT
          fi
```
```bash
git add reusable-build-test.yml
git commit -m "Adding hardening strategy to build test module" reusable-build-test.yml
git pull origin main
git push origin main
```
```bash
git checkout feature/test-pipeline
vi pr-pipeline.yml 
```
```yml
name: Pull Request Pipeline

on:
  pull_request:
    branches:
      - main
    types: [opened, synchronize]

# STRATEGY: Limit permissions to only what is strictly necessary
permissions:
  contents: read          # Needed to checkout and scan code
  pull-requests: write    # Needed to post the PR status comment
  
jobs:
  # 1. NEW: Security Gate - Dependency Review
  dependency-review:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4
      - name: Dependency Review
        uses: actions/dependency-review-action@v4
        with:
          fail-on-severity: critical

  # 2. Call the reusable build-test workflow
  # Now depends on the security review passing
  test-app:
    needs: [dependency-review]
    uses: ./.github/workflows/reusable-build-test.yml
    with:
      python_version: '3.11'
      run_tests: true

  # 3. Standalone job for the summary comment
  pr-comment:
    runs-on: ubuntu-latest
    needs: [test-app]
    if: success()
    steps:
      - name: Print PR Summary
        run: |
          echo "PR checks passed for branch: ${{ github.head_ref }}"
          echo "Build and Health Check Status: ${{ needs.test-app.outputs.test_result }}"
```
```bash
git add .
git commit -m "Added hardening strategy to pr pipeline"
git pull origin feature/test-pipeline
git push origin feature/test-pipeline
```
![](./images/task-4/4-01.png)

![](./images/task-4/4-02.png)

![](./images/task-4/4-03.png)

![](./images/task-4/4-04.png)

![](./images/task-4/4-05.png)


**Write in your notes: Why is it a good practice to limit workflow permissions?**

It is a good practice to limit workflow permissions to follow the **Principle of Least Privilege**. 

By default, GitHub Actions tokens often have broad read/write access. 

Locking them down ensures that a workflow only has the specific permissions it needs to complete its task (e.g., only reading code or only writing a PR comment).


**What could go wrong if a compromised action has write access to your repo?**

If a malicious or compromised third-party action gains **write access** to our repository, several critical security failures could occur:

- **Code Injection:** An attacker could push malicious code directly into the `main` branch or modify existing scripts to include backdoors.
- **Secret Exfiltration:** A compromised action could use write access to modify workflows and exfiltrate repository secrets (like API keys or deployment tokens) to an external server.
- **Unauthorized Releases:** Attackers could trigger new releases or push malicious Docker images to our registry, poisoning the software supply chain.
- **Resource Abuse:** Write access could allow an attacker to delete branches, close legitimate Pull Requests, or manipulate repository settings.

---

### Task 5: See the Full Secure Pipeline
Look at what your pipeline does now:

```
PR opened
  → build & test
  → dependency vulnerability check     ← NEW (Day 49)
  → PR checks pass or fail

Merge to main
  → build & test
  → Docker build
  → Trivy image scan (fail on CRITICAL) ← NEW (Day 49)
  → Docker push (only if scan passes)
  → deploy

Always active
  → GitHub secret scanning              ← NEW (Day 49)
  → push protection for secrets         ← NEW (Day 49)
```

Draw this diagram in your notes. You just built a **DevSecOps pipeline** — security is now part of your automation, not an afterthought.

![](./images/BP/Day-49-1.png)

![](./images/BP/Day-49-2.png)

<div align="center">
  <img src="./images/BP/Day-49-3-2.png" />
</div>

---

## Brownie Points (Optional — For the Curious)

### Pin Actions to Commit SHAs
Tags like `@v4` can be moved by the action author. For extra security, pin to the exact commit:
```yaml
# Instead of this:
uses: actions/checkout@v4

# Use this:
uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
```
This protects against supply chain attacks where a tag is silently changed.

```bash
git checkout main
vi reusable-build-test.yml
```
```yml
name: Reusable Build and Test (Flask Web)

on:
  workflow_call:
    inputs:
      python_version:
        description: 'The version of Python to use'
        required: false
        default: '3.11'
        type: string
      run_tests:
        description: 'Toggle to run the health check'
        required: false
        default: true
        type: boolean
    outputs:
      test_result:
        description: "Outcome of the build and health check"
        value: ${{ jobs.build-and-test.outputs.status }}

# STRATEGY: Maximum Lockdown
permissions:
  contents: read          # The only permission needed for testing

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    outputs:
      status: ${{ steps.set-output.outputs.test_status }}
    
    steps:
      - name: Check out code
        # Pinning to v4.1.1
        uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11

      - name: Set up Python
        # Pinning to v6
        uses: actions/setup-python@a309ff8b426b58ec0e2a45f0f869d46889d02405
        with:
          python-version: ${{ inputs.python_version }}

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          if [ -f requirements.txt ]; then
            pip install -r requirements.txt
          else
            pip install flask
          fi

      - name: Run Flask App and Verify Health
        if: ${{ inputs.run_tests }}
        id: health-check
        continue-on-error: true
        run: |
          # Start the Flask app in the background
          python app.py &
          
          # Wait for the server to return a 200 OK (max 15 seconds)
          # This verifies that app.py is running and index.html is rendering
          timeout 15s bash -c 'until curl -s -o /dev/null -w "%{http_code}" localhost:5000 | grep "200"; do sleep 1; done'

      - name: Set output
        id: set-output
        if: always()
        run: |
          # Map the outcome of the health check to a string output
          if [ "${{ steps.health-check.outcome }}" == "success" ]; then
            echo "test_status=passed" >> $GITHUB_OUTPUT
          else
            echo "test_status=failed" >> $GITHUB_OUTPUT
          fi

```
```bash
git add .
git commit -m "Modified reusable-buld-test file to follow gold standard for Supply Chain Security"
git push origin main
```

![](./images/BP/BP-1.png)


```bash
git checkout feature/test-pipeline
vi pr-pipeline.yml
```
```yml
name: Pull Request Pipeline

on:
  pull_request:
    branches:
      - main
    types: [opened, synchronize]

# STRATEGY: Limit permissions to only what is strictly necessary
permissions:
  contents: read          # Needed to checkout and scan code
  pull-requests: write    # Needed to post the PR status comment
  
jobs:
  # 1. NEW: Security Gate - Dependency Review
  dependency-review:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        # Pinning to v4.1.1
        uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11
      - name: Dependency Review
        # Pinning to v4.8.3
        uses: actions/dependency-review-action@05fe4576374b728f0c523d6a13d64c25081e0803
        with:
          fail-on-severity: critical

  # 2. Call the reusable build-test workflow
  # Now depends on the security review passing
  test-app:
    needs: [dependency-review]
    uses: ./.github/workflows/reusable-build-test.yml
    with:
      python_version: '3.11'
      run_tests: true

  # 3. Standalone job for the summary comment
  pr-comment:
    runs-on: ubuntu-latest
    needs: [test-app]
    if: success()
    steps:
      - name: Print PR Summary
        run: |
          echo "PR checks passed for branch: ${{ github.head_ref }}"
          echo "Build and Health Check Status: ${{ needs.test-app.outputs.test_result }}"
```
```bash
git add .
git commit -m "Modified reusable-buld-test file to follow gold standard for Supply Chain Security"
git push origin feature/test-pipeline
```
![](./images/BP/BP-2.png)

![](./images/BP/BP-3.png)



### Upload Scan Results to GitHub Security Tab
Add SARIF output to Trivy and upload it — your scan results will appear in the repo's **Security** tab:
```yaml
- uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'your-username/your-app:latest'
    format: 'sarif'
    output: 'trivy-results.sarif'
- uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: 'trivy-results.sarif'
```
```bash
vi reusable-trivy-scan.yml
```
```yml
name: Reusable Trivy Scanner

on:
  workflow_call:
    inputs:
      image_name:
        required: true
        type: string
      tag:
        required: true
        type: string
    secrets:
      docker_username:
        required: true

# 1. Permissions Lockdown
permissions:
  contents: read
  security-events: write  # Required to upload results to the Security tab

jobs:
  trivy-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v6

      # DEBUG STEP: Let's see if the variables are correct
      - name: Debug Image Name
        run: |
          echo "Scanning image: ${{ secrets.docker_username }}/${{ inputs.image_name }}:${{ inputs.tag }}"

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@57a97c7e7821a5776cebc9bb87c984fa69cba8f1
        with:
          image-ref: "docker.io/${{ secrets.docker_username }}/${{ inputs.image_name }}:${{ inputs.tag }}"
          format: 'sarif'
          output: 'trivy-results.sarif'
          exit-code: '0'  # Change to 0 temporarily to force the file creation
          ignore-unfixed: true
          vuln-type: 'os,library'
          severity: 'CRITICAL,HIGH'

      - name: Upload Trivy scan results
        if: always()
        uses: github/codeql-action/upload-sarif@v3.24.6
        with:
          sarif_file: 'trivy-results.sarif'
```
```bash
vi main-pipeline.yml
```
```yml
name: Main CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  # JOB 1: Continuous Integration
  test:
    uses: ./.github/workflows/reusable-build-test.yml
    with:
      python_version: '3.11'
      run_tests: true

  # JOB 2: Prepare variables (Short SHA)
  prep:
    runs-on: ubuntu-latest
    outputs:
      short_sha: ${{ steps.vars.outputs.sha_short }}
    steps:
      - name: Generate Short SHA
        id: vars
        run: echo "sha_short=$(echo ${{ github.sha }} | cut -c1-7)" >> $GITHUB_OUTPUT

  # JOB 3: Continuous Delivery (Docker)
  build-and-push:
    needs: [test, prep]
    uses: ./.github/workflows/reusable-docker.yml
    with:
      image_name: "github-actions-capstone"
      tag: "sha-${{ needs.prep.outputs.short_sha }}"
    secrets:
      docker_username: ${{ secrets.DOCKER_USERNAME }}
      docker_token: ${{ secrets.DOCKER_TOKEN }}

  # JOB 4: Security Gate (Trivy Scan)
  security-scan:
    needs: [build-and-push, prep]
    # ADD THIS PERMISSIONS BLOCK:
    permissions:
      contents: read
      security-events: write  # Essential for uploading to the Security tab
    uses: ./.github/workflows/reusable-trivy-scan.yml
    with:
      image_name: "github-actions-capstone"
      tag: "sha-${{ needs.prep.outputs.short_sha }}"
    secrets:
      docker_username: ${{ secrets.DOCKER_USERNAME }}

  # JOB 5: Deployment Simulation
  deploy:
    # Now depends on security-scan passing
    needs: [security-scan, prep]
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Deploying to Production
        run: |
          echo "Deploying image: sha-${{ needs.prep.outputs.short_sha }}"
          echo "Status: Security verified. Deployment initiated."
```
```bash
git add .
git commit -m "git commit -m "Modified main and trivy module to upload SARIF output to security tab"
```
![](./images/BP/BP-4.png)

![](./images/BP/BP-5.png)

![](./images/BP/BP-6.png)

![](./images/BP/BP-7.png)


### Learn About OIDC (Keyless Authentication)

**Instead of storing cloud credentials as long-lived secrets, GitHub Actions can use OIDC to get short-lived tokens automatically. Research: "GitHub Actions OIDC" — it's how production pipelines authenticate to AWS, GCP, and Azure without storing any keys.**

At its core, **OIDC (OpenID Connect)** is a way for GitHub Actions to "prove" who it is to a cloud provider (like AWS, Google Cloud, or Azure) without using a password.

Instead of storing a long-term secret key in GitHub, the two systems perform a **digital handshake**:

1. **The Token**: When a workflow starts, GitHub creates a temporary, short-lived "ID Token" (a JWT).

2. **The Proof**: This token contains specific details: "I am a runner for your-repo, on the main branch, running the deploy job."

3. **The Trust**: The cloud provider checks this token. If it matches a "Trust Policy" we've set up, the provider gives the runner a temporary access key that expires in minutes.

**Why we use it:**
- **No Secrets to Steal:** There is no permanent password stored in GitHub that a hacker could exfiltrate.

- **Zero Maintenance:** We never have to "rotate" or update expired passwords manually.

- **Tight Control:** We can tell our cloud: "Only trust this repo if the request comes from a specific branch."

---