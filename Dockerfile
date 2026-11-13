FROM python:3.13-slim

# Copy uv binary directly from Astral
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Copy project files
COPY . .

# Install dependencies with mcp<2 constraint
RUN uv pip install --system --no-cache "mcp<2" .

# Set paths and ports
ENV PYTHONPATH="/app:/app/src"
ENV PORT=8080
EXPOSE 8080

# Lock the executable in ENTRYPOINT and defaults in CMD
ENTRYPOINT ["mcp-server-box"]
CMD ["--transport", "http", "--host", "0.0.0.0", "--port", "8080", "--mcp-auth-type", "none", "--box-auth-type", "ccg"]