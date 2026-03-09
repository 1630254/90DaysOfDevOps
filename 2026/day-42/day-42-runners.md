# Runners: GitHub-Hosted & Self-Hosted

### Task 1: GitHub-Hosted Runners
1. Create a workflow with 3 jobs, each on a different OS:
   - `ubuntu-latest`
   - `windows-latest`
   - `macos-latest`
2. In each job, print:
   - The OS name
   - The runner's hostname
   - The current user running the job

```yml
name: Multi-OS Parallel Check

on:
  workflow_dispatch:

jobs:
  linux-job:
    name: Ubuntu Runner
    runs-on: ubuntu-latest
    steps:
      - name: System Info.
        run: |
          echo "OS Name: ${{ runner.os }}"
          hostname
          whoami

  windows-job:
    name: Windows Runner
    runs-on: windows-latest
    steps:
      - name: System Info.
        shell: pwsh
        run: |
          echo "OS Name: ${{ runner.os }}"
          hostname
          whoami
  macos-job:
    name: macOS Runner
    runs-on: macos-latest
    steps:
      - name: System Info.
        run: |
          echo "OS Name: ${{ runner.os }}"
          hostname
          whoami
```
```bash
git add multi-os-check.yml
git commit -m "Added multi-os-check file to the repo" multi-os-check.yml
git push origin main
```
![](./images/task-1/1-1.png)

![](./images/task-1/1-2.png)

3. Watch all 3 run in parallel

![](./images/task-1/1-3.png)

![](./images/task-1/1-4.png)

![](./images/task-1/1-5.png)

![](./images/task-1/1-6.png)

![](./images/task-1/1-7.png)

![](./images/task-1/1-8.png)

**Write in your notes: What is a GitHub-hosted runner? Who manages it?**


A **GitHub-hosted runner** is a virtual machine provided by GitHub to execute workflows.

Management

**GitHub** manages these runners entirely. They handle the:

- Hardware provisioning

- Operating system maintenance (updates and patches)

- Pre-installed software and tools

This allows us to focus on our CI/CD logic without worrying about infrastructure overhead.

---

### Task 2: Explore What's Pre-installed
1. On the `ubuntu-latest` runner, run a step that prints:
   - Docker version
   - Python version
   - Node version
   - Git version

```yml
  linux-job:
    name: Ubuntu Runner
    runs-on: ubuntu-latest
    steps:
      - name: System Info.
        run: |
          echo "OS Name: ${{ runner.os }}"
          hostname
          whoami
          
      - name: Check Pre-installed Tool Versions
        run: |
          docker --version
          python3 --version
          node --version
          git --version   
```
![](./images/task-2/2-1.png)

![](./images/task-2/2-2.png)

![](./images/task-2/2-3.png)

![](./images/task-2/2-4.png)

![](./images/task-2/2-5.png)

![](./images/task-2/2-6.png)

![](./images/task-2/2-7.png)

![](./images/task-2/2-8.png)

2. Look up the GitHub docs for the full list of pre-installed software on `ubuntu-latest`

The full manifest of everything pre-installed (from awk to zstd) is maintained in the official GitHub runner-images repository. Since ubuntu-latest currently points to Ubuntu 24.04, we can find the complete list here

[Included Software: Ubuntu 24.04 LTS Readme](https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2404-Readme.md)

![](./images/task-2/2-9.png)

**Write in your notes: Why does it matter that runners come with tools pre-installed?**


Having tools pre-installed on GitHub-hosted runners is beneficial for several reasons:

- **Faster Workflows:** We don't need to spend time downloading and installing common compilers, runtimes, or CLIs in every job run.

- **Consistency:** It ensures a standardized environment across different runs, reducing "it works on my machine" type issues.

- **Reduced Complexity:** Our workflow YAML files remain cleaner because they focus on logic rather than environment setup.

- **Cost Efficiency:** Since we pay for runner minutes, reducing the setup time directly lowers the cost of our CI/CD pipelines.

---

### Task 3: Set Up a Self-Hosted Runner
1. Go to your GitHub repo → Settings → Actions → Runners → **New self-hosted runner**
2. Choose Linux as the OS
3. Follow the instructions to download and configure the runner on:
   - Your local machine, OR
   - A cloud VM (EC2, Utho, or any VPS)
4. Start the runner — verify it shows as **Idle** in GitHub

![](./images/task-3/3-1.png)

![](./images/task-3/3-2.png)

![](./images/task-3/3-3.png)

