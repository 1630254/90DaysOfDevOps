# Linux File Manipulation Practice

**Goal:** Master basic file creation, redirection, and reading commands
## 1. File Initialization

Start by creating an empty file to our workspace.
- `touch notes.txt`

## 2. Writing and Appending (Redirection)
Use > to overwrite/create and >> to append without deleting existing content.

- `echo "Learning Linux is about consistency." > notes.txt`
- `echo "Redirection makes automation easy." >> notes.txt`
- `echo "Always double-check your file paths." >> notes.txt`

## 3. Using the tee Command
The tee command is like a "T-junction" for data: it sends output to a file and displays it in terminal simultaneously.
- `echo "This line is written and displayed using tee." | tee -a notes.txt`

## 4. Reading the File
Practice different ways to view our data depending on how much of the file we need to see.

| Command | Purpose |
| :--- | :--- |
| `cat notes.txt` | Displays the entire content of the file. |
| `head -n 2 notes.txt` | Displays only the first 2 lines. |
| `tail -n 2 notes.txt` | Displays only the last 2 lines. |
---

## Summary of Command Flow

- `touch notes.txt`
- `echo "Line 1: Entry" > notes.txt`
- `echo "Line 2: Middle" >> notes.txt`
- `echo "Line 3: End" | tee -a notes.txt`
- `cat notes.txt`
- `head -n 2 notes.txt`
- `tail -n 2 notes.txt`

---