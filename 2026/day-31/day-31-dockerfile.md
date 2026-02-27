# Dockerfile: Build Your Own Images

### Task 1: Your First Dockerfile
1. Create a folder called `my-first-image`
    ```bash
    mkdir my-first-image
    ```
    ![](./images/task-1/Screenshot%20from%202026-02-25%2020-38-58.png)

2. Inside it, create a `Dockerfile` that:
   - Uses `ubuntu` as the base image
   - Installs `curl`
   - Sets a default command to print `"Hello from my custom image!"`
    ```bash
    cat Dockerfile 
    FROM ubuntu:latest

    WORKDIR /app

    RUN apt update && apt install curl -y

    CMD ["echo", "Hello from my custom image!"]
    ``` 
    ![](./images/task-1/Screenshot%20from%202026-02-25%2020-40-49.png)

3. Build the image and tag it `my-ubuntu:v1`
    ```bash
    sudo docker build -t my-ubuntu:v1 .
    ```
    ![](./images/task-1/Screenshot%20from%202026-02-25%2020-42-01.png)

4. Run a container from your image
    ```bash
    sudo docker run -d --name ubuntu-box my-ubuntu:v1 
    ```
    ![](./images/task-1/Screenshot%20from%202026-02-25%2020-46-19.png)

**Verify:** The message prints on `docker run`

---

### Task 2: Dockerfile Instructions
Create a new Dockerfile that uses **all** of these instructions:
- `FROM` — base image
- `RUN` — execute commands during build
- `COPY` — copy files from host to image
- `WORKDIR` — set working directory
- `EXPOSE` — document the port
- `CMD` — default command

Build and run it. Understand what each line does.

```bash
mkdir my-second-image
cd my-second-image/
```
![](./images/task-2/Screenshot%20from%202026-02-25%2021-05-22.png)

```bash
cat > index.js
// index.js
const http = require('http');
http.createServer((req, res) => res.end('Hello from Docker!')).listen(3000);
console.log('Server running on port 3000');
```
![](./images/task-2/Screenshot%20from%202026-02-26%2005-28-01.png)

```bash
cat > package.json
{
  "name": "docker-test-app",
  "version": "1.0.0",
  "description": "A simple app to test Docker instructions",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```
![](./images/task-2/Screenshot%20from%202026-02-26%2005-42-11.png)

```bash
vi Dockerfile 

# Start from the official lightweight Node.js 18 image
FROM node:18-slim

# Set the working directory inside the container to /app
WORKDIR /app

# Copy all files from the current directory (host) into /app (container)
COPY . .

# Install project dependencies listed in package.json
# Note: Since we copied everything at once, this step will re-run
# whenever any file changes (no caching benefit here)
RUN npm install

# Document that the application listens on port 3000
EXPOSE 3000

# Define the default command to run when the container starts
# This launches the Node.js application using index.js
CMD ["node", "index.js"]
```
![](./images/task-2/Screenshot%20from%202026-02-26%2006-27-54.png)


**Dockerfile Instructions Explained**

| Instruction | What it actually does in this Dockerfile |
|-------------|-------------------------------------------|
| **FROM node:18-slim** | **The Foundation**: We start from the official lightweight Node.js 18 image. This gives us Node.js preinstalled without needing to set it up manually. |
| **WORKDIR /app** | **The Home Base**: Creates `/app` if it doesn’t exist and makes it the working directory. All subsequent commands run inside `/app`. |
| **COPY . .** | **The Mover**: Copies all files from our local project directory into the container’s `/app` folder. This includes `package.json`, source code, and other files. |
| **RUN npm install** | **The Builder**: Installs Node.js dependencies listed in `package.json`. Since we copied everything at once, this step will re-run whenever any file changes (no caching benefit). |
| **EXPOSE 3000** | **The Map**: Documents that our application listens on port `3000`. It doesn’t actually open the port—we still need to use `-p 3000:3000` when running the container. |
| **CMD ["node", "index.js"]** | **The Starter**: Defines the default command to run when the container starts. Here, it launches our Node.js app by running `index.js`. |

```bash
sudo docker build -t my-custom-app .
```
![](./images/task-2/Screenshot%20from%202026-02-26%2006-24-37.png)

