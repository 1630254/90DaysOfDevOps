# Docker Volumes & Networking

### Task 1: The Problem
1. Run a Postgres or MySQL container
    ```bash
    sudo docker run --name my-mysql -e MYSQL_ROOT_PASSWORD=secret -d mysql:latest
    
    sudo docker ps
    ```
    ![](./images/task-1/Screenshot%20from%202026-02-27%2007-28-48.png)

    ![](./images/task-1/Screenshot%20from%202026-02-27%2007-29-43.png)

2. Create some data inside it (a table, a few rows — anything)
    ```bash
    sudo docker exec -it my-mysql bash

    mysql -u root -p
    ```
    ```sql
    CREATE DATABASE testdb;
    USE testdb;
    CREATE TABLE users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));
    INSERT INTO users (name) VALUES ('Alice'), ('Bob');
    SELECT * FROM users;
    ```
    ![](./images/task-1/Screenshot%20from%202026-02-27%2007-32-22.png)

3. Stop and remove the container
    ```bash
    sudo docker stop my-mysql
    
    sudo docker rm my-mysql
    ```
    ![](./images/task-1/Screenshot%20from%202026-02-27%2007-33-30.png)

4. Run a new one — is your data still there?

    ```bash
    sudo docker run --name my-mysql -e MYSQL_ROOT_PASSWORD=secret -d mysql:latest
    ```
    ![](./images/task-1/Screenshot%20from%202026-02-27%2007-34-51.png)

    ```bash
    docker exec -it my-mysql bash

    mysql -u root -p
    ```
    ```sql
    SHOW DATABASES;
    ```
    ![](./images/task-1/Screenshot%20from%202026-02-27%2007-37-01.png)

Write what happened and why.

- 	Containers are **ephemeral** by default.
- 	MySQL stores its data inside `/avr/lib/mysql` in the container’s filesystem.
- 	When you removed the container, that filesystem was deleted.
- 	Running a new container starts fresh with a clean MySQL installation.

---

### Task 2: Named Volumes
1. Create a named volume
    ```bash
    sudo docker volume create mysqldata
    ```
    ```bash
    sudo docker volume ls
    ```
    ![](./images/task-2/Screenshot%20from%202026-02-27%2008-03-50.png)

2. Run the same database container, but this time **attach the volume** to it
    ```bash
    sudo docker run --name my-mysql -e MYSQL_ROOT_PASSWORD=secret -v mysqldata:/var/lib/mysql -d mysql:latest

    sudo docker ps
    ```
    ![](./images/task-2/Screenshot%20from%202026-02-27%2008-04-56.png)

3. Add some data, stop and remove the container
    ```bash
    sudo docker exec -it my-mysql2 bash

    mysql -u root -p
    ```
    ```sql
    CREATE DATABASE testdb;
    USE testdb;
    CREATE TABLE users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));
    INSERT INTO users (name) VALUES ('Alice'), ('Bob');
    SELECT * FROM users;
    SHOW DATABASES;
    ```
    ![](./images/task-2/Screenshot%20from%202026-02-27%2008-06-47.png)

    ```bash
    sudo docker stop my-mysql
    
    sudo docker rm my-mysql

    sudo docker ps -a
    ```
    ![](./images/task-2/Screenshot%20from%202026-02-27%2008-08-21.png)

    ```bash
    sudo docker volume ls
    ```
    ![](./images/task-2/Screenshot%20from%202026-02-27%2008-08-47.png)

4. Run a brand new container with the **same volume**
    ```bash
    sudo docker run --name my-mysql2 -e MYSQL_ROOT_PASSWORD=secret -v mysqldata:/var/lib/mysql -d mysql:latest
    ```
    ![](./images/task-2/Screenshot%20from%202026-02-27%2008-09-51.png)

5. Is the data still there?
    ```bash
    sudo docker exec -it my-mysql bash

    mysql -u root -p
    ```
    ```mysql
    SHOW DATABASES;
    USE testdb;
    SELECT * FROM users;
    ```
    ![](./images/task-2/Screenshot%20from%202026-02-27%2008-12-29.png)

    ```bash
    sudo docker volume inspect mysqldata
    ```
    ![](./images/task-2/Screenshot%20from%202026-02-27%2008-13-01.png)

    We’ll see metadata like:
    -   `Name: mysqldata`
    -   `Mountpoint: /var/lib/docker/volumes/mysqldata/_data `  
    - 	Driver info, etc.

**Verify:** `docker volume ls`, `docker volume inspect`

---

### Task 3: Bind Mounts
1. Create a folder on your host machine with an `index.html` file
    ```bash
    mkdir ~/my-nginx-site

    cd ~/my-nginx-site
    ```
    ![](./images/task-3/Screenshot%20from%202026-02-27%2008-30-47.png)

    ```bash
    vim index.html
    ```
    ```html
    <h1>Hello from Docker Bind Mount!</h1>
    ```
    ![](./images/task-3/Screenshot%20from%202026-02-27%2008-35-06.png)

