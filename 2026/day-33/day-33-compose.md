# Docker Compose: Multi-Container Basics

### Task 1: Install & Verify
1. Check if Docker Compose is available on your machine
2. Verify the version

    ```bash
    docker compose version
    ```
    ![](./images/task-1/Screenshot%20from%202026-02-28%2012-35-47.png)

    ---

### Task 2: Your First Compose File
1. Create a folder `compose-basics`
    ```bash
    mkdir compose-basics
    ```
    ![](./images/task-2/Screenshot%20from%202026-02-28%2012-50-15.png)

2. Write a `docker-compose.yml` that runs a single **Nginx** container with port mapping
    ```bash
    vi docker-compose.yml
    ```
    ```bash
    version: "3.9"

    services:
        nginx:
            image: nginx:latest
            container_name: my-nginx-server
            ports:
                - "8080:80"

    ```
    ![](./images/task-2/Screenshot%20from%202026-02-28%2012-56-12.png)

    ```bash
    sudo docker compose config
    ```
    ![](./images/task-2/Screenshot%20from%202026-02-28%2012-57-24.png)

    ![](./images/task-2/Screenshot%20from%202026-02-28%2012-57-54.png)

    ![](./images/task-2/Screenshot%20from%202026-02-28%2012-58-29.png)

3. Start it with `docker compose up`
    ```bash
    sudo docker compose up
    ```
    ![](./images/task-2/Screenshot%20from%202026-02-28%2013-01-53.png)

4. Access it in your browser

    ![](./images/task-2/Screenshot%20from%202026-02-28%2013-18-48.png)

    5. Stop it with `docker compose down`
    ```bash
    sudo docker compose down
    ```
    ![](./images/task-2/Screenshot%20from%202026-02-28%2013-02-56.png)

---

### Task 3: Two-Container Setup
Write a `docker-compose.yml` that runs:
- A **WordPress** container
- A **MySQL** container

They should:
- Be on the same network (Compose does this automatically)
- MySQL should have a named volume for data persistence
- WordPress should connect to MySQL using the service name

Start it, access WordPress in your browser, and set it up.

**Verify:** Stop and restart with `docker compose down` and `docker compose up` — is your WordPress data still there?

```bash
vi docker-compose.yml
```
```bash
services:
  db:
    image: mysql:8.0
    container_name: wordpress-database
    restart: always
    ports:
      - "3306:3306"
    environment:
      - MYSQL_DATABASE=exampledb
      - MYSQL_USER=exampleuser
      - MYSQL_PASSWORD=examplepass
      - MYSQL_ROOT_PASSWORD=secret
    volumes:
      - mysql_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-psecret"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s

  wordpress:
    image: wordpress:latest
    container_name: wordpress-container_name
    restart: always
    ports:
      - 8080:80
    environment:
      - WORDPRESS_DB_HOST=db
      - WORDPRESS_DB_USER=exampleuser
      - WORDPRESS_DB_PASSWORD=examplepass
      - WORDPRESS_DB_NAME=exampledb
    depends_on:
      db:
        condition: service_healthy

volumes:
  mysql_data:
```
![](./images/task-3/Screenshot%20from%202026-02-28%2014-05-49.png)
```bash
docker compose config | less
```
![](./images/task-3/Screenshot%20from%202026-02-28%2014-10-04.png)

![](./images/task-3/Screenshot%20from%202026-02-28%2014-33-01.png)

```bash
sudo docker compose up
```
![](./images/task-3/Screenshot%20from%202026-02-28%2014-20-58.png)

![](./images/task-3/Screenshot%20from%202026-02-28%2015-42-40.png)

![](./images/task-3/Screenshot%20from%202026-02-28%2015-42-59.png)

![](./images/task-3/Screenshot%20from%202026-02-28%2015-44-17.png)

![](./images/task-3/Screenshot%20from%202026-02-28%2015-44-30.png)

![](./images/task-3/Screenshot%20from%202026-02-28%2015-44-42.png)

![](./images/task-3/Screenshot%20from%202026-02-28%2015-45-32.png)



```bash
sudo docker compose down
```
![](./images/task-3/Screenshot%20from%202026-02-28%2014-23-16.png)

---

### Task 4: Compose Commands
Practice and document these:
1. Start services in **detached mode**
    ```bash
    sudo docker compose up -d
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2015-13-16.png)

2. View running services
    ```bash
    sudo docker compose ps
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2015-22-56.png)

3. View **logs** of all services
    ```bash
    sudo docker compose logs
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2015-23-32.png)

4. View logs of a **specific** service
    ```bash
    sudo docker compose logs db
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2015-24-10.png)

5. **Stop** services without removing
    ```bash
    sudo docker compose stop
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2015-24-54.png)

    ![](./images/task-4/Screenshot%20from%202026-02-28%2015-25-37.png)

6. **Remove** everything (containers, networks)
    ```bash
    sudo docker compose down
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2015-29-25.png)

    ![](./images/task-4/Screenshot%20from%202026-02-28%2015-28-48.png)

- Add `-v` to also remove named volumes:

