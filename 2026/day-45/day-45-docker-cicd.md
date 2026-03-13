### Task 1: Prepare
1. Use the app you Dockerized on Day 36 (or any simple Dockerfile)
2. Add the Dockerfile to your `github-actions-practice` repo (or create a minimal one)
3. Make sure `DOCKER_USERNAME` and `DOCKER_TOKEN` secrets are set from Day 44

```bash
cd /home/student/90DaysOfDevOps/2026/day-36
cp app.py /home/student/github-actions-practice/
cp Dockerfile  /home/student/github-actions-practice/
cp docker-compose.yml /home/student/github-actions-practice/
cp requirements.txt /home/student/github-actions-practice/
```
![](./images/task-1/1-1.png)
---

### Task 2: Build the Docker Image in CI
Create `.github/workflows/docker-publish.yml` that:
1. Triggers on push to `main`
2. Checks out the code
3. Builds the Docker image and tags it

```bash
vi docker-publish.yml
```
```yml
name: Docker Image CI

on:
  push:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout source code
      # This action copies your repository files (including the Dockerfile) to the runner
      uses: actions/checkout@v4

    - name: Build and push Docker image
      # This action builds the image from your Dockerfile on the runner
      uses: docker/build-push-action@v6
      with:
        context: .
        push: false
        tags: | # Set to true to push to registry, false to build locally for testing
          ${{ secrets.DOCKER_USERNAME }}/telephone-book:latest
```
![](./images/task-2/2-1.png)

![](./images/task-2/2-2.png)

**Verify:** Check the build step logs — does the image build successfully?

![](./images/task-2/2-3.png)

![](./images/task-2/2-4.png)

![](./images/task-2/2-5.png)
---

### Task 3: Push to Docker Hub
Add steps to:
1. Log in to Docker Hub using your secrets
2. Tag the image as `username/repo:latest` and also `username/repo:sha-<short-commit-hash>`
3. Push both tags
```bash
vi docker-publish.yml
```
```yml
name: Docker Image CI

on:
  push:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout source code
      # This action copies your repository files (including the Dockerfile) to the runner
      uses: actions/checkout@v4

    - name: Log in to Docker Hub
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_TOKEN }}

    - name: Get short commit SHA
      id: slug
      run: echo "short_sha=$(echo ${{ github.sha }} | cut -c1-7)" >> $GITHUB_OUTPUT

    - name: Build and push Docker image
      # This action builds the image from your Dockerfile on the runner
      uses: docker/build-push-action@v6
      with:
        context: .
        push: true
        tags: | # Set to true to push to registry, false to build locally for testing
          ${{ secrets.DOCKER_USERNAME }}/telephone-book:latest
          ${{ secrets.DOCKER_USERNAME }}/telephone-book:${{ steps.slug.outputs.short_sha }}
```
![](./images/task-3/3-1.png)

![](./images/task-3/3-2.png)

![](./images/task-3/3-3.png)

**Verify:** Go to Docker Hub — is your image there with both tags?

![](./images/task-3/3-4.png)

![](./images/task-3/3-5.png)

---

### Task 4: Only Push on Main

Add a condition so the push step only runs on the `main` branch — not on feature branches or PRs.

```bash
vi docker-publish.yml
```
```yml
name: Docker Image CI

on:
  push:
    branches: [ "**" ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout source code
      # This action copies your repository files (including the Dockerfile) to the runner
      uses: actions/checkout@v4

    - name: Log in to Docker Hub (Optional, if pushing to a registry)
      if: github.ref == 'refs/heads/main'
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_TOKEN }}

    - name: Get short commit SHA
      id: slug
      run: echo "short_sha=$(echo ${{ github.sha }} | cut -c1-7)" >> $GITHUB_OUTPUT

    - name: Build and push Docker image
      # This action builds the image from your Dockerfile on the runner
      uses: docker/build-push-action@v6
      with:
        context: .
        load: true
        push: ${{ github.ref == 'refs/heads/main' }}
        tags: | # Set to true to push to registry, false to build locally for testing
          ${{ secrets.DOCKER_USERNAME }}/telephone-book:latest
          ${{ secrets.DOCKER_USERNAME }}/telephone-book:${{ steps.slug.outputs.short_sha }}

    - name: Verify image exists locally
      run: |
        docker images
        # We can also check for our specific image name
        docker image inspect ${{ secrets.DOCKER_USERNAME }}/telephone-book:latest || echo "Image not found!"
```
```bash
git checkout -b feature/workflow-test2
vi docker-publish.yml
git add .
git commit -m "<comment>"
git push origin feature/workflow-test2
```
![](./images/task-4/4-1.png)

