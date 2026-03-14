FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install curl as root (needed for install scripts)
RUN apt-get update && apt-get install -y \
    curl \
    zstd \
    && rm -rf /var/lib/apt/lists/*

# Stay as root for system package installations (Ollama)
USER root

# Install Ollama as root
RUN curl -fsSL https://ollama.com/install.sh | sh

# Add HEALTHCHECK for container readiness verification
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=2 \
  CMD curl -f http://localhost:11434/api/tags || exit 1

# Switch to vscode user and install Claude Code here
USER vscode

# Install Claude Code for vscode user only
RUN curl -fsSL https://claude.ai/install.sh | bash