```bash
sudo docker run -d -p 3000:3000 my-custom-app
```
![](./images/task-2/Screenshot%20from%202026-02-26%2006-25-37.png)

![](./images/task-2/Screenshot%20from%202026-02-26%2005-54-27.png)

![](./images/task-2/Screenshot%20from%202026-02-26%2005-54-45.png)

![](./images/task-2/Screenshot%20from%202026-02-26%2005-56-04.png)

![](./images/task-2/Screenshot%20from%202026-02-26%2005-56-25.png)

![](./images/task-2/Screenshot%20from%202026-02-26%2006-26-23.png)

---

### Task 3: CMD vs ENTRYPOINT
1. Create an image with `CMD ["echo", "hello"]` — run it, then run it with a custom command. What happens?
    ```bash
    vim Dockerfile_cmd

    FROM alpine

    CMD ["echo", "hello"]
    ```
    ![](./images/task-3/Screenshot%20from%202026-02-26%2007-09-48.png)

    ```bash
    sudo docker build -t my-cmd-image -f Dockerfile_cmd .
    ```
    ![](./images/task-3/Screenshot%20from%202026-02-26%2007-13-08.png)

    - **Run normally:**
    ```bash
    sudo docker run my-cmd-image
    ```

    - 	→ Output: `hello` 
(because CMD defines the default command)

    ![](./images/task-3/Screenshot%20from%202026-02-26%2007-24-09.png)

    - **Run with a custom command:**
    ```bash
    sudo docker run my-cmd-image echo "bye"
    ```
    - 	→ Output: `bye`
(because when we provide a command at runtime, **it overrides CMD**)

    ![](./images/task-3/Screenshot%20from%202026-02-26%2007-28-58.png)

2. Create an image with `ENTRYPOINT ["echo"]` — run it, then run it with additional arguments. What happens?
    ```bash
    vim Dockerfile_entrypoint

    FROM alpine

    ENTRYPOINT ["echo"]
    ```
    ![](./images/task-3/Screenshot%20from%202026-02-26%2007-17-45.png)

    ```bash
    sudo docker build -t my-entrypoint-image -f Dockerfile_entrypoint .
    ```

    ![](./images/task-3/Screenshot%20from%202026-02-26%2007-20-57.png)

    ```bash
    sudo docker images
    ```
    ![](./images/task-3/Screenshot%20from%202026-02-26%2007-21-23.png)

    - **Run normally:**
    ```bash
    sudo docker run my-entrypoint-image hello
    ```
    - 	→ Output: `hello`
(because ENTRYPOINT is fixed, and whatever we pass becomes its argument)

    ![](./images/task-3/Screenshot%20from%202026-02-26%2007-33-14.png)
 	
    - **Run with additional arguments:**
    ```bash
    sudo docker run my-entrypoint-image bye world
    ```

    -  	→ Output: `bye world`
(ENTRYPOINT stays as `echo`, and the arguments are appended)

    ![](./images/task-3/Screenshot%20from%202026-02-26%2007-34-20.png)

3. Write in your notes: When would you use CMD vs ENTRYPOINT?


    | Aspect | CMD | ENTRYPOINT |
    |--------|-----|------------|
    | **Definition** | Provides default command/arguments for the container. | Defines the main executable that always runs. |
    | **Override behavior** | Easily overridden by arguments passed at `docker run`. | Not overridden; arguments are appended to ENTRYPOINT. |
    | **Example Dockerfile** | `CMD ["echo", "hello"]` | `ENTRYPOINT ["echo"]` |
    | **Run without extra args** | `docker run my-cmd-image` → prints `hello` | `docker run my-entrypoint-image hello` → prints `hello` |
    | **Run with extra args** | `docker run my-cmd-image echo bye` → prints `bye` (CMD replaced) | `docker run my-entrypoint-image bye world` → prints `bye world` (args appended) |
    | **Best use case** | When we want a default command but allow users to override it easily. | When we want the container to behave like a fixed tool/command, with arguments passed at runtime. |
    | **Analogy** | CMD is like a *default suggestion* that can be swapped out. | ENTRYPOINT is like a *locked command*, and we only supply parameters to it. |

---