![](./images/task-3/3-4.png)

![](./images/task-3/3-5.png)

![](./images/task-3/3-6.png)

![](./images/task-3/3-7.png)

![](./images/task-3/3-8.png)

![](./images/task-3/3-9.png)


> When installing a runner on the latest Ubuntu hosted on AWS EC2.

We may encounter the following error if running as root:`"Must not run with sudo while trying to configure runner in ec2"`

To resolve this, we can set the following environment variable:

```bash
export AGENT_ALLOW_RUNASROOT="1"
```


**Verify:** Your runner appears in the Runners list with a green dot.

![](./images/task-3/3-10.png)

---

### Task 4: Use Your Self-Hosted Runner
1. Create `.github/workflows/self-hosted.yml`
2. Set `runs-on: self-hosted`
3. Add steps that:
   - Print the hostname of the machine (it should be YOUR machine/VM)
   - Print the working directory
   - Create a file and verify it exists on your machine after the run
4. Trigger it and watch it run on your own hardware

```bash
vi self-hosted.yml
```
```yml
name: Self-hosted Runner Activity

on:
  workflow_dispatch: # Corrected from 'dispatch'

jobs:
  self-hosted-job:
    runs-on: self-hosted
    steps:
      - name: System and Environment Check
        run: |
          echo "Machine Hostname:"
          hostname
          echo "Current Working Directory:"
          pwd
          
      - name: File Persistence Test
        run: |
          echo "Creating local file..."
          echo "Created by GitHub Action on $(date)" > self_hosted_test.txt
          ls -l self_hosted_test.txt
          echo "File path: $(pwd)/self_hosted_test.txt"
```
![](./images/task-4/4-1.png)

![](./images/task-4/4-2.png)

![](./images/task-4/4-3.png)

![](./images/task-4/4-4.png)

![](./images/task-4/4-5.png)

**Verify:** Check your machine — is the file there?

![](./images/task-4/4-6.png)

---

### Task 5: Labels
1. Add a **label** to your self-hosted runner (e.g., `my-linux-runner`)
2. Update your workflow to use `runs-on: [self-hosted, my-linux-runner]`
3. Trigger it — does it still pick up the job?

```bash
vi self-hosted.yml
```

```yml
name: Targeted Self-hosted Activity

on:
  workflow_dispatch:

jobs:
  labeled-job:
    # This ensures the job ONLY runs on a runner that has BOTH labels
    runs-on: [self-hosted, my-linux-runner]
    
    steps:
      - name: Verify Environment
        run: |
          echo "Running on: $(hostname)"
          echo "Labels matched successfully!"
```
![](./images/task-5/5-1.png)

![](./images/task-5/5-2.png)

![](./images/task-5/5-3.png)

![](./images/task-5/5-4.png)

![](./images/task-5/5-5.png)

![](./images/task-5/5-6.png)

![](./images/task-5/5-7.png)

![](./images/task-5/5-8.png)

![](./images/task-5/5-9.png)

Write in your notes: Why are labels useful when you have multiple self-hosted runners?

Here’s why we use them:

- **Hardware Targeting:** We can route GPU-intensive jobs to a machine with an NVIDIA card (e.g., label: gpu-enabled).

- **Environment Specifics:** We can ensure a deployment job only runs on a runner sitting inside a specific VPC or subnet (e.g., label: production-zone).

- **Operating Systems:** While self-hosted is the default, labels like arm64 or macos-m1 help us distinguish between different architectures we own.

- **Load Balancing:** GitHub will automatically pick any available runner that matches all specified labels, helping us scale our local CI capacity.

---

### Task 6: GitHub-Hosted vs Self-Hosted
Fill this in your notes:

| | GitHub-Hosted | Self-Hosted |
|---|---|---|
| Who manages it? | ? | ? |
| Cost | ? | ? |
| Pre-installed tools | ? | ? |
| Good for | ? | ? |
| Security concern | ? | ? |


| Feature              | GitHub-Hosted                     | Self-Hosted                        |
|----------------------|-----------------------------------|------------------------------------|
| **Who manages it?**  | GitHub                            | We (The User)                      |
| **Cost**             | Usage-based (Free for public)     | Our hardware/cloud costs           |
| **Pre-installed tools** | Extensive (Docker, Python, Node) | Minimal (Manual setup required)    |
| **Good for**         | Standard builds, quick setup      | Local network, custom hardware     |
| **Security concern** | Shared infrastructure             | Local machine/network hardening    |

---