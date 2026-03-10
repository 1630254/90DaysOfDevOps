# 📓 Technical Notes: The "What" and the "Where"

## 🔹 What is being cached?
- We are caching the **binaries and source files** of the libraries we downloaded.
- In **Python**, this is usually `~/.cache/pip`.
- In **Node.js**, we would cache `node_modules` or the global npm cache.
- In **Maven/Java**, we would cache `~/.m2/repository`.

## 🔹 Where is it stored?
- The data is stored in **GitHub's dedicated cloud storage** assigned to our repository.
- It is **not stored** on our repository's main branch.
- It is **not stored** on the runner permanently (the runner is wiped after every job).
- Instead:
  - At the start of the job, the Runner **downloads the cache** from GitHub's storage.
  - At the end of the job, it **uploads any updates** back to that storage.

---

# ⚠️ Key Constraints for our Notes

- **Size Limit**: GitHub provides a total of **10GB of cache storage per repository**.
- **Eviction**: If we exceed 10GB, GitHub will **delete the oldest caches** to make room for new ones.
- **Scope**: Caches are **isolated by branch**.  
  - A cache created on a *Feature Branch* is accessible by that branch and the base branch (like `main`).  
  - It is **not accessible** by other unrelated feature branches.

---