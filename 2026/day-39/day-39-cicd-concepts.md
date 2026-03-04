# What is CI/CD?

### Task 1: The Problem
Think about a team of 5 developers all pushing code to the same repo manually deploying to production.

Write in your notes:
1. What can go wrong?

    - **Merge Conflicts & Overwrites:** Without automated checks, developers might accidentally overwrite each other’s changes or push incompatible code.

    - **Human Error:** Manual steps like dragging files or running commands are prone to typos or missed configurations, which can crash production.

    - **Environment Drift:** Production might end up with different settings than development, leading to unpredictable behavior.

    - **No Easy Rollbacks:** If a manual deployment fails, we often lack a quick, reliable way to revert to the previous working state.

2. What does "it works on my machine" mean and why is it a real problem?

    - **Meaning:** It refers to code that runs perfectly in a developer's local setup but fails in the production environment.

    - **The Problem:** This happens because of "environment drift"—differences in operating systems, library versions, or hidden dependencies. It makes debugging incredibly difficult and slow because the issue cannot be easily replicated by others.


3. How many times a day can a team safely deploy manually?

    - For a team of five, we can likely only safely deploy **less than once per day—** perhaps once or twice a week.

    - Manual deployments require high concentration and "all-hands-on-deck" monitoring. Attempting to do this multiple times a day without automation creates a high risk of burnout and catastrophic production errors.

---

### Task 2: CI vs CD
Research and write short definitions (2-3 lines each):
1. **Continuous Integration** — what happens, how often, what it catches
2. **Continuous Delivery** — how it's different from CI, what "delivery" means
3. **Continuous Deployment** — how it differs from Delivery, when teams use it

Write one real-world example for each.

1. **Continuous Integration (CI) — The Frequent Check**
    - **What it is:** We merge our code into the main project many times a day. Every time we do, an automated "robot" immediately builds the app and runs tests to see if we broke anything.

    - **What it catches:** It catches "Integration Hell"—where two developers' code clashes—and small bugs before they become buried under more code.

    - **Real-world Example:** Multiple workers are putting different items (code) into the same box. Before that box can move forward, an **automated scanner** checks it. It makes sure the items aren't broken, the weight is correct, and nothing is missing.

    It stops a "broken" box from ever leaving the warehouse. If a worker tries to put a heavy bowling ball in a box with a glass vase, the system flags it immediately so we can fix it.

2. **Continuous Delivery — The "Ready to Go" State**
    - **How it’s different from CI:** While CI focuses on testing, Delivery ensures the code is always packaged and ready to be shipped. We automate everything except the final "Launch" button.

    - **What "Delivery" means:** It means the software is sitting on the "delivery dock," fully tested and polished, just waiting for a human to say, "Go live now."

    - **Real-world Example:** The box is sitting on the delivery truck. The truck is fueled up and the driver is ready. However, the truck **stays parked** at the warehouse until a manager looks at the schedule and says, "Okay, we have enough packages, you can start the route now."

    We have everything 100% ready to go, but a human makes the final decision on when to actually drive to your house.

3. **Continuous Deployment — The Hands-Off Launch**
    - **How it differs from Delivery:** There is no "Launch" button and no waiting. If the code passes all the automated tests in the CI stage, it is automatically pushed to the live customers immediately.

    - **When teams use it:** We use this when we have extremely high confidence in our automated tests and want to get tiny improvements to users every few minutes.

    - **Real-world Example:** Imagine an Amazon Drone. As soon as that box is packed and passes the automated scanner in the warehouse, the drone immediately lifts off and flies it to your house.

        There is no "manager" or "waiting truck." If the tests (scanners) say the package is good, it goes to the customer **instantly** without any human intervention.

---

### Task 3: Pipeline Anatomy
A pipeline has these parts — write what each one does:
- **Trigger** — what starts the pipeline
- **Stage** — a logical phase (build, test, deploy)
- **Job** — a unit of work inside a stage
- **Step** — a single command or action inside a job
- **Runner** — the machine that executes the job
- **Artifact** — output produced by a job


To build a reliable pipeline, we need to understand these six fundamental parts:

