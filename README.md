# AI Setup Dev Container

This is a pre-configured development environment that gives AI agents safe access to tools like file reading, web fetching, and bash commands.

---

## 🛠️ Tools Available

| Tool | Purpose |
|------|---------|
| **[Docker](#dev-container-setup)** | Creates isolated containers for safe agent execution |
| **[Dev Containers](#dev-containers)** | VS Code integration - IDE runs inside container |
| **[Ollama](#ollama-configuration)** | Runs local LLM models (port 11434) |
| **[Claude Code](https://claude.ai/)** | AI assistant CLI for terminal assistance |

All tools are installed automatically when the container builds. When you're done, just stop the container to reset everything cleanly.

---

## 🔒 Security Overview

### Container Isolation
The agent runs in a Docker container separate from your host system. By default, it cannot access files outside the workspace or mounted directories.

### Selective File Access
Only specific folders are visible to the agent:
- `/home/vscode/.claude` - AI configuration and generated files (mounted)
- `~/.ollama` - Local AI models (mounted)

**Not accessible:** System configs (`/etc`), user downloads, credentials outside mounts, or any path you don't explicitly expose.

### Limited User Privileges
Claude Code is installed for the `vscode` user only (not root). Even if an agent runs system commands, it operates with limited privileges.

---

## 🧱 How It Works

### Docker Containerization
Docker packages applications with their dependencies into standardized units called **containers**.

**Key Benefits:**
- **Reproducibility** - Same code runs identically everywhere
- **Isolation** - Applications don't step on each other's dependencies
- **Clean Slate** - Stop and restart for a fresh workspace

See [Dockerfile](/.devcontainer/Dockerfile) for build instructions showing what's installed.

### Dev Containers
Dev Containers extend Docker by integrating directly with VS Code. When you open this folder:
1. A `Dockerfile` defines your container image
2. `.devcontainer/` configures VS Code integration
3. Your IDE runs inside the container with pre-installed tools

See [devcontainer.json](/.devcontainer/devcontainer.json) for mount configuration.

### Ollama Configuration
Ollama is a lightweight runtime for local LLM models on port 11434.

**Why local matters:**
- **Privacy** - Models never leave your machine
- **Offline capability** - Work continues without internet
- **Performance** - No network latency to external APIs

To use Ollama, run `ollama serve` in the VS Code terminal first (or leave it running). Then pull models with:

```bash
ollama pull llama3.2
```

---

## 🚀 Getting Started

1. **Install Docker Desktop** (if not already installed)
   - Download from https://www.docker.com/products/docker-desktop/

2. **Open this folder in VS Code**
   - The Dev Container will automatically build and install tools
   - First run takes a few minutes; subsequent runs use cached image

3. **(Optional) Pull Ollama models**
   ```bash
   ollama pull llama3.2
   ```
   Only needed once. Run `ollama serve` in terminal to keep it running.

4. **Start using!**
   - Use the `claude` command or `/claude` slash command for AI assistance

That's it! Your environment is now ready for AI-powered development.

---

## 📚 Configuration Details

### Dockerfile
See [/.devcontainer/Dockerfile](/.devcontainer/Dockerfile) for:
- Base system (Ubuntu)
- System dependencies (curl, zstd)
- Ollama installation
- Claude Code setup as vscode user

### devcontainer.json
See [/.devcontainer/devcontainer.json](/.devcontainer/devcontainer.json) for:
- Port forwarding (11434 for Ollama API)
- Mount configurations (`.claude`, `~/.ollama`)
- GPU support (`--gpus=all`)

---

## 🔍 Troubleshooting

### Ollama Not Responding
- Check if service is running: `ollama serve`
- Verify port 11434 is accessible in VS Code terminal

### Claude CLI Commands Not Found
- Run `which claude` or `claude --version` to verify installation

### Slow Container Build on First Run
- Normal on first run while Docker pulls the image from registry
- Subsequent builds are cached and fast

---

## ✅ Summary

This Dev Container workspace provides:
1. **Consistent AI development environment** - Same setup everywhere
2. **Local LLM capabilities** via Ollama for offline/privacy-focused work
3. **Secure CLI access** via Claude Code installed as limited user
4. **Portable configuration** via mount points that persist across sessions

Use it to:
- Develop AI applications with consistent tooling
- Test local LLM-based workflows without external APIs
- Share your environment with colleagues via git

---

## 🔗 External Resources

- [Docker Docs](https://docs.docker.com/get-started/) - Learn about containerization
- [Dev Containers Docs](https://containers.dev/) - Standard for containerized development environments
- [Ollama Docs](https://ollama.ai/docs) - Run local LLM models
- [Claude Code Docs](https://claude.ai/) - AI assistant CLI features

---

## 🔐 Security Notes

This environment prioritizes your security through:
- **Container isolation** - Agents run in sandboxed environment
- **Limited user privileges** - Claude Code installed as vscode user, not root
- **Selective mounts** - Only necessary directories exposed
- **Bind mount constraints** - Agents confined to workspace + selected paths

For detailed security rationale and threat mitigations, see [.devcontainer/best-practices.md](.devcontainer/best-practices.md).