7. **Rebuild** images if you make a change

    Suppose we have a simple Node.js app with this structure:
    
    ```
    image_rebuild
    ├── app.js
    ├── docker-compose.yml
    ├── Dockerfile
    └── package.json
    ```

    ```bash
    mkdir image_rebuild
    cd image_rebuild
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2016-30-09.png)

    **app file**

    ```bash
    vi app.js
    ```
    ```js
    // app.js
    const http = require('http');

    const hostname = '0.0.0.0';  // listen on all network interfaces
    const port = 3000;

    const server = http.createServer((req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello, Docker Compose!\n');
    });

    server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
    });

    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2016-30-59.png)

    **package.json**

    ```bash
    vi package.json
    ```
    ```json
    {
    "name": "compose-app",
    "version": "1.0.0",
    "description": "Simple Node.js app for Docker Compose demo",
    "main": "app.js",
    "scripts": {
        "start": "node app.js"
    },
    "author": "Manas Bhowmick",
    "license": "MIT",
    "dependencies": {}
    }
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2016-34-24.png)

    **Dockerfile**

    ```bash
    vi Dockerfile
    ```
    ```bash
    FROM node:18-alpine
    WORKDIR /usr/src/app
    COPY package*.json ./
    RUN npm install
    COPY . .
    CMD ["node", "app.js"]
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2016-31-54.png)

    **docker-compose.yml**

    ```bash
    vi docker-compose.yml
    ```
    ```bash
    services:
        nodeapp:
            build: .
            ports:
            - "3000:3000"
            restart: always
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2016-36-08.png)

    **Step 1: Start the app**

    ```bash
    sudo docker compose up -d
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2016-37-32.png)

    App runs on `http://localhost:3000`

    ![](./images/task-4/Screenshot%20from%202026-02-28%2016-38-37.png)

    **Step 2: Make a change**

    Edit `app.js:`

    ```js
    res.end('Hello, Docker Compose!\n');
    ```
    → Change it to:
    ```js
    res.end('Hello, Docker Compose with rebuild!\n');
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2016-40-08.png)

    **Step 3: Rebuild the image**

    ```bash
    sudo docker compose up --build -d
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-28%2016-44-48.png)

    - `--build` forces Docker to rebuild the image using the updated Dockerfile and source code.
    - `-d` keeps it running in detached mode.

    ![](./images/task-4/Screenshot%20from%202026-02-28%2016-46-28.png)

    **Step 4: Verify**

    ```bash
    sudo docker compose logs nodeapp
    ```
    We should see the updated output

    ![](./images/task-4/Screenshot%20from%202026-02-28%2016-46-49.png)

---

### Task 5: Environment Variables
1. Add environment variables directly in your `docker-compose.yml`
    ```bash
    services:
        db:
            image: mysql:8.0
            container_name: wordpress-database
            restart: always
            ports:
                - "3306:3306"
            environment:
                MYSQL_DATABASE: exampledb
                MYSQL_USER: exampleuser
                MYSQL_PASSWORD: examplepass
                MYSQL_ROOT_PASSWORD: secret
            volumes:
                - mysql_data:/var/lib/mysql
            healthcheck:
                test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-psecret"]
                interval: 10s
                timeout: 5s
                retries: 5
                start_period: 30s

        wordpress:
            image: wordpress:latest
            container_name: wordpress-container
            restart: always
            ports:
                - "8080:80"
            environment:
                WORDPRESS_DB_HOST: db
                WORDPRESS_DB_USER: exampleuser
                WORDPRESS_DB_PASSWORD: examplepass
                WORDPRESS_DB_NAME: exampledb
            depends_on:
                db:
                    condition: service_healthy

    volumes:
        mysql_data:
    ``` 

    ![](./images/task-5/Screenshot%20from%202026-02-28%2017-22-36.png)

2. Create a `.env` file and reference variables from it in your compose file
    ```bash
    vi .env
    ```
    ```bash
    MYSQL_DATABASE=exampledb
    MYSQL_USER=exampleuser
    MYSQL_PASSWORD=examplepass
    MYSQL_ROOT_PASSWORD=secret

    WORDPRESS_DB_HOST=db
    WORDPRESS_DB_USER=exampleuser
    WORDPRESS_DB_PASSWORD=examplepass
    WORDPRESS_DB_NAME=exampledb
    ```
    ![](./images/task-5/Screenshot%20from%202026-02-28%2017-29-11.png)

3. Verify the variables are being picked up

    ```bash
    services:
        db:
            image: mysql:8.0
            container_name: wordpress-database
            restart: always
            ports:
                - "3306:3306"
            environment:
                MYSQL_DATABASE: ${MYSQL_DATABASE}
                MYSQL_USER: ${MYSQL_USER}
                MYSQL_PASSWORD: ${MYSQL_PASSWORD}
                MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
            volumes:
                - mysql_data:/var/lib/mysql
            healthcheck:
                test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${MYSQL_ROOT_PASSWORD}"]
                interval: 10s
                timeout: 5s
                retries: 5
                start_period: 30s

        wordpress:
            image: wordpress:latest
            container_name: wordpress-container
            restart: always
            ports:
                - "8080:80"
            environment:
                WORDPRESS_DB_HOST: ${WORDPRESS_DB_HOST}
                WORDPRESS_DB_USER: ${WORDPRESS_DB_USER}
                WORDPRESS_DB_PASSWORD: ${WORDPRESS_DB_PASSWORD}
                WORDPRESS_DB_NAME: ${WORDPRESS_DB_NAME}
            depends_on:
                db:
                    condition: service_healthy

    volumes:
        mysql_data:
    ```
    ![](./images/task-5/Screenshot%20from%202026-02-28%2017-31-11.png)

    ```bash
    docker compose config | less
    ```
    ![](./images/task-5/Screenshot%20from%202026-02-28%2017-33-35.png)

    ![](./images/task-5/Screenshot%20from%202026-02-28%2017-34-00.png)
---