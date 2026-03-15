# Advanced Triggers: PR Events, Cron Schedules & Event-Driven Pipelines

### Task 1: Pull Request Event Types
Create `.github/workflows/pr-lifecycle.yml` that triggers on `pull_request` with **specific activity types**:
1. Trigger on: `opened`, `synchronize`, `reopened`, `closed`
2. Add steps that:
   - Print which event type fired: `${{ github.event.action }}`
   - Print the PR title: `${{ github.event.pull_request.title }}`
   - Print the PR author: `${{ github.event.pull_request.user.login }}`
   - Print the source branch and target branch
3. Add a conditional step that only runs when the PR is **merged** (closed + merged = true)

```bash
git checkout -b feature/workflow-test
vi pr-lifecycle.yml
```
```yml
name: PR Lifecycle Monitor

on:
  pull_request:
    types: [opened, synchronize, reopened, closed]

jobs:
  pr-details:
    runs-on: ubuntu-latest
    steps:
      - name: Log PR Activity Details
        run: |
          echo "Event action: ${{ github.event.action }}"
          echo "PR Title: ${{ github.event.pull_request.title }}"
          echo "PR Author: ${{ github.event.pull_request.user.login }}"
          echo "Source Branch: ${{ github.event.pull_request.head.ref }}"
          echo "Target Branch: ${{ github.event.pull_request.base.ref }}"

      - name: Post-Merge Action
        if: github.event.pull_request.merged == true
        run: |
          echo "This PR was successfully merged into ${{ github.event.pull_request.base.ref }}."
          echo "Performing cleanup or post-merge deployment steps..."
```

![](./images/task-1/1-1.png)

```bash
git add . pr-lifecycle.yml
git commit -m "<comment>"
git push origin feature/workflow-test
```
![](./images/task-1/1-2.png)

![](./images/task-1/1-3.png)

![](./images/task-1/1-4.png)

![](./images/task-1/1-5.png)

![](./images/task-1/1-6.png)

![](./images/task-1/1-7.png)

![](./images/task-1/1-8.png)

![](./images/task-1/1-9.png)

![](./images/task-1/1-10.png)

![](./images/task-1/1-11.png)

![](./images/task-1/1-12.png)

![](./images/task-1/1-13.png)

![](./images/task-1/1-14.png)

![](./images/task-1/1-15.png)

![](./images/task-1/1-16.png)

![](./images/task-1/1-17.png)


---

### Task 2: PR Validation Workflow
Create `.github/workflows/pr-checks.yml` — a real-world PR gate:
1. Trigger on `pull_request` to `main`
2. Add a job `file-size-check` that:
   - Checks out the code
   - Fails if any file in the PR is larger than 1 MB
3. Add a job `branch-name-check` that:
   - Reads the branch name from `${{ github.head_ref }}`
   - Fails if it doesn't follow the pattern `feature/*`, `fix/*`, or `docs/*`
