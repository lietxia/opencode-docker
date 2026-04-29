FROM ubuntu:26.04

# Install core
RUN apt-get update && apt-get -y upgrade \
    && apt-get install -y mc htop iotop ncdu tar zip nano vim bash sudo sed fzf wget ca-certificates curl unzip gnupg fzf tmux build-essential git ninja-build gettext cmake lazygit fd-find ripgrep tree-sitter-cli neovim gh age byobu fastfetch \
    # Net utils
    && apt-get install -y iputils-ping traceroute telnet dnsutils iperf nmap

# Install UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

RUN curl https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise sh

# Preload GitHub host keys (non-interactive Git usage)
RUN ssh-keyscan -T 5 github.com 2>/dev/null >> ~/.ssh/known_hosts || true

RUN mise use -g node
RUN mise use -g go 
RUN mise use -g python
RUN mise use -g rust
RUN curl -fsSL https://opencode.ai/install | bash
RUN ln ~/.opencode/bin/opencode /usr/local/bin/opencode && mkdir -p /workspace
WORKDIR /workspace