# The One-Line Docker Cheat Sheet

## 1. Container Commands (Running Processes)
| Action | Command | Example |
|--------|---------|---------|
| Run a new container (detached + named + ports) | `docker run -d --name <name> -p <host_port>:<container_port> <image>` | `docker run -d --name my-app -p 8080:80 nginx` |
| List running containers | `docker ps` | `docker ps` |
| List ALL containers (running + stopped) | `docker ps -a` | `docker ps -a` |
| Stop a container | `docker stop <name>` | `docker stop my-app` |
| Remove a stopped container | `docker rm <name>` | `docker rm my-app` |
| Run a command inside a running container | `docker exec -it <name> <command>` | `docker exec -it my-app bash` |
| View container logs (tail + follow) | `docker logs -f <name>` | `docker logs -f my-app` |

## 2. Image Commands (Artifacts)
| Action | Command | Example |
|--------|---------|---------|
| Build an image | `docker build -t <repo>/<image>:<tag> <path>` | `docker build -t manasbhowmick/my-app:1.0 .` |
| Pull an image | `docker pull <image>:<tag>` | `docker pull postgres:15-alpine` |
| Push an image | `docker push <repo>/<image>:<tag>` | `docker push manasbhowmick/my-app:1.0` |
| Tag an image | `docker tag <source>:<tag> <repo>/<image>:<new_tag>` | `docker tag my-app:latest manasbhowmick/my-app:v2` |
| List local images | `docker images` | `docker images` |
| Remove a local image | `docker rmi <repo>/<image>:<tag>` | `docker rmi manasbhowmick/my-app:1.0` |

## 3. Volume Commands (Persistent Data)
| Action | Command | Example |
|--------|---------|---------|
| Create a named volume | `docker volume create <name>` | `docker volume create pgdata` |
| List all volumes | `docker volume ls` | `docker volume ls` |
| Inspect a volume | `docker volume inspect <name>` | `docker volume inspect pgdata` |
| Remove an unused volume | `docker volume rm <name>` | `docker volume rm pgdata` |

## 4. Network Commands (Isolation)
| Action | Command | Example |
|--------|---------|---------|
| Create a bridge network | `docker network create <name>` | `docker network create my_net` |
| List all networks | `docker network ls` | `docker network ls` |
| Inspect a network | `docker network inspect <name>` | `docker network inspect my_net` |
| Connect container to a network | `docker network connect <network> <container>` | `docker network connect my_net existing-container` |

## 5. Compose Commands (Orchestration)
| Action | Command | Example |
|--------|---------|---------|
| Start the stack | `docker compose up -d --build` | `docker compose up -d --build` |
| Stop and remove the stack | `docker compose down` | `docker compose down` |
| Stop, remove stack, AND wipe volumes | `docker compose down -v` | `docker compose down -v` |
| List status of services | `docker compose ps` | `docker compose ps` |
| View logs of all services | `docker compose logs -f` | `docker compose logs -f` |

## 6. Cleanup Commands (Disk Space)
| Action | Command | Example |
|--------|---------|---------|
| Check Docker disk usage | `docker system df` | `docker system df` |
| Remove stopped containers, unused networks, dangling images | `docker system prune` | `docker system prune` |
| Aggressive cleanup | `docker system prune -a --volumes` | `docker system prune -a --volumes` |

## 7. Dockerfile Instructions (The Blueprint)
| Instruction | Command | Example |
|-------------|---------|---------|
| Base image | `FROM <image>:<tag>` | `FROM python:3.12-slim` |
| Working directory | `WORKDIR <path>` | `WORKDIR /app` |
| Copy files | `COPY <src> <dest>` | `COPY requirements.txt .` |
| Run command | `RUN <command>` | `RUN pip install -r requirements.txt` |
| Expose port | `EXPOSE <port>` | `EXPOSE 5000` |
| Set user | `USER <uid>` | `USER 1000` |
| Default command | `CMD ["executable", "param"]` | `CMD ["python", "app.py"]` |
| Entrypoint | `ENTRYPOINT ["executable"]` | `ENTRYPOINT ["/entrypoint.sh"]` |

---