# Stage 1: Builder
FROM python:3.11-slim AS builder

WORKDIR /app

# Install system dependencies required for building certain Python packages
RUN apt-get update && apt-get install -y build-essential gcc

# Install dependencies into a temporary location
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# Stage 2: Runner
FROM python:3.11-slim AS runner

WORKDIR /app

# Copy only the installed packages from the builder stage
COPY --from=builder /install /usr/local

# Copy the application source code
COPY . .

# Run as a non-privileged user for security
RUN useradd -m appuser
USER appuser

CMD ["python", "app.py"]
