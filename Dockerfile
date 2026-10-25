FROM python:3.13-slim

# Copy uv binary directly from Astral image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Copy dependency manifests
COPY pyproject.toml uv.lock* README.md ./

# Install project dependencies
RUN uv pip install --system --no-cache .

# Copy remaining application code
COPY . .

ENV PORT=8080
EXPOSE 8080

CMD ["python", "-m", "box_mcp_server"]