# Docker Revision & Cheat Sheet

## Self-Assessment Checklist
Mark yourself honestly — **can do**, **shaky**, or **haven't done**:

-  ✅ Run a container from Docker Hub (interactive + detached)
-  ✅ List, stop, remove containers and images
-  ⚠️ Explain image layers and how caching works
-  ✅ Write a Dockerfile from scratch with FROM, RUN, COPY, WORKDIR, CMD
-  ✅ Explain CMD vs ENTRYPOINT
-  ✅ Build and tag a custom image
-  ⚠️ Create and use named volumes
-  ⚠️ Use bind mounts
-  ✅ Create custom networks and connect containers
-  ✅ Write a docker-compose.yml for a multi-container app
-  ✅ Use environment variables and .env files in Compose
-  ⚠️ Write a multi-stage Dockerfile
-  ✅ Push an image to Docker Hub
-  ✅ Use healthchecks and depends_on

---

## Quick-Fire Questions
Answer from memory, then verify:

1.**What is the difference between an image and a container?**  
   - An **image** is a blueprint (like a recipe).  
   - A **container** is the running instance of that image.  
   *Example: `nginx` image → running `nginx` container.*

2.**What happens to data inside a container when we remove it?**  
   - Data stored inside the container is **lost** when removed.  
   - We use **volumes** if we want data to persist.

3.**How do two containers on the same custom network communicate?**  
   - They can talk using each other’s **container name** as hostname.  
   *Example: `ping my-app` inside another container.*

4.**What does `docker compose down -v` do differently from `docker compose down`?**  
   - `down` removes containers, networks, images.  
   - `down -v` also deletes **volumes** (data wiped).

5.**Why are multi-stage builds useful?**  
   - They let us build in steps, keeping only what’s needed.  
   - Result: **smaller, cleaner images**.

6.**What is the difference between `COPY` and `ADD`?**  
   - `COPY` just copies files.  
   - `ADD` can also fetch URLs or extract tar files.  
   *Best practice: we use `COPY` unless we need `ADD` features.*

7.**What does `-p 8080:80` mean?**  
   - Maps **host port 8080** → **container port 80**.  
   *We access via `http://localhost:8080`.*

8.**How do we check how much disk space Docker is using?**  
   - Run: `docker system df`  
   - Shows space used by images, containers, volumes.

---
## Build Your Docker Cheat Sheet
Create `docker-cheatsheet.md` organized by category:
- **Container commands** — run, ps, stop, rm, exec, logs
- **Image commands** — build, pull, push, tag, ls, rm
- **Volume commands** — create, ls, inspect, rm
- **Network commands** — create, ls, inspect, connect
- **Compose commands** — up, down, ps, logs, build
- **Cleanup commands** — prune, system df
- **Dockerfile instructions** — FROM, RUN, COPY, WORKDIR, EXPOSE, CMD, ENTRYPOINT

Keep it short — one line per command, something you'd actually reference on the job.

⇒ **The cheat sheet has been created as a separate document, `docker-cheatsheet.md`, and added to the repository.**

---
## Revisit Weak Spots
Pick **2 topics** you marked as shaky and redo the hands-on tasks from that day.

⇒ **We will revisit the identified gaps and implement the necessary actions promptly.**

---