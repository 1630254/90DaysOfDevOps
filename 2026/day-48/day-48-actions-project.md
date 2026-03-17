# GitHub Actions Project: End-to-End CI/CD Pipeline

### Task 1: Set Up the Project Repo
1. Create a new repo called `github-actions-capstone` (or use your existing `github-actions-practice`)

![](./images/task-1/1-1.png)

![](./images/task-1/1-2.png)

![](./images/task-1/1-3.png)

2. Add a simple app — pick any one:
   - A Python Flask/FastAPI app with one endpoint
   - A Node.js Express app with one endpoint
   - Your Dockerized app from Day 36
3. Add a `Dockerfile` and a basic test (even a script that curls the health endpoint counts)

![](./images/task-1/1-4.png)

4. Add a `README.md` with a project description


---

### Task 2: Reusable Workflow — Build & Test
Create `.github/workflows/reusable-build-test.yml`:
1. Trigger: `workflow_call`
2. Inputs: `python_version` (or `node_version`), `run_tests` (boolean, default: true)
3. Steps:
   - Check out code
   - Set up the language runtime
   - Install dependencies
   - Run tests (only if `run_tests` is true)
   - Set output: `test_result` with value `passed` or `failed`

This workflow does NOT deploy — it only builds and tests.

```bash
mkdir -p .github/workflows/
vi .github/workflows/reusable-build-test.
```
![](./images/task-2/2-1.png)

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
cd .github/workflows
git add reusable-build-test.yml
git commit -m "reusable-build-test file is strictly used for Build and Test purpose"
git push origin main
```
![](./images/task-2/2-2.png)

![](./images/task-2/2-3.png)

---

### Task 3: Reusable Workflow — Docker Build & Push
Create `.github/workflows/reusable-docker.yml`:
1. Trigger: `workflow_call`
2. Inputs: `image_name` (string), `tag` (string)
3. Secrets: `docker_username`, `docker_token`
4. Steps:
   - Check out code
   - Log in to Docker Hub
   - Build and push the image with the given tag
   - Set output: `image_url` with the full image path

```bash
vi reusable-docker.yml
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
git add reusable-docker.yml
git commit -m "Handle the containerization side of the pipeline"
git push origin main
```
![](./images/task-3/3-1.png)

![](./images/task-3/3-2.png)

---

### Task 4: PR Pipeline
Create `.github/workflows/pr-pipeline.yml`:
1. Trigger: `pull_request` to `main` (types: `opened`, `synchronize`)
2. Call the reusable build-test workflow:
   - Run tests: `true`
3. Add a standalone job `pr-comment` that:
   - Runs after the build-test job
   - Prints a summary: "PR checks passed for branch: `<branch>`"
4. Do **NOT** build or push Docker images on PRs

**Verify:** Open a PR — does it run tests only (no Docker push)?

```bash
git branch
git checkout -b feature/test-pipeline
```

```bash
vi pr-pipeline.yml
```
![](./images/task-4/4-1.png)

```yml
name: Pull Request Pipeline

on:
  pull_request:
    branches:
      - main
    types: [opened, synchronize]

jobs:
  # 1. Call the reusable build-test workflow
  test-app:
    uses: ./.github/workflows/reusable-build-test.yml
    with:
      python_version: '3.11'
      run_tests: true

  # 2. Standalone job for the summary comment
  pr-comment:
    runs-on: ubuntu-latest
    needs: test-app
    # Only run if the previous test-app job was successful
    if: success()
    steps:
      - name: Print PR Summary
        run: |
          echo "PR checks passed for branch: ${{ github.head_ref }}"
          echo "Build and Health Check Status: ${{ needs.test-app.outputs.test_result }}"
