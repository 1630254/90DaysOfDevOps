import ollama

# Initialize the client pointing to your remote server
# By default, Ollama listens on port 11434
client = ollama.Client(host="http://192.168.0.104:11434")

SYSTEM_PROMPT = """You are a Docker expert. When given a Docker error, explain:
1. What went wrong (plain English)
2. Most likely cause
3. How to fix it (with commands)
Keep it short."""

# ... reads user input (simulated here) ...
error = "Error response from daemon: pull access denied for mycompany/private-app, repository does not exist or may require \'docker login\'."

# Use client.chat instead of ollama.chat
response = client.chat(
    model="gemma4",
    messages=[
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": error},
    ],
    options={"temperature": 0.3},
)

print(response["message"]["content"])