**1. Trigger — The "Start" Button**
The **Trigger** is the event that tells the pipeline to wake up. We don't want to run the entire automation suite for every tiny change we make locally; we only want it to start when specific conditions are met.  
* **Common Triggers:**  
    * A `git push` to the main branch.  
    * Opening or updating a **Pull Request**.  
    * A scheduled time (e.g., a "Nightly Build" at 2 AM).

**2. Stage — The Logical Phase**
We use **Stages** to group related work into chapters. This creates a "fail-fast" mechanism: if the "Build" stage fails, we don't waste resources trying to run "Tests" or "Deploy."  
* **Examples:** `Build`, `Test`, `Security-Scan`, and `Deploy`.

**3. Job — The Unit of Work**
Inside a Stage, we have **Jobs**. A job is a specific set of tasks that run on a single environment. One of the best features of jobs is that we can often run them in **parallel** (at the same time) within a single stage to save time.  
* **Example:** In our `Test` stage, we might have one job for `Unit-Tests` and another for `Frontend-Tests` running simultaneously.

**4. Step — The Individual Action**
The **Step** is the smallest unit of work. It is a single command or script executed within a job. If a job is the "mission," the steps are the specific "instructions."  
* **Examples:**  
    * `npm install`  
    * `docker build -t my-app .`  
    * `python manage.py test`

**5. Runner — The "Muscle"**
The **Runner** is the actual machine (virtual or physical) that executes our commands. The pipeline file is just a set of instructions; the Runner is the computer that reads them and does the heavy lifting.  
* **Note:** We can use "Cloud-Hosted" runners (managed by GitHub/GitLab) or our own "Self-Hosted" Linux servers for more control.

**6. Artifact — The Output**
An **Artifact** is a file or collection of files produced by a job that we want to keep. Since most runners are "ephemeral" (they are deleted after the job finishes), we must specifically tell the pipeline to save these files if we need them later.  
* **Examples:** A `.zip` file of our website, a compiled binary, or a Docker image ready for production.

---

### Task 4: Draw a Pipeline
Draw a CI/CD pipeline for this scenario:
> A developer pushes code to GitHub. The app is tested, built into a Docker image, and deployed to a staging server.

Include at least 3 stages. Hand-drawn and photographed is perfectly fine.

![](./images/A%20clean,%20professiona.png)

---

### Task 5: Explore in the Wild
1. Open any popular open-source repo on GitHub (Kubernetes, React, FastAPI — pick one you know)
```bash
https://github.com/fastapi/full-stack-fastapi-template
```
2. Find their `.github/workflows/` folder
```bash
https://github.com/fastapi/full-stack-fastapi-template/tree/master/.github/workflows
```
3. Open one workflow YAML file
```yaml
name: Test Backend

on:
  push:
    branches:
      - master
  pull_request:
    types:
      - opened
      - synchronize

jobs:
  test-backend:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v6
      - name: Set up Python
        uses: actions/setup-python@v6
        with:
          python-version: "3.10"
      - name: Install uv
        uses: astral-sh/setup-uv@v7
      - run: docker compose down -v --remove-orphans
      - run: docker compose up -d db mailcatcher
      - name: Migrate DB
        run: uv run bash scripts/prestart.sh
        working-directory: backend
      - name: Run tests
        run: uv run bash scripts/tests-start.sh "Coverage for ${{ github.sha }}"
        working-directory: backend
      - run: docker compose down -v --remove-orphans
      - name: Store coverage files
        uses: actions/upload-artifact@v7
        with:
          name: coverage-html
          path: backend/htmlcov
          include-hidden-files: true
      - name: Coverage report
        run: uv run coverage report --fail-under=90
        working-directory: backend
```

4. Write in your notes:
   - What triggers it?
        - Push: Every time code is pushed to the `master` branch.
        - Pull Request: Whenever a pull request is newly `opened` or updated (`synchronize`).
   - How many jobs does it have?
        - It has one job named `test-backend`
   - What does it do? (best guess)
        - This workflow automates the testing and quality assurance of a Python-based backend.

---
