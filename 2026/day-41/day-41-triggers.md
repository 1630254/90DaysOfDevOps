# Triggers & Matrix Builds


### Task 1: Trigger on Pull Request
1. Create `.github/workflows/pr-check.yml`

**In local repo**
```bash
touch pr-check.yml
git add .
git commit -m "Add PR check workflow"
git push origin main
```
![](./images/1-1.png)

2. Trigger it only when a pull request is **opened or updated** against `main`

3. Add a step that prints: `PR check running for branch: <branch name>`
**In Git portal**
```yaml
name: PR Check

# 2. Trigger on opened or updated (synchronize) against main
on:
  pull_request:
    branches:
      - main
    types: [opened, synchronize]

jobs:
  check-branch:
    runs-on: ubuntu-latest
    steps:
      # 3. Print the branch name using the github context
      - name: Print Branch Name
        run: echo "PR check running for branch:${{ github.head_ref }}"
```
![](./images/1-2.png)


4. Create a new branch, push a commit, and open a PR
```bash
git branch
git branch -r
git checkout -b feature/test-workflow
touch test
git add .
git commit -m "Add PR check workflow"
git push origin feature/test-workflow
```
![](./images/1-3.png)

![](./images/1-5.png)

![](./images/1-6.png)

5. Watch the workflow run automatically

![](./images/1-7.png)

![](./images/1-10.png)

![](./images/1-8.png)

![](./images/1-9.png)



**Verify:** Does it show up on the PR page?

Yes, it shows up directly on the `Pull Request page` in the "Checks" section at the bottom, just above the "Merge pull request" button.

This is where GitHub communicates the status of our automation. Since we configured it to trigger on opened and synchronize, every time we open a PR or push a new commit to it, this section will refresh.

**What we will see:**
- **Yellow Circle:** The workflow is currently running.

- **Green Checkmark:** The workflow completed successfully.

---

### Task 2: Scheduled Trigger
1. Add a `schedule:` trigger to any workflow using cron syntax
2. Set it to run every day at midnight UTC

```yaml
name: PR Check

# 2. Trigger on opened or updated (synchronize) against main
on:
  pull_request:
    branches:
      - main
    types: [opened, synchronize]

  # Trigger every day at 00:00 UTC
  schedule:
    - cron: '0 0 * * *'


jobs:
  check-branch:
    runs-on: ubuntu-latest
    steps:
      # 3. Print the branch name using the github context
      - name: Print Branch Name
        run: echo "PR check running for branch:${{ github.head_ref }}"
```
3. Write in your notes: What is the cron expression for every Monday at 9 AM?

```bash
0 9 * * MON
```
```
0: Minute (0)

9: Hour (9 AM)

*: Day of month (every)

*: Month (every)

1: Day of week (1 = Monday)
```
### Task 3: Manual Trigger
1. Create `.github/workflows/manual.yml` with a `workflow_dispatch:` trigger
2. Add an **input** that asks for an `environment` name (staging/production)
3. Print the input value in a step
```bash
name: Manual Environment Deploy

on:
  workflow_dispatch:
    # 2. Add an input for the environment name
    inputs:
      environment:
        description: 'Select the environment to target'
        required: true
        default: 'staging'
        type: choice
        options:
          - staging
          - production

jobs:
  manual-step:
    runs-on: ubuntu-latest
    steps:
      # 3. Print the input value using the context
      - name: Print Environment
        run: echo "Deploying to environment ${{ github.event.inputs.environment }}"
```
![](./images/3-1.png)

![](./images/3-2.png)

![](./images/3-3.png)

4. Go to the **Actions** tab → find the workflow → click **Run workflow**

![](./images/3-4.png)

![](./images/3-5.png)


**Verify:** Can you trigger it manually and see your input printed?

![](./images/3-6.png)

![](./images/3-7.png)

![](./images/3-8.png)

![](./images/3-9.png)

---

### Task 4: Matrix Builds
Create `.github/workflows/matrix.yml` that:
1. Uses a matrix strategy to run the same job across:
   - Python versions: `3.10`, `3.11`, `3.12`
2. Each job installs Python and prints the version
3. Watch all 3 run in parallel

```bash
touch matrix.yml
```
```yml
name: Python Matrix Test

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      # 1. Define the matrix for Python versions
      matrix:
        python-version: ["3.10", "3.11", "3.12"]

    steps:
      - uses: actions/checkout@v4
      
      # 2. Install the specific version from the matrix
      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Display Python version
        run: python --version
```
![](./images/4-1-1.png)

```bash
git add.
git commit -m "Added file: matrix.yml to the repoi - minor update"
git push origin main
```
![](./images/4-1-2.png)

![](./images/4-1-3.png)

![](./images/4-1-4.png)

![](./images/4-1-5.png)

![](./images/4-1-6.png)

![](./images/4-1-7.png)

![](./images/4-1-8.png)

![](./images/4-1-9.png)


Then extend the matrix to also include 2 operating systems — how many total jobs run now?
```yaml
    strategy:
      # 1. Define the matrix for Python versions
      matrix:
        os: [ubuntu-latest, windows-latest]
        python-version: ["3.10", "3.11", "3.12"]
```

![](./images/4-2-1.png)

![](./images/4-2-2.png)

![](./images/4-2-3.png)

![](./images/4-2-4.png)

![](./images/4-2-5.png)

---

### Task 5: Exclude & Fail-Fast
1. In your matrix, **exclude** one specific combination (e.g., Python 3.10 on Windows)
2. Set `fail-fast: false` — trigger a failure in one job and observe what happens to the rest

```bash
vi matrix.yml
```
```yml
name: Python Matrix Test

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build:
    runs-on: ${{ matrix.os }}
    strategy:
      # 2. Prevent one failure from canceling other jobs
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest]
        python-version: ["3.10", "3.11", "3.12"]
        # 1. Exclude Python 3.10 specifically on Windows
        exclude:
          - os: windows-latest
            python-version: "3.10"

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      # Triggering a failure to observe the "fail-fast: false" behavior
      - name: Forced Failure
        if: matrix.python-version == '3.12'
        run: exit 1 

      - name: Display Python version
        run: python --version

```
![](./images/5-1.png)

```bash
git add.
git commit -m "Added file: matrix.yml to the repo - added exclude key: script issue fixed"
git push origin main
```

![](./images/5-2.png)

![](./images/5-3.png)

![](./images/5-4.png)

![](./images/5-5.png)

![](./images/5-6.png)



3. Write in your notes: What does `fail-fast: true` (the default) do vs `false`?

    **Note: Fail-Fast Logic**

- `fail-fast: true` **(Default)**: If any job in the matrix fails, GitHub immediately cancels all other jobs that are currently running. This is great for saving "Actions minutes" and compute costs.

- `fail-fast: false`: If one job fails, the others will keep running until they finish. This is essential for debugging because it lets us see if a failure is universal or specific to just one environment.

---
