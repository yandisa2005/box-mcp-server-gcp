FROM python:3.13-slim

# Install uv binary directly
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# 1. Copy everything first so package definitions, source files, and README are present
COPY . .

# 2. Install the package and all dependencies into system site-packages
RUN uv pip install --system --no-cache .

# 3. Ensure Python searches both /app and /app/src for modules
ENV PYTHONPATH="/app:/app/src"
ENV PORT=8080
EXPOSE 8080

# 4. Run the CLI entrypoint
CMD ["mcp-server-box", "--transport", "sse", "--host", "0.0.0.0", "--port", "8080"]