2. Run an Nginx container and **bind mount** your folder to the Nginx web directory
    ```bash
    sudo docker run --name my-nginx -p 8080:80 -v ~/my-nginx-site:/usr/share/nginx/html -d nginx
    ```
    ![](./images/task-3/Screenshot%20from%202026-02-27%2008-37-22.png)
3. Access the page in your browser
   
    ![](./images/task-3/Screenshot%20from%202026-02-27%2008-38-50.png)

    ![](./images/task-3/Screenshot%20from%202026-02-27%2008-39-46.png)

4. Edit the `index.html` on your host — refresh the browser
     ```bash
    vi index.html
    ```
    ```html
    <h1>Updated content — live reload!</h1>
    ```
    ![](./images/task-3/Screenshot%20from%202026-02-27%2008-40-58.png)

    ![](./images/task-3/Screenshot%20from%202026-02-27%2008-42-56.png)

Write in your notes: What is the difference between a named volume and a bind mount?

| Feature        | Named Volume | Bind Mount |
|----------------|--------------|------------|
| **Location**   | Managed by Docker (`/var/lib/docker/volumes/...`) | Any folder on your host machine |
| **Use Case**   | Best for persistent app data (databases, configs) | Best for development (live editing, sharing files) |
| **Portability**| Docker controls lifecycle, easy to move between hosts | Depends on host path, less portable |
| **Visibility** | Hidden inside Docker’s storage | Directly visible/editable on host |
| **Flexibility**| Docker decides where to store | You decide exact path |
---

### Task 4: Docker Networking Basics
1. List all Docker networks on your machine
    ```bash
    sudo docker network ls
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-27%2018-23-30.png)

2. Inspect the default `bridge` network
    ```bash
    sudo docker network inspect bridge
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-27%2018-30-11.png)

3. Run two containers on the default bridge — can they ping each other by **name**?
    ```bash
    sudo docker run -dit  --name cont1 busybox sh

    sudo docker run -dit  --name cont2 busybox sh

    sudo docker ps
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-27%2018-40-46.png)
    ```bash
    sudo docker exec cont1 ping -c 4 cont2
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-27%2018-42-52.png)

4. Run two containers on the default bridge — can they ping each other by **IP**?
    ```bash
    sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cont2
    ```
    ```bash
    sudo docker exec cont1 ping -c 4 172.17.0.3
    ```
    ![](./images/task-4/Screenshot%20from%202026-02-27%2019-15-38.png)

---

### Task 5: Custom Networks
1. Create a custom bridge network called `my-app-net`
    ```bash
    sudo docker network create my-app-net

    sudo docker network ls
    ```
    ![](./images/task-5/Screenshot%20from%202026-02-27%2019-51-02.png)

2. Run two containers on `my-app-net`
    ```bash
    sudo docker run -dit --name cont3 --network my-app-net busybox sh

    sudo docker run -dit --name cont4 --network my-app-net busybox sh

    sudo docker ps
    ```
    ![](./images/task-5/Screenshot%20from%202026-02-27%2019-54-02.png)

3. Can they ping each other by **name** now?
    ```bash
    sudo docker exec cont3 ping -c 4 cont4
    ```
    ![](./images/task-5/Screenshot%20from%202026-02-27%2020-00-40.png)

4. Write in your notes: Why does custom networking allow name-based communication but the default bridge doesn't?
    - 	Default bridge network: provides only basic connectivity. It doesn’t enable automatic DNS resolution of container names.
    - 	Custom bridge networks: Docker sets up an embedded DNS server. Every container attached to the network registers its name, so other containers can resolve it.
    - 	This makes service discovery easy in multi-container apps (e.g.,  can talk to  by name).

---

### Task 6: Put It Together
1. Create a custom network
```bash
sudo docker network create my-app-net2
```
```bash
sudo docker network ls
```
![](./images/task-6/Screenshot%20from%202026-02-27%2020-35-24.png)

2. Run a **database container** (MySQL/Postgres) on that network with a volume for data
```bash
sudo docker run --name my-db --network my-app-net2 -e MYSQL_ROOT_PASSWORD=secret -d mysql:latest
```
![](./images/task-6/Screenshot%20from%202026-02-27%2020-36-24.png)

3. Run an **app container** (use any image) on the same network
```bash
sudo docker run -dit --name my-app --network my-app-net2  busybox sh
```
![](./images/task-6/Screenshot%20from%202026-02-27%2020-36-54.png)

4. Verify the app container can reach the database by container name
```bash
sudo docker exec -it my-app sh
```
```bash
ping -c 4 my-db
```
![](./images/task-6/Screenshot%20from%202026-02-27%2020-45-36.png)

---
