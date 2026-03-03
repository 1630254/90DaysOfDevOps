# Docker Project: Dockerize a Full Application

### Task 1: Pick Your App
Choose **one** of these (or use your own project):
- A **Python Flask/Django** app with a database
- A **Node.js Express** app with MongoDB
- A **static website** served by Nginx with a backend API
- Any app from your GitHub that doesn't have Docker yet

If you don't have an app, clone a simple open-source one and Dockerize it.


The selected application `app.py` is a Production-Ready Digital Telephone Book web application that securely manages contact information.  
It supports full **CRUD operations**—create, read/search, update, and delete—along with advanced filtering by name or phone number.  
Data is persisted in a dedicated **PostgreSQL 15** database.  
Built with **Python (Flask)** and **SQLAlchemy** on the backend, and **Bootstrap 5** on the frontend, it delivers a responsive, user-friendly interface.  
This modern SRE-approved stack makes the app reliable, scalable, and production-ready.  

---

### Task 2: Write the Dockerfile
1. Create a Dockerfile for your application
2. Use a **multi-stage build** if applicable
3. Use a **non-root user**
4. Keep the image **small** — use alpine or slim base images
5. Add a `.dockerignore` file

Build and test it locally.

```bash
vi .dockerignore
```
```bash
# Local environments
.venv/
venv/
env/
__pycache__/
*.pyc

# Local databases & secrets
*.db
*.sqlite3
.env

# Git & Docker
.git
.gitignore
Dockerfile
docker-compose.yml
.dockerignore

# OS specific files
.DS_Store
```
![](./images/task-2/1.png)

```bash
sudo docker build -t my-flask-app .
sudo docker images | grep -i my-flask-app
```
![](./images/task-2/2.png)

```bash
sudo docker network create my_net
sudo docker network ls
```
![](./images/task-2/3.png)

```bash
sudo docker run -d  --name db-container --network my_net -e POSTGRES_USER=admin  -e POSTGRES_PASSWORD=password123 -e POSTGRES_DB=user_db  postgres:15-alpine
sudo docker run -d --name web-app --network my_net -p 5000:5000 -e DATABASE_URL=postgresql://admin:password123@db-container:5432/user_db  my-flask-app

sudo docker ps
```
![](./images/task-2/4.png)

![](./images/task-2/5.png)

---

### Task 3: Add Docker Compose
Write a `docker-compose.yml` that includes:
1. Your **app** service (built from Dockerfile)
2. A **database** service (Postgres, MySQL, MongoDB — whatever your app needs)
3. **Volumes** for database persistence
4. A **custom network**
5. **Environment variables** for configuration (use `.env` file)
6. **Healthchecks** on the database

Run `docker compose up` and verify everything works together.

```bash
vi .env
```
```env
DB_USER=admin
DB_PASSWORD=password123
DB_NAME=user_db
DATABASE_URL=postgresql://admin:password123@db:5432/user_db
```
![](./images/task-3/1.png)

```bash
sudo docker compose up -d
```
![](./images/task-3/2.png)

```bash
sudo docker ps

sudo docker volume ls

sudo docker network ls

sudo docker images
```
![](./images/task-3/3.png)

![](./images/task-3/4.png)

```bash
sudo docker compose down
```
![](./images/task-3/5.png)

---

### Task 4: Ship It
1. Tag your app image
```bash
sudo docker tag my-flask-app manasbhowmick/telephone-book:latest
```
![](./images/task-4/1.png)

2. Push it to Docker Hub
```bash
sudo docker push manasbhowmick/telephone-book
```
![](./images/task-4/2.png)

3. Share the Docker Hub 

![](./images/task-4/3.png)

```bash
https://hub.docker.com/repository/docker/manasbhowmick/telephone-book/general
```
4. Write a `README.md` in your project with:
   - What the app does
   - How to run it with Docker Compose
   - Any environment variables needed

---

### Task 5: Test the Whole Flow
1. Remove all local images and containers

```bash
sudo docker image ls
sudo docker volume ls
```

![](./images/task-5/1.png)

![](./images/task-5/2.png)

2. Pull from Docker Hub and run using only your compose file

```bash
vi docker-compose.yml
```
```yaml
services:
  web:
    image: manasbhowmick/telephone-book:latest
    container_name: telephone_app
    ports:
      - "5000:5000"
    env_file:
      - .env
    depends_on:
      db:
        condition: service_healthy
    networks:
      - my_net
    restart: always
  db:
    image: postgres:15-alpine
    container_name: postgres_db
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]
      interval: 5s
      timeout: 5s
      retries: 5
    networks:
      - my_net
    restart: always

networks:
  my_net:

volumes:
  pgdata:
```
![](./images/task-5/3.png)

```bash
sudo docker compose up -d 
```
![](./images/task-5/4.png)

3. Does it work fresh? If not — fix it until it does

![](./images/task-5/5.png)
```bash
sudo docker images
```
![](./images/task-5/6.png)

```bash
sudo docker compose down
```
![](./images/task-5/7.png)
```bash
sudo docker volume ls
```
![](./images/task-5/8.png)

---
