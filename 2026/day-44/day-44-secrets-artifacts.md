# Secrets, Artifacts & Running Real Tests in CI

### Task 1: GitHub Secrets
1. Go to your repo → Settings → Secrets and Variables → Actions
2. Create a secret called `MY_SECRET_MESSAGE`
3. Create a workflow that reads it and prints: `The secret is set: true` (never print the actual value)
4. Try to print `${{ secrets.MY_SECRET_MESSAGE }}` directly — what does GitHub show?

```bash
vi secret-test.yml
```

```yml
name: Secret Masking Test
on: [workflow_dispatch]

jobs:
  check-secrets:
    runs-on: ubuntu-latest
    steps:
      - name: Verify Secret Existence
        run: |
          if [ -n "${{ secrets.MY_SECRET_MESSAGE }}" ]; then
            echo "The secret is set: true"
          else
            echo "The secret is set: false"
          fi

      - name: Attempt to Print Secret
        run: echo "The secret value is ${{ secrets.MY_SECRET_MESSAGE }}"

```
![](./images/task-1/1-1.png)

![](./images/task-1/1-2.png)

![](./images/task-1/1-3.png)

![](./images/task-1/1-4.png)

![](./images/task-1/1-5.png)

![](./images/task-1/1-6.png)

![](./images/task-1/1-7.png)

![](./images/task-1/1-8.png)

![](./images/task-1/1-9.png)

![](./images/task-1/1-10.png)


Write in your notes: Why should you never print secrets in CI logs?

Even though modern platforms like GitHub Actions have built-in safeguards, printing secrets in CI logs is a major security risk. 

It’s like leaving a spare key under a doormat—it looks hidden, but anyone who knows where to look can find it.

---