```
```bash
git add pr-pipeline.yml
git commit -m "Testing PR pipeline" pr-pipeline.yml
git push origin feature/test-pipeline
```
![](./images/task-4/4-2.png)

![](./images/task-4/4-3.png)

![](./images/task-4/4-4.png)

![](./images/task-4/4-5.png)

![](./images/task-4/4-6.png)

![](./images/task-4/4-7.png)

![](./images/task-4/4-8.png)

![](./images/task-4/4-9.png)

![](./images/task-4/4-10.png)

![](./images/task-4/4-11.png)

![](./images/task-4/4-12.png)

![](./images/task-4/4-13.png)

![](./images/task-4/4-14.png)

![](./images/task-4/4-15.png)

![](./images/task-4/4-16.png)

![](./images/task-4/4-17.png)

![](./images/task-4/4-18.png)

![](./images/task-4/4-19.png)

![](./images/task-4/4-20.png)

---

### Task 5: Main Branch Pipeline
Create `.github/workflows/main-pipeline.yml`:
1. Trigger: `push` to `main`
2. Job 1: Call the reusable build-test workflow
3. Job 2 (depends on Job 1): Call the reusable Docker workflow
   - Tag: `latest` and `sha-<short-commit-hash>`
4. Job 3 (depends on Job 2): `deploy` job that:
   - Prints "Deploying image: `<image_url>` to production"
   - Uses `environment: production` (set this up in repo Settings → Environments)
   - Requires manual approval if you've set up environment protection rules

**Verify:** Merge a PR to `main` — does it run tests → build Docker → deploy in sequence?

```bash
vim main-pipeline.yml
```
![](./images/task-5/5-1.png)

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
```bash
git add .
git commit -m "Added main-pipeline.yml - it ensures that code only moves to production after passing tests and being containerized"
git push origin main
```
![](./images/task-5/5-2.png) 

![](./images/task-5/5-3.png) 

![](./images/task-5/5-4.png) 

![](./images/task-5/5-5.png) 

![](./images/task-5/5-6.png) 

![](./images/task-5/5-7.png) 

![](./images/task-5/5-8.png) 

![](./images/task-5/5-9.png) 

![](./images/task-5/5-10.png) 

![](./images/task-5/5-11.png) 

![](./images/task-5/5-12.png) 

![](./images/task-5/5-13.png) 

![](./images/task-5/5-14.png) 

![](./images/task-5/5-15.png) 

![](./images/task-5/5-16.png) 

![](./images/task-5/5-17.png) 

![](./images/task-5/5-18.png) 

![](./images/task-5/5-19.png) 

![](./images/task-5/5-20.png) 

![](./images/task-5/5-21.png) 

![](./images/task-5/5-22.png) 

![](./images/task-5/5-23.png) 

![](./images/task-5/5-24.png) 

![](./images/task-5/5-25.png)

---

### Task 6: Scheduled Health Check
Create `.github/workflows/health-check.yml`:
1. Trigger: `schedule` with cron `'0 */12 * * *'` (every 12 hours) + `workflow_dispatch` for manual testing
2. Steps:
   - Pull your latest Docker image
   - Run the container in detached mode
   - Wait 5 seconds, then curl the health endpoint
   - Print pass/fail based on the response
   - Stop and remove the container
3. Add a step that creates a summary using `$GITHUB_STEP_SUMMARY`:
   ```bash
   echo "## Health Check Report" >> $GITHUB_STEP_SUMMARY
   echo "- Image: myapp:latest" >> $GITHUB_STEP_SUMMARY
   echo "- Status: PASSED" >> $GITHUB_STEP_SUMMARY
   echo "- Time: $(date)" >> $GITHUB_STEP_SUMMARY
   ```
```bash
vi health-check.yml
```

``` yml
name: Scheduled Health Check

on:
  schedule:
    # Runs every 12 hours
    - cron: '0 */12 * * *'
  workflow_dispatch:
    # Allows manual triggering for testing

