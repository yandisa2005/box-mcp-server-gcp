FROM python:3.13-slim

# Copy uv binary directly from Astral's official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# 1. Copy project files into the container
COPY . .

# --------------------------------------------------------------------
# 2. PLACE IT HERE:
# Install mcp pinned to <2 alongside our package into system site-packages
# --------------------------------------------------------------------
RUN uv pip install --system --no-cache "mcp<2" .

# 3. Configure Python path and port for Cloud Run
ENV PYTHONPATH="/app:/app/src"
ENV PORT=8080
EXPOSE 8080

# 4. Run the server CLI entrypoint
CMD ["mcp-server-box", "--transport", "sse", "--host", "0.0.0.0", "--port", "8080", "--box-auth-type", "ccg"]