### Task 2: Use Secrets as Environment Variables
1. Pass a secret to a step as an environment variable
2. Use it in a shell command without ever hardcoding it
3. Add `DOCKER_USERNAME` and `DOCKER_TOKEN` as secrets (you'll need these on Day 45)

```bash
vi secret-handling.yml
```
```yml
name: Secure Secret Handling
on: [workflow_dispatch]

jobs:
  docker-login-test:
    runs-on: ubuntu-latest
    steps:
      - name: Docker Login Simulation
        # We map the secrets to environment variables here
        env:
          USER: ${{ secrets.DOCKER_USERNAME }}
          TOKEN: ${{ secrets.DOCKER_TOKEN }}
        run: |
          # We use the variable names, NOT the secrets directly in the command
          echo "Attempting to log in as: $USER"
          
          # In a real scenario, we would use:
          # echo "$TOKEN" | docker login -u "$USER" --password-stdin
          
          # For this exercise, we verify the token is loaded without printing it
          if [ -n "$TOKEN" ]; then
            echo "Login token successfully loaded into environment."
          fi
```
![](./images/task-2/2-1.png)

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

---

### Task 3: Upload Artifacts
1. Create a step that generates a file — e.g., a test report or a log file
2. Use `actions/upload-artifact` to save it
3. After the workflow runs, download the artifact from the Actions tab

```bash
vi generate-artifact.yml
```
```yml
name: Artifact Generation Demo
on: [workflow_dispatch]

jobs:
  build-and-report:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Generate a Test Report
        run: |
          mkdir -p output
          echo "Test Run Date: $(date)" > output/test-report.txt
          echo "Status: Passed" >> output/test-report.txt
          echo "Build ID: ${{ github.run_id }}" >> output/test-report.txt
          echo "This is a dummy log file for our DevOps notes." > output/build.log

      - name: Upload Build Artifacts
        uses: actions/upload-artifact@v4
        with:
          name: devops-test-results  # The name of the zip file we will download
          path: output/              # The directory or file we want to save
          retention-days: 5          # Optional: How long to keep the file
```
```bash
git add generate-artifact.yml
git commit -m "Added generate-artifact file to the repo" generate-artifact.yml
git push origin main
```
![](./images/task-3/3-1.png)

![](./images/task-3/3-2.png)

![](./images/task-3/3-3.png)

![](./images/task-3/3-4.png)

![](./images/task-3/3-5.png)


**Verify:** Can you see and download it from GitHub?

![](./images/task-3/3-6.png)

![](./images/task-3/3-7.png)

![](./images/task-3/3-8.png)

---

### Task 4: Download Artifacts Between Jobs
1. Job 1: generate a file and upload it as an artifact
2. Job 2: download the artifact from Job 1 and use it (print its contents)

```bash
vi multi-job-artifact.yml
```
```yml
name: Multi-Job Artifact Handoff
on: [workflow_dispatch]

jobs:
  job_1_producer:
    name: Generate Data
    runs-on: ubuntu-latest
    steps:
      - name: Create File
        run: |
          echo "Hello from Job 1! Generated at: $(date)" > shared-data.txt

      - name: Upload for Job 2
        uses: actions/upload-artifact@v4
        with:
          name: handoff-payload
          path: shared-data.txt

  job_2_consumer:
    name: Process Data
    runs-on: ubuntu-latest
    needs: job_1_producer  # This ensures Job 2 waits for Job 1 to finish
    steps:
      - name: Download from Job 1
        uses: actions/download-artifact@v4
        with:
          name: handoff-payload

      - name: Use the Data
        run: |
          echo "Reading data received from the producer job:"
          cat shared-data.txt
```
![](./images/task-4/4-1.png)

![](./images/task-4/4-2.png)

![](./images/task-4/4-3.png)

![](./images/task-4/4-4.png)

![](./images/task-4/4-5.png)

![](./images/task-4/4-6.png)

![](./images/task-4/4-7.png)


**Write in your notes: When would you use artifacts in a real pipeline?**

**Artifacts in CI/CD Pipelines**

In a professional CI/CD environment, artifacts are the *"connective tissue"* between different stages of a pipeline. Since every job in a workflow runs on a fresh, isolated virtual machine, artifacts are the only way to pass the heavy lifting done in one step to the next.


**Common Scenarios for Using Artifacts**

- **1. Build-Once, Deploy-Many**
This is the most critical use case. We compile our code (e.g., creating a `.jar` for Java, a `dist` folder for React, or a binary for Go) in an initial **Build Job**. We then save that specific version as an artifact.

    **Why:**  
    This ensures that the exact same code we tested in the **Staging Job** is the one we deploy in the **Production Job**. If we re-compiled at every step, we might accidentally introduce different dependencies or environment-specific bugs.


- **2. Security and Compliance Audits**
In highly regulated industries, we need *proof* of what happened during the build.

    - **Scan Reports:** Tools like **SonarQube** (code quality) or **Trivy** (container vulnerabilities) generate JSON or PDF reports. Saving these as artifacts allows security teams to review them later without needing access to the CI runner itself.  
    - **SBOM (Software Bill of Materials):** A list of every library and version used in the build, stored as a record for supply chain security.

- **3. Separation of Concerns (Compute Efficiency)**
Not every job needs the same resources.

    **Scenario:**  
    We might have a **Build Job** that requires a high-CPU runner to compile code quickly. Once the binary is created and saved as an artifact, a **Test Job** can then download that binary and run on a much cheaper, smaller instance to save costs.

- **4. Preserving Test Results for Debugging**
When a pipeline fails, we need to know why.

    - **Logs & Screenshots:** For UI tests (like Selenium or Playwright), configure the pipeline to capture screenshots or videos of the browser at the moment of failure.  
    - **Test Coverage:** Save HTML reports from tools like **Istanbul** or **Jacoco** to see exactly which lines of code were missed by unit tests.


---

### Task 5: Run Real Tests in CI
Take any script from your earlier days (Python or Shell) and run it in CI:
1. Add your script to the `github-actions-practice` repo

```bash
vi script.py
```
```python
print("Running my CI/CD Python script...")
exit(0)
```

2. Write a workflow that:
   - Checks out the code
   - Installs any dependencies needed
   - Runs the script
   - Fails the pipeline if the script exits with a non-zero code
```bash
vi run-python.yml
```
```yml
name: Run Python Script Workflow

on:
  push:
    branches: [ main ]

jobs:
  run-python:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.13'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          # Add any dependencies here, e.g.:
          # pip install -r requirements.txt

      - name: Run script
        run: python script.py
```
![](./images/task-5/5-1.png)

![](./images/task-5/5-2.png)

![](./images/task-5/5-3.png)

![](./images/task-5/5-4.png)

![](./images/task-5/5-5.png)

![](./images/task-5/5-6.png)

3. Intentionally break the script — verify the pipeline goes red
```python
print("Breaking the pipeline...")
exit(1)
```
![](./images/task-5/5-7.png)

![](./images/task-5/5-8.png)

![](./images/task-5/5-9.png)

![](./images/task-5/5-10.png)

![](./images/task-5/5-11.png)


4. Fix it — verify it goes green again
```python
print("Pipeline fixed!")
exit(0)
```
![](./images/task-5/5-12.png)

![](./images/task-5/5-13.png)

![](./images/task-5/5-14.png)

![](./images/task-5/5-15.png)

---

### Task 6: Caching
1. Add `actions/cache` to a workflow that installs dependencies
```bash
vi requirements.txt
```
```
flask
redis
pandas
numpy
tensorflow
torch
```
```bash
vim caching-demo.yml
```
```yml
name: Caching Demo
on: [workflow_dispatch]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.10'

      - name: Cache Pip Dependencies
        uses: actions/cache@v4
        id: cache-pip
        with:
          path: ~/.cache/pip
          key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
          restore-keys: |
            ${{ runner.os }}-pip-

      - name: Install Dependencies
        run: |
          python -m pip install --upgrade pip
          pip install flask redis pandas  # Simulating a heavy install
```
![](./images/task-6/6-1.png)

![](./images/task-6/6-2.png)

![](./images/task-6/6-3.png)

![](./images/task-6/6-4.png)

2. Run it twice — observe the time difference

![](./images/task-6/6-5.png)

![](./images/task-6/6-6.png)

3. Write in your notes: [What is being cached and where is it stored?](caching.md)

---