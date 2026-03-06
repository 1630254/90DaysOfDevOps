# Your First GitHub Actions Workflow

### Task 1: Set Up
1. Create a new **public** GitHub repository called `github-actions-practice`
2. Clone it locally
3. Create the folder structure: `.github/workflows/`

![](./images/1-1.png)

![](./images/1-2.png)

```bash
git clone git@github.com:1630254/github-actions-practice.git
cd github-actions-practice
mkdir -p .github/workflows/
cd .github/workflows
```
![](./images/1-3.png)

---

### Task 2: Hello Workflow
Create `.github/workflows/hello.yml` with a workflow that:
1. Triggers on every `push`
2. Has one job called `greet`
3. Runs on `ubuntu-latest`
4. Has two steps:
   - Step 1: Check out the code using `actions/checkout`
   - Step 2: Print `Hello from GitHub Actions!`

```bash
vi hello.yml
```
```yml
---
name: Hello Workflow

on:
  push:
    branches:
      - main

jobs:
  greet:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Print greeting
        run: echo "Hello from GitHub Actions!"
```
Push it. Go to the **Actions** tab on GitHub and watch it run.

![](./images/2-1.png)

![](./images/2-2.png)

![](./images/2-3.png)

![](./images/2-4.png)

![](./images/2-5.png)

**Verify:** Is it green? Click into the job and read every step.

![](./images/2-6.png)

![](./images/2-7.png)

![](./images/2-8.png)

---

### Task 3: Understand the Anatomy
- **`on:`** Defines the event that triggers the workflow (e.g., `push`, `pull_request`).

- **`jobs:`** Groups together all the tasks that the workflow will execute.

- **`runs-on:`** Specifies the type of machine to run the job on (e.g., `ubuntu-latest`).

- **`steps:`** A linear sequence of operations that make up a job.

- **`uses:`** Selects a specific action to run as part of a step (e.g., a pre-built action like `checkout`).

- **`run:`** Executes a command-line instruction using the operating system's shell.

- **`name:`** Provides a human-readable label for a step that appears in the GitHub Actions log.

---

### Task 4: Add More Steps
Update `hello.yml` to also:
1. Print the current date and time
```yaml
    - name: Print current date and time
      run: echo "Current date and time: $(date)"    
```
2. Print the name of the branch that triggered the run (hint: GitHub provides this as a variable)
```yaml
    - name: Print the branch/tag name
      run:  echo "The ref name is ${{ github.ref_name }}"   
```
3. List the files in the repo
```yaml
    - name: List all files in the workspace
      run: |
        echo "Listing all files in the workspace directory:"
        ls -R ${{ github.workspace }} # Lists files recursively from the root of the workspace  
```
4. Print the runner's operating system
```yaml
    - name: Print OS name (Context Expression)
      run: echo "The runner OS is $RUNNER_OS"
```
![](./images/4-1.png)

Push again — watch the new run.

```bash
git status
git add .
git commit -m "Task 4: Add More Steps - date: error fixed"
git push origin main
```

![](./images/4-2.png)

![](./images/4-3.png)

![](./images/4-4.png)

![](./images/4-5.png)

![](./images/4-6.png)

---

### Task 5: Break It On Purpose
1. Add a step that runs a command that will **fail** (e.g., `exit 1` or a misspelled command)

```bash
vi hello.yml
```

![](./images/5-1.png)

2. Push and observe what happens in the Actions tab

```bash
git add .
git commit -m "feat:Task 5: Break It On Purpose - Implemented"
git push origin main
```

![](./images/5-2.png)

![](./images/5-3.png)

![](./images/5-4.png)

![](./images/5-5.png)

3. Fix it and push again

```bash
git status
git add .
git commit -m "feat:Task 5: Break It On Purpose - Implemented: Indentation fix done"
git push origin main
```

![](./images/5-6.png)

![](./images/5-7.png)

![](./images/5-8.png)

![](./images/5-9.png)

```bash
vi hello.yml
git add .
git commit -m "chore:Task 5: Break It On Purpose - Implemented: Command fix done"
git push origin main
```

![](./images/5-10.png)

![](./images/5-11.png)

![](./images/5-12.png)

![](./images/5-13.png)

Write in your notes: What does a failed pipeline look like? How do you read the error?

In our case, the failure appeared as a **Red "X"** in the GitHub Actions tab. Because of specific typos in our code, the pipeline manifested the failure in three ways:

**🔴 The "Broken" Step**
- In the job view, the step titled **Print the branch/tag name** was highlighted in red.
- Cause: a typo (`ruun` instead of `run`).

**⚪ The "Skipped" Steps**
- All subsequent steps, like **List all files in the workspace** and **Print OS name**, were greyed out with a "skipped" icon.
- They never executed because the pipeline stopped at the first error.

**⚠️ Indentation Errors**
- When indentation was wrong on the final step, GitHub sometimes wouldn't even start the run.
- Instead of listing steps, the Actions page showed a **"Workflow file error"** banner at the top.

**How We Read and Resolved the Errors**

We followed a logical flow to identify and fix the three specific "bugs" in our workflow:

**Step 1:** Expanding the Logs
- Clicked on the failed **greet job**.
- Expanded the step marked with the red icon.

**Step 2:** Identifying the `Command Not Found` Error
- Logs showed:  
  ```bash
  bash: ruun: command not found
  ```
- **Resolution:** Corrected the typo from `runn`  to the GitHub Actions keyword `run`.

**Step 3:** Spotting the Invalid Context
- 	Attempted to use `${{date}}`.
- 	Logs showed the variable was empty or unrecognized (not a valid GitHub context).
- 	**Resolution:** Replaced with the standard Linux shell command:
    ```bash
    $(date)
    ```
- 	inside the `run`  block.

**Step 4:** Fixing the YAML Structure
- 	The `run` command for the OS name was indented too far.
- 	YAML parser couldn't associate the command with its step.
- 	**Resolution:** Aligned the `run` key vertically with the `name` key to satisfy strict YAML spacing rules.


---
