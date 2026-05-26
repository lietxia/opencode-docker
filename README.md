# OpenCode Docker 开发环境

一个容器化的开发环境，集成了 OpenCode WebUI 和多种编程语言工具链。

## 功能特性

- **OpenCode WebUI** — AI 驱动的代码编辑器
- **Python 3.13** — 数据科学、脚本开发
- **Node.js (LTS)** — JavaScript/TypeScript 运行时
- **Bun** — 高性能 JavaScript 运行时
- **Go 1.23.5** — 系统编程语言
- **Rust** — 系统编程语言
- **Java 21 (OpenJDK LTS)** — 企业级编程平台
- **Maven** — Java 项目构建工具
- **PHP** — Web 开发语言
- **uv** — Python 包管理器
- **rclone** — 云存储同步工具
- **magic-wormhole** — 安全文件传输工具

## 快速开始

### 使用 Docker Compose（推荐）

```bash
docker-compose up -d
```

访问 http://localhost:4096

默认账号密码：
- 用户名：`ubuntu`
- 密码：`ubuntu`

### 使用 Docker 命令

```bash
# 构建镜像
docker build -t opencode-dev:latest .

# 运行容器
docker run -d \
  -p 4096:4096 \
  -p 9999:9999 \
  -p 8888:8888 \
  -v $(pwd)/workspace:/root/workspace \
  --name opencode-dev \
  opencode-dev:latest
```

### 进入容器交互式终端

```bash
docker exec -it opencode-dev bash
```

## 端口说明

| 端口 | 用途 |
|------|------|
| 4096 | OpenCode WebUI |
| 9999 | 预留端口 |
| 8888 | 预留端口 |

## 环境变量

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `OPENCODE_SERVER_USERNAME` | WebUI 登录用户名 | `ubuntu` |
| `OPENCODE_SERVER_PASSWORD` | WebUI 登录密码 | `ubuntu` |
| `OPENCODE_PORT` | WebUI 监听端口 | `4096` |
| `OPENCODE_HOSTNAME` | WebUI 绑定地址 | `0.0.0.0` |

## 容器内可用工具

```bash
# Python
python3 --version
python --version
uv --version

# JavaScript/TypeScript
node --version
npm --version
bun --version

# Go
go version

# Rust
rustc --version
cargo --version

# Java
java --version
mvn --version

# PHP
php --version

# 其他工具
rclone version
wormhole --version
git --version
```

## 目录结构

```
.
├── Dockerfile          # 镜像构建文件
├── docker-compose.yml  # Docker Compose 配置
├── README.md           # 本文件
├── workspace/          # 工作目录（挂载到容器 /root/workspace）
└── .gitignore
```

## 数据持久化

- `./workspace/` → 容器内的 `/root/workspace/`（代码和项目文件）
- `cfg` 卷 → 容器内的 `/root/.opencode/`（OpenCode 配置）

## 重新构建

修改 Dockerfile 后，需要重新构建镜像：

```bash
docker-compose up -d --build
```

## 技术栈版本

| 工具 | 版本 |
|------|------|
| Ubuntu | 24.04 |
| Python | 3.13 |
| Node.js | LTS |
| Go | 1.23.5 |
| Java | OpenJDK 21 |
| Maven | 随 Ubuntu 仓库版本 |
| PHP | 随 Ubuntu 仓库版本 |

## 注意事项

- 容器以 `root` 用户运行
- 工作目录为 `/root/workspace`
- 网络模式为 `bridge`
- 容器重启策略：`unless-stopped`
