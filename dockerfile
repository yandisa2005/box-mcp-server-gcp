FROM python:3.12-slim

# Prevent Python from writing pyc files & buffering stdout/stderr
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=8080

WORKDIR /app

# Install uv for fast dependency resolution
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Copy project dependency specs
COPY pyproject.toml uv.lock* README.md ./

# Install project dependencies into the system/environment
RUN uv pip install --system .

# Copy application source code
COPY src/ ./src/

# Expose Cloud Run port
EXPOSE 8080

# Launch Uvicorn SSE server listening on all interfaces (0.0.0.0)
CMD ["python", "-m", "uvicorn", "src.mcp_server_box:app", "--host", "0.0.0.0", "--port", "8080"]