jobs:
  periodic-health-check:
    runs-on: ubuntu-latest
    steps:
      - name: Pull Latest Docker Image
        run: |
          # Replace with our actual Docker Hub username/image
          docker pull ${{ secrets.DOCKER_USERNAME }}/github-actions-capstone:latest

      - name: Run Container
        run: |
          docker run -d --name health-check-container -p 5000:5000 ${{ secrets.DOCKER_USERNAME }}/github-actions-capstone:latest
          sleep 5

      - name: Verify Health Endpoint
        id: check
        continue-on-error: true
        run: |
          RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000 || echo "404")
          if [ "$RESPONSE" == "200" ]; then
            echo "status=PASSED" >> $GITHUB_ENV
            exit 0
          else
            echo "status=FAILED" >> $GITHUB_ENV
            exit 1
          fi

      - name: Cleanup Container
        if: always()
        run: |
          docker stop health-check-container
          docker rm health-check-container

      - name: Generate Summary
        if: always()
        run: |
          echo "## Health Check Report" >> $GITHUB_STEP_SUMMARY
          echo "- **Image:** ${{ secrets.DOCKER_USERNAME }}/github-actions-capstone:latest" >> $GITHUB_STEP_SUMMARY
          echo "- **Status:** ${{ env.status || 'FAILED' }}" >> $GITHUB_STEP_SUMMARY
          echo "- **Time:** $(date)" >> $GITHUB_STEP_SUMMARY
```
```bash
git add .
git commit -m "Added health check feature to the app.."
git push origin main
```
![](./images/task-6/6-1.png)

![](./images/task-6/6-2.png)

![](./images/task-6/6-3.png)

![](./images/task-6/6-4.png)

![](./images/task-6/6-5.png)
---

### Task 7: Add Badges & Documentation
1. Add status badges for all your workflows to the repo `README.md`
2. Add a **pipeline architecture diagram** in your notes — draw (or describe) the flow:
   ```
   PR opened → build & test → PR checks pass
   Merge to main → build & test → Docker build & push → deploy
   Every 12 hours → health check
   ```
![](./images/flow-chart.png)

3. Fill in your notes: What would you add next? (Slack notifications? Multi-environment? Rollback?)

| # | Topic                                   | Why                                                                 | Implementation                                                                 |
|---|-----------------------------------------|---------------------------------------------------------------------|--------------------------------------------------------------------------------|
| 1 | Slack / Discord Notifications           | Completes the feedback loop of CI/CD.                               | Add a notification step in `main-pipeline.yml` using `if: always()` to send a webhook to Slack. |
| 2 | Multi-Environment Strategy (Staging vs. Production) | Allows testing in a staging environment before final release.        | Use GitHub Environments with Deployment Protection Rules (e.g., manual approvals) to promote images from Staging to Production. |
| 3 | Automated Rollbacks                     | Enables true SRE self-healing when health checks fail.              | Configure `health-check.yml` to trigger a workflow that re-deploys the previous “known good” SHA tag if a 500 error is detected. |

---

## Brownie Points: Add Security to Your Pipeline
Want to go above and beyond? Add a **DevSecOps** step to your main pipeline:
1. Add `aquasecurity/trivy-action` after the Docker build step to scan your image for vulnerabilities
2. Fail the pipeline if any **CRITICAL** severity CVE is found
3. Upload the scan report as an artifact

This is a preview of what you'll do in depth on **Day 49**. If you get this working today, you're already thinking like a DevSecOps engineer.

```bash
vi reusable-docker.yml 
```

```yml
name: Reusable Docker Build, Scan, and Push

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

      - name: Docker meta
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ secrets.docker_username }}/${{ inputs.image_name }}
          tags: |
            type=raw,value=latest
            type=raw,value=${{ inputs.tag }}

      - name: Build and push
        id: docker_build
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          platforms: linux/amd64
          provenance: false
          sbom: false
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: '${{ secrets.docker_username }}/${{ inputs.image_name }}:latest'
          format: 'table'
          exit-code: '1' # Fails the job if CRITICAL found
          ignore-unfixed: true
          vuln-type: 'os,library'
          severity: 'CRITICAL'
          output: 'trivy-report.txt'

      - name: Upload Trivy scan report
        if: always() 
        uses: actions/upload-artifact@v4
        with:
          name: trivy-security-report
          path: trivy-report.txt
```
```bash
git add .
git commit -m "Modified reusable-docker file to introduce DevSecOps angle to pipeline"
git push origin main
```
![](./images/Brownie/B-1.png)

![](./images/Brownie/B-2.png)

![](./images/Brownie/B-3.png)

![](./images/Brownie/B-4.png)

![](./images/Brownie/B-5.png)
---