![](./images/task-4/4-2.png)

![](./images/task-4/4-3.png)

![](./images/task-4/4-4.png)

![](./images/task-4/4-5.png)

![](./images/task-4/4-6.png)

Test it: push to a feature branch and verify the image is built but NOT pushed.

![](./images/task-4/4-7.png)


---

### Task 5: Add a Status Badge
1. Get the badge URL for your `docker-publish` workflow from the Actions tab

![](./images/task-5/5-1.png)

![](./images/task-5/5-2.png)

2. Add it to your `README.md`

```bash
vi README.md
git add README.md
git commit -m "<msg>"
git push origin main
```
![](./images/task-5/5-3.png)

3. Push — the badge should show green

![](./images/task-5/5-4.png)

---

### Task 6: Pull and Run It
1. On your local machine (or a cloud server), pull the image you just pushed
2. Run it
3. Confirm it works


![](./images/task-6/6-1.png)

![](./images/task-6/6-2.png)


```bash
vi docker-publish.yml 
```
```yml
name: Docker Image CI

on:
  push:
    branches: [ "**" ]

jobs:
  build:
    runs-on: self-hosted

    steps:
    - name: Checkout source code
      # This action copies your repository files (including the Dockerfile) to the runner
      uses: actions/checkout@v4

    - name: Installing required packages
      run: |
         echo "Installing required packages & folders"
         sudo apt-get update && sudo apt-get install docker.io docker-compose-v2 -y
         sudo usermod -aG docker $USER

    - name: Log in to Docker Hub (Optional, if pushing to a registry)
      if: github.ref == 'refs/heads/main'
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_TOKEN }}

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3
      with:
        driver: docker-container # Forces the use of a containerized builder for better compatibility

    - name: Get short commit SHA
      id: slug
      run: echo "short_sha=$(echo ${{ github.sha }} | cut -c1-7)" >> $GITHUB_OUTPUT

    - name: Build and push Docker image
      # This action builds the image from your Dockerfile on the runner
      uses: docker/build-push-action@v6
      with:
        context: .
        load: true
        push: ${{ github.ref == 'refs/heads/main' }}
        provenance: false
        sbom: false
        tags: | # Set to true to push to registry, false to build locally for testing
          ${{ secrets.DOCKER_USERNAME }}/telephone-book:latest
          ${{ secrets.DOCKER_USERNAME }}/telephone-book:${{ steps.slug.outputs.short_sha }}

    - name: Update .env file for Docker Compose
      run: |
       echo "DOCKER_USERNAME=${{ secrets.DOCKER_USERNAME }}" >> .env
       echo "IMAGE_TAG=${{ steps.slug.outputs.short_sha }}" >> .env

    - name: Build and Start Containers
      run: |
        sudo docker compose down && sudo docker compose up -d --build --force-recreate --pull always

    - name: Verify Deployment
      run: |
        sudo docker compose ps
        sudo docker ps -a
```
```bash
git add . 
git commit -m "<comment>"
git push origin main  
```

![](./images/task-6/6-3.png)

![](./images/task-6/6-4.png)

![](./images/task-6/6-5.png)

![](./images/task-6/6-6.png)

![](./images/task-6/6-7.png)

![](./images/task-6/6-8.png)

![](./images/task-6/6-9.png)


**Write in your notes: What is the full journey from `git push` to a running container?**

#### The Trigger: Local Machine
- The journey begins when we execute `git push`.
- GitHub detects the update and triggers the workflow because it’s configured to monitor all branches (`"**"`).

#### The Orchestrator: GitHub Actions
- GitHub sends execution instructions to the GitHub Runner application active on the self-hosted hardware.

#### The Builder: Docker Buildx
1. **Checkout**: The latest code is pulled into the runner’s workspace.  
2. **Buildx Initialization**: A containerized builder is created to handle the Dockerfile instructions.  
3. **Tagging & Loading**:  
   - The image is tagged with `latest` and a unique `short_sha`.  
   - Using `load: true` moves this image directly into the machine’s local Docker registry.  
4. **Registry Push**:  
   - If on the `main` branch, the image is also uploaded to Docker Hub.  

#### The Deployment: Docker Compose
1. **Environment Setup**:  
   - A `.env` file is generated to map GitHub Secrets to the container environment.  
2. **Orchestration**:  
   - `docker compose down` clears previous instances.  
   - `docker compose up -d` starts the new ones.  
3. **Startup**:  
   - Since the new image was just *loaded* into the local registry, Compose finds it immediately and launches the containers.  

#### The Destination: Running Container
- The application is now live, running in a detached container.  
- It’s isolated within its custom network, ready to serve requests.  

---