### Task 4: Build a Simple Web App Image
1. Create a small static HTML file (`index.html`) with any content
    ```bash
    cat> index.html
    ```
    ```bash
    <!DOCTYPE html>
    <html>
    <body>
        <h1>Hello from Docker!</h1>
        <p>This page is being served by Nginx inside a container.</p>
    </body>
    </html>
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-26%2008-14-02.png)

2. Write a Dockerfile that:
   - Uses `nginx:alpine` as base
   - Copies your `index.html` to the Nginx web directory

    ```bash
    vi Dockerfile
    ```
    ```bash
    # 1. FROM: Start with the official Nginx image
    FROM nginx:alpine

    # 2. WORKDIR: Set the location where Nginx looks for files
    WORKDIR /usr/share/nginx/html

    # 3. COPY: Move your custom HTML file into the container
    # Since we set WORKDIR, "." refers to /usr/share/nginx/html
    COPY . .

    # 4. RUN: Change permissions or modify files during the build
    # Here, we\'ll just create a small text log to prove RUN executed
    RUN touch build_complete.txt

    # 5. EXPOSE: Nginx listens on port 80 by default
    EXPOSE 80

    # 6. CMD: Start Nginx in the foreground so the container stays alive
    CMD ["nginx", "-g", "daemon off;"]
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-26%2008-11-03.png)

3. Build and tag it `my-website:v1`
    ```bash
    sudo docker build -t my-website:v1 .
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-26%2008-17-00.png)

4. Run it with port mapping and access it in your browser
    ```bash
    sudo docker run -d -p 8080:80 my-website:v1
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-26%2008-20-36.png)

    ![](./images/task-4/Screenshot%20from%202026-02-26%2008-22-04.png)

    ![](./images/task-4/Screenshot%20from%202026-02-26%2008-23-03.png)


### Task 5: .dockerignore
1. Create a `.dockerignore` file in one of your project folders
    ```bash
    mkdir docker-ignore-demo && cd docker-ignore-demo
    touch .dockerignore
    ```
    ![](./images/task-5/Screenshot%20from%202026-02-26%2021-16-15.png)

2. Add entries for: `node_modules`, `.git`, `*.md`, `.env`
    ```bash
    mkdir node_modules
    echo "fake dependency file" > node_modules/test.js
    ```
    ```bash
    mkdir .git
    echo "fake git object" > .git/HEAD
    ```
    ```bash
    echo "# Project Notes" > notes.md
    ```
    ```bash
    echo "SECRET_KEY=supersecret" > .env
    ```
    ```bash
    vim package.json
    ```
    ![](./images/task-5/Screenshot%20from%202026-02-26%2021-20-02.png)

    ```bash
    {
    "name": "simple-docker-app",
    "version": "1.0.0",
    "main": "index.js",
    "scripts": {
        "start": "node index.js"
    }
    }
    ```
    ![](./images/task-5/Screenshot%20from%202026-02-26%2021-31-31.png)

    ```bash
    vim .dockerignore
    ```
    ```bash
    node_modules
    .git
    *.md
    .env
    ```
    ![](./images/task-5/Screenshot%20from%202026-02-26%2021-23-30.png)

3. Build the image — verify that ignored files are not included

    ```bash
    vim Dockerfile
    ```
    ```bash
    FROM node:18-alpine

    WORKDIR /app

    # 1. Copy only package files first
    COPY package*.json ./

    # 2. Install dependencies INSIDE the container
    # (This stays fast because of Docker caching)
    RUN npm install

    # 3. Copy the rest of the app 
    # (The .dockerignore ensures the local node_modules are NOT copied here)
    COPY . .

    CMD ["ls", "-al"]
    ```
    ![](./images/task-5/Screenshot%20from%202026-02-26%2021-24-23.png)

    ```bash
    sudo docker build -t ignore-demo .
    ```
   ![](./images/task-5/Screenshot%20from%202026-02-26%2021-38-51.png)


    > The `Warning` is due to the fact that docker couldn't find a `.git` folder to record commit history in the image metadata. But our build was 100% successful and the image is ready to run.


    ```bash
    sudo docker run --rm ignore-demo
    ```
    ![](./images/task-5/Screenshot%20from%202026-02-26%2021-40-25.png)

    > The `--rm` flag is essentially our **digital janitor.** Its sole job is to automatically remove the container as soon as it exits or stops running.

    ---