4. Add a job `pr-body-check` that:
   - Reads the PR body: `${{ github.event.pull_request.body }}`
   - Warns (but doesn't fail) if the PR description is empty

```bash
git checkout -b feature/add-pr-gates
```

![](./images/task-2/2-1.png)

```bash
vi pr-checks.yml
```
```yml
name: PR Quality Gates

on:
  pull_request:
    branches: [main]

jobs:
  file-size-check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0 # Fetches all history so we can compare branches

      - name: Check for files > 1MB
        run: |
          echo "Scanning for large files..."
          # Find files larger than 1MB in the current workspace
          LARGE_FILES=$(find . -type f -not -path '*/.*' -size +1M)
          
          if [ -n "$LARGE_FILES" ]; then
            echo "::error::The following files exceed the 1MB limit:"
            echo "$LARGE_FILES"
            exit 1
          else
            echo "All files are within the size limit."
          fi

  branch-name-check:
    runs-on: ubuntu-latest
    steps:
      - name: Validate Branch Name Pattern
        run: |
          BRANCH_NAME="${{ github.head_ref }}"
          PATTERN="^(feature/|fix/|docs/)"
          
          if [[ ! $BRANCH_NAME =~ $PATTERN ]]; then
            echo "::error::Branch name '$BRANCH_NAME' is invalid."
            echo "::error::We must use patterns: feature/*, fix/*, or docs/*"
            exit 1
          fi
          echo "Branch name '$BRANCH_NAME' follows the naming convention."

  pr-body-check:
    runs-on: ubuntu-latest
    steps:
      - name: Check PR Description
        run: |
          PR_BODY="${{ github.event.pull_request.body }}"
          
          # Check if body is empty or just whitespace
          if [[ -z "${PR_BODY// }" ]]; then
            echo "::warning::The PR description is empty. We should provide context for our changes."
          else
            echo "PR description is present."
          fi
```

```bash
git add pr-checks.yml 
git commit -m "<comment>" pr-checks.yml 
git push origin feature/add-pr-gates
```

![](./images/task-2/2-2.png)

![](./images/task-2/2-3.png)

![](./images/task-2/2-4.png)

![](./images/task-2/2-5.png)

![](./images/task-2/2-6.png)


![](./images/task-2/2-7.png)

![](./images/task-2/2-8.png)

![](./images/task-2/2-9.png)

![](./images/task-2/2-10.png)

![](./images/task-2/2-11.png)

![](./images/task-2/2-12.png)

![](./images/task-2/2-13.png)

![](./images/task-2/2-14.png)

![](./images/task-2/2-15.png)


```bash
git checkout -b my-test-update
vi pr-checks.yml
```
> Important: Ensure that the same code is applied here too.

```bash
git add pr-checks.yml
git commit -m "<comment>"pr-checks.yml
git push origin my-test-update
```

![](./images/task-2/2-16.png)

**Verify:** Open a PR from a badly named branch — does the check fail?


![](./images/task-2/2-17.png)


![](./images/task-2/2-18.png)


![](./images/task-2/2-19.png)


![](./images/task-2/20.png)


![](./images/task-2/21.png)


![](./images/task-2/2-22.png)


![](./images/task-2/2-23.png)


![](./images/task-2/2-24.png)


![](./images/task-2/2-25.png)


![](./images/task-2/2-26.png)


![](./images/task-2/2-27.png)


![](./images/task-2/2-28.png)
---

### Task 3: Scheduled Workflows (Cron Deep Dive)
Create `.github/workflows/scheduled-tasks.yml`:
1. Add a `schedule` trigger with cron: `'30 2 * * 1'` (every Monday at 2:30 AM UTC)
2. Add **another** cron entry: `'0 */6 * * *'` (every 6 hours)
3. In the job, print which schedule triggered using `${{ github.event.schedule }}`
4. Add a step that acts as a **health check** — curl a URL and check the response code

```bash
vi scheduled-tasks.yml
```
```yaml
name: Scheduled Health Checks

on:
  schedule:
    # Runs every Monday at 2:30 AM UTC
    - cron: '30 2 * * 1'
    # Runs every 6 hours (at the start of the hour)
    - cron: '0 */6 * * *'
  # Adding workflow_dispatch allows us to trigger this manually for testing
  workflow_dispatch:

jobs:
  health-monitor:
    runs-on: ubuntu-latest
    steps:
      - name: Log Schedule Context
        run: |
          echo "This run was triggered by the following cron schedule: ${{ github.event.schedule }}"

      - name: Site Health Check
        run: |
          # Replace 'https://example.com' with our actual service URL
          URL="https://example.com"
          echo "Checking health for $URL..."
          
          RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
          
          if [ "$RESPONSE_CODE" -eq 200 ]; then
            echo "Success: Received HTTP 200 from $URL"
          else
            echo "::error::Health check failed! Received HTTP $RESPONSE_CODE"
            exit 1
          fi
```

![](./images/task-3/3-1.png)

```bash
git add scheduled-tasks.yml
git commit -m "<comment>" scheduled-tasks.yml
git push origin main
```
![](./images/task-3/3-2.png)

![](./images/task-3/3-3.png)

![](./images/task-3/3-4.png)

![](./images/task-3/3-5.png)

![](./images/task-3/3-6.png)

![](./images/task-3/3-7.png)


**Write in your notes:**
- **The cron expression for: every weekday at 9 AM IST**

`30 3 * * 1-5` (Note: GitHub Actions uses UTC. 9:00 AM IST is 3:30 AM UTC.)

- **The cron expression for: first day of every month at midnight**

`0 0 1 * *`

- **Why GitHub says scheduled workflows may be delayed or skipped on inactive repos**

Scheduled workflows can be delayed or skipped on inactive repositories because GitHub optimizes resources by deprioritizing accounts that haven't seen recent activity. If a repository has not had any commits or interactions for 60 days, GitHub may automatically disable its scheduled workflows to prevent unnecessary compute usage. Additionally, high demand on GitHub's shared runners can cause delays in the exact execution time of cron jobs.


**Important:** Also add `workflow_dispatch` so you can test it manually without waiting for the schedule.

---

### Task 4: Path & Branch Filters
Create `.github/workflows/smart-triggers.yml`:
1. Trigger on push but **only** when files in `src/` or `app/` change:
   ```yaml
   on:
     push:
       paths:
         - 'src/**'
         - 'app/**'
   ```
```bash
vi smart-triggers.yml
```
```yml
name: App Build & Test

on:
  push:
    branches:
      - main
      - 'release/*'
    paths:
      - 'src/**'
      - 'app/**'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Code Change Detected
        run: echo "Code in src/ or app/ changed. Starting build..."
```
![](./images/task-4/4-1.png)

```bash
git add smart-triggers.yml
git commit -m "<comment>" smart-triggers.yml
git push origin main
```
![](./images/task-4/4-2.png)

![](./images/task-4/4-2-1.png)


```bash
touch test.txt
git add test.txt
git commit -m "<comment>" test.txt
git push origin main
```

![](./images/task-4/4-3.png)

![](./images/task-4/4-4.png)

```bash
pwd
/home/student/github-actions-practice
mkdir src/
echo "// New feature" >> src/app.js
git add src/app.js
git commit -m "test: modifying src to trigger workflow"
git push origin main
```
![](./images/task-4/4-5.png)

![](./images/task-4/4-6.png)

![](./images/task-4/4-7.png)

![](./images/task-4/4-8.png)

2. Add `paths-ignore` in a second workflow that skips runs when only docs change:
   ```yaml
   paths-ignore:
     - '*.md'
     - 'docs/**'
   ```

```bash
vi smart-triggers.yml
```
```yml
name: Global Code Quality

on:
  push:
    branches:
      - main
      - 'release/*'
    paths-ignore:
      - '*.md'
      - 'docs/**'

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Running Linters
        run: echo "This run skipped the docs and focused on the code."
```
![](./images/task-4/4-9.png)

```bash
git add smart-triggers.yml
git commit -m "<comment>" smart-triggers.yml
git push origin main
```
![](./images/task-4/4-10.png)

3. Add branch filters to only trigger on `main` and `release/*` branches
4. Test it: push a change to a `.md` file — does the workflow skip?
```bash
pwd
/home/student/github-actions-practice
echo "# Update documentation" >> README.md
git add README.md
git commit -m "test: modifying readme should NOT trigger workflow"
git push origin main
```
![](./images/task-4/4-11.png)

![](./images/task-4/4-12.png)

![](./images/task-4/4-13.png)

![](./images/task-4/4-14.png)

Write in your notes: When would you use `paths` vs `paths-ignore`?

**Use `paths` (Inclusion Strategy) when:**

- We only want the workflow to run for specific, high-stakes changes (e.g., triggering a backend build only when code in `/src` or `/api` changes).

- We want to be **strict**. If a commit doesn't touch the defined folders, the workflow remains idle.

- Best for: Specific service deployments, unit tests, and CI pipelines in monorepos.

**Use `paths-ignore` (Exclusion Strategy) when:**

- We want the workflow to run for almost every push, **except** for trivial changes that don't affect the build (e.g., updating `README.md`, adjusting `.gitignore`, or editing the `/docs` folder).

- We want to be **inclusive**. The workflow will run for any file change unless it is explicitly listed in the ignore block.

- Best for: Global linting, security scanning, or general quality gates where we want maximum coverage.

---

### Task 5: `workflow_run` — Chain Workflows Together
Create two workflows:
1. `.github/workflows/tests.yml` — runs tests on every push
```bash
vi tests.yml
```
```yml
name: Run Tests

on:
  push:
    branches: [main]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Application Tests
        run: |
          echo "Running unit tests..."
          # Simulate test execution
          exit 0
```
![](./images/task-5/5-1.png)

```bash
git add tests.yml
git commit -m "Task-5: Added tests.yml to the repo.." tests.yml
git push origin main
```
![](./images/task-5/5-2.png)

2. `.github/workflows/deploy-after-tests.yml` — triggers **only after** `tests.yml` completes successfully:
   ```yaml
   on:
     workflow_run:
       workflows: ["Run Tests"]
       types: [completed]
   ```
3. In the deploy workflow, add a conditional:
   - Only proceed if the triggering workflow **succeeded** (`${{ github.event.workflow_run.conclusion == 'success' }}`)
   - Print a warning and exit if it failed

![](./images/task-5/5-3.png)

![](./images/task-5/5-4.png)

![](./images/task-5/5-5.png)


```bash
vi deploy-after-tests.yml
```
```yml
name: Deploy After Tests

on:
  workflow_run:
    workflows: ["Run Tests"]
    types:
      - completed

jobs:
  deploy:
    runs-on: ubuntu-latest
    # Only run if the triggering workflow was successful
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    steps:
      - name: Production Deployment
        run: |
          echo "Tests passed! Starting deployment to production..."
          # Add deployment commands here

  handle-failure:
    runs-on: ubuntu-latest
    # Only run if the triggering workflow failed
    if: ${{ github.event.workflow_run.conclusion == 'failure' }}
    steps:
      - name: Log Failure Warning
        run: |
          echo "::error::The 'Run Tests' workflow failed."
          echo "Deployment aborted to prevent breaking production."
          exit 1
```
![](./images/task-5/5-6.png) 

```bash
git add deploy-after-tests.yml
git commit -m "Task-5: Added deploy-after-tests.yml to the repo.." deploy-after-tests.yml
git push origin main
```
![](./images/task-5/5-6-1.png)

**Verify:** Push a commit — does the test workflow run first, then trigger the deploy workflow?

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

---

### Task 6: `repository_dispatch` — External Event Triggers
1. Create `.github/workflows/external-trigger.yml` with trigger `repository_dispatch`
2. Set it to respond to event type: `deploy-request`
3. Print the client payload: `${{ github.event.client_payload.environment }}`
```bash
vi external-trigger.yml
```
```yml
name: External Deployment Trigger

on:
  repository_dispatch:
    types: [deploy-request]

jobs:
  external-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Acknowledge Request
        run: |
          echo "External event received!"
          echo "Target Environment: ${{ github.event.client_payload.environment }}"
          
      - name: Deploy Step
        run: |
          echo "Initiating deployment to ${{ github.event.client_payload.environment }}..."
          # Insert deployment logic here
```
![](./images/task-6/6-1.png) 
```bash
git add external-trigger.yml 
git commit -m "Task-6: Added external-trigger file to the repo" external-trigger.yml
git push origin main
```
![](./images/task-6/6-2.png) 

![](./images/task-6/6-3.png) 

4. Trigger it using `curl` or `gh`:
   ```bash
   gh api repos/<owner>/<repo>/dispatches \
     -f event_type=deploy-request \
     -f client_payload='{"environment":"production"}'
   ```
```bash
gh api repos/1630254/github-actions-practice/dispatches \
  -f event_type=deploy-request \
  -f 'client_payload[environment]=production'
```
![](./images/task-6/6-4.png) 

![](./images/task-6/6-5.png) 

![](./images/task-6/6-6.png) 

![](./images/task-6/6-7.png) 

Write in your notes: When would an external system (like a Slack bot or monitoring tool) trigger a pipeline?

  An external system like a Slack bot, monitoring tool, or custom dashboard would trigger a GitHub Actions pipeline in scenarios where the "signal" to act comes from outside the git history. These triggers are typically handled via the `repository_dispatch` event.

1. **Manual "ChatOps" (Slack/Teams Bots)**
In a ChatOps model, team members can interact with infrastructure directly from their communication tools.

    - **Scenario:** A developer types a command like /deploy production or /rollback into a Slack channel.

    - **Why:** This allows for quick, collaborative deployments or emergency actions without requiring everyone to have direct access to the GitHub UI or a terminal.

2. **Automated Health Monitoring (Datadog/New Relic)**
Monitoring tools can act as the "first responders" to environmental instability.

    - **Scenario:** A monitoring tool detects that an environment is unstable (e.g., high error rates, latency spikes, or 5xx errors).

    - **Why:** To automatically trigger a "Rollback" workflow to a previous stable version or a "Self-Healing" script to restart specific services, minimizing downtime before a human can intervene.

---