### Task 6: Build Optimization
1. Build an image, then change one line and rebuild — notice how Docker uses **cache**

    1. Create a simple `Dockerfile`:
    ```bash
    mkdir build-optimization && cd build-optimization/
    ```
    ![](./images/task-6/Screenshot%20from%202026-02-27%2005-46-17.png)

    ```bash
    vi Dockerfile
    ```
    ```bash
    FROM alpine:latest
    RUN echo "Hello World" > /hello.txt
    CMD ["cat", "/hello.txt"]
    ```
    ![](./images/task-6/Screenshot%20from%202026-02-27%2005-48-27.png)

    2. Build it:
    ```bash
    sudo docker build -t myimage:v1 .
    ```
    ![](./images/task-6/Screenshot%20from%202026-02-27%2005-50-13.png)

    Docker will create layers: base image, `RUN` command, and `CMD`.

    3. Now change one line — for example, update the `RUN` command:
    ```bash
    vi Dockerfile
    ```
    ```bash
    FROM alpine:latest
    RUN echo "Hello Docker" > /hello.txt
    CMD ["cat", "/hello.txt"]
    ```
    ![](./images/task-6/Screenshot%20from%202026-02-27%2005-52-49.png)

    4. Rebuild:
    ```bash
    docker build -t myimage:v2 .
    ```
    ![](./images/task-6/Screenshot%20from%202026-02-27%2005-55-43.png)

    Notice how Docker **reuses the cached base layer** (`FROM alpine`) but rebuilds the changed `RUN` step and everything after it.

    - This shows how **cache works:** unchanged layers are reused, changed ones and subsequent layers are rebuilt.


2. Reorder your Dockerfile so that frequently changing lines come **last**

    Imagine this Dockerfile:

    ```bash
    vi app.py
    ```
    ```bash
    print("Hello from Docker!")
    ```
    ![](./images/task-6/Screenshot%20from%202026-02-27%2006-09-53.png)

    ```bash
    vi Dockerfile
    ```
    ```bash
    FROM ubuntu:latest
    RUN apt-get update && apt-get install -y curl
    COPY app.py /app/
    RUN echo "Version 1" > /version.txt
    CMD ["python3", "/app/app.py"]
    ```
    ![](./images/task-6/Screenshot%20from%202026-02-27%2006-05-59.png)

    ```bash
    sudo docker build -t my-python-app:v1 .
    ```
    ![](./images/task-6/Screenshot%20from%202026-02-27%2006-13-07.png)

    - If we frequently change `app.py`, put that later in the file:
  
    ```bash
    vi Dockerfile
    ```
    ```bash
    FROM ubuntu:latest
    RUN apt-get update && apt-get install -y curl
    RUN echo "Version 1" > /version.txt
    COPY app.py /app/
    CMD ["python3", "/app/app.py"]
    ```
    ![](./images/task-6/Screenshot%20from%202026-02-27%2006-15-36.png)

    - Now, when we change `app.py`, Docker only rebuilds the **last COPY layer**, not the earlier heavy `apt-get` layer.

    ```bash
    vi app.py
    ```
    ```bash
    print("Hello from Docker World!")
    ```
    ![](./images/task-6/Screenshot%20from%202026-02-27%2006-16-52.png)

    ```bash
    sudo docker build -t my-python-app:v2 .
    ```
    ![](./images/task-6/Screenshot%20from%202026-02-27%2006-19-19.png)
    
3. Write in your notes: Why does layer order matter for build speed?

    - **Each instruction = a layer.**
    - Docker caches layers and reuses them if nothing changed.
    - If a frequently changing line (like `COPY . /app`) is placed early, it invalidates all subsequent layers → slow builds.
    - If it’s placed last, only that layer rebuilds → fast builds.

    **In short:**
    Layer order matters because it determines how much of the cache Docker can reuse. Smart ordering = faster builds, less wasted time.

    > Tip: Always put stable steps first (like installing dependencies) and volatile steps last (like copying source code). That way, we maximize cache efficiency.



---
