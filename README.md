# OpenCode 2 Docker

容器化的 [OpenCode 2](https://opencode.ai/v2/docs/) WebUI。镜像只包含 OpenCode 2 自包含二进制 + 最小运行依赖（git、ripgrep、curl），不预装 Node/Python/Java/Go/Rust 等工具链，需要什么在 `./code` 里自己装或换带工具链的镜像。

[![Docker Hub](https://img.shields.io/docker/v/lietxia/opencode/latest?label=Docker%20Hub&logo=docker)](https://hub.docker.com/r/lietxia/opencode)
[![GHCR](https://img.shields.io/badge/GHCR-lietxia%2Fopencode-blue?logo=github)](https://github.com/lietxia/opencode-docker/pkgs/container/opencode)

## OpenCode 2 变了什么

| 项目 | OpenCode 1（旧） | OpenCode 2（本仓库） |
|---|---|---|
| 启动命令 | `opencode web --port 4096` | `opencode serve --hostname 0.0.0.0 --port 4096` |
| 安装方式 | `npm i -g opencode-ai` | 官方脚本 `curl -fsSL https://opencode.ai/v2/install \| bash` |
| npm 包名 | `opencode-ai` | `@opencode/cli`（脚本内部从 npm 取平台二进制） |
| WebUI 登录 | Basic Auth 弹窗 | 自带登录页：服务器 URL + 密码 |
| 登录用户名 | `ubuntu` | 固定 `opencode`（不可改） |
| 固定密码 | `OPENCODE_SERVER_PASSWORD` | `OPENCODE_PASSWORD`（旧名仍兼容） |
| 监听地址/端口 | 环境变量 | **只能命令行参数**，环境变量已失效 |
| 数据目录 | `~/.local/share/opencode` | 同上，另加 `~/.local/state/opencode` |

## 快速开始

```bash
git clone https://github.com/lietxia/opencode-docker.git
cd opencode-docker

# 首次必须构建 v2 镜像：Docker Hub 上的 latest 可能还是 v1
./build.sh

cp .env.example .env      # 固定密码默认 lede，可改
docker compose up -d
```

打开 <http://localhost:4096>，登录页填：

| 字段 | 值 |
|---|---|
| 服务器 URL | `http://localhost:4096`（用别的机器访问就填宿主机 IP） |
| 密码 | `lede`（或你 `.env` 里设的值） |

登录后写 30 天会话 cookie，不用反复输密码。

> 密码来自环境变量 `OPENCODE_PASSWORD`。容器里不写死密码，只有 compose 给了默认值 `lede`，生产部署务必改掉。

## 三种登录方式

1. **网页密码**：打开 `http://<host>:4096/`，点 “Use password”，填服务器 URL + 密码。
2. **一次性配对链接**（扫码/点开即登录）：
   ```bash
   ./login.sh http://<host>:4096
   # 输出 http://<host>:4096/auth/connect/xxxxx ，5 分钟内有效
   ```
   这是官方 `opencode pair` 用的同一个登录接口，只是直接对独立 `serve` 进程生成链接。
3. **API Basic Auth**：用户名固定 `opencode`，密码同上：
   ```bash
   curl -u opencode:lede http://localhost:4096/api/info
   ```

## 固定密码

```yaml
environment:
  OPENCODE_PASSWORD: ${OPENCODE_PASSWORD:-lede}
```

- 换密码：改 `.env` 里的 `OPENCODE_PASSWORD`，然后 `docker compose up -d`。
- 密码变了一切会话失效（cookie 用密码派生签名），需要重新登录。
- 不设或设成空字符串：每次启动随机生成，日志里打印 `server password ...`（`docker compose logs opencode | grep "server password"`）。
- 旧变量 `OPENCODE_SERVER_PASSWORD` 仍然被识别，但 `OPENCODE_SERVER_USERNAME` 已无效。

| 变量 | 说明 | 默认 |
|---|---|---|
| `OPENCODE_PASSWORD` | 登录密码（用户名固定 `opencode`） | `lede` |
| `OPENCODE_IMAGE` | 使用的镜像名 | `lietxia/opencode:latest` |

监听地址和端口只能写在 `command` 里（`--hostname` / `--port`）。

## 端口

| 端口 | 用途 |
|---|---|
| 4096 | OpenCode 2 WebUI + API |
| 9999 | 预留 |
| 8888 | 预留 |

## 数据持久化

| 宿主机路径 | 容器路径 | 用途 |
|---|---|---|
| `./code/` | `/code/` | 项目文件 |
| `./config/` | `/root/.config/` | 全局配置（`opencode/opencode.json`）、agents、commands、skills |
| `./data/` | `/root/.local/share/opencode` | SQLite 会话库、日志、worktree |
| `./state/` | `/root/.local/state/opencode` | 服务状态（v2 新增） |
| `./cache/` | `/root/.cache/opencode` | 模型/插件缓存（v2 新增） |

## 从 v1 升级

1. 构建/拉取 v2 镜像：`./build.sh`（本地构建，覆盖本机 `lietxia/opencode:latest`）；已 push 过新镜像的机器用 `docker compose pull`。
2. 确认 compose 的 `command` 是 `serve ...`，不是 `web`。
3. 删掉 `OPENCODE_HOSTNAME` / `OPENCODE_PORT` / `OPENCODE_SERVER_USERNAME`，只留 `OPENCODE_PASSWORD`。
4. 配置兼容：v2 与 v1 用同一批配置文件路径，`opencode.json(c)`、agents、commands、skills 基本原样可用。
   - **插件 API 变了**：v1 插件在 v2 不跑，需要按 <https://opencode.ai/v2/docs/build/plugins/migrate-v1> 重写。
   - 服务端 API/客户端契约变了，自建集成要改。
5. 首次进入 v2 后核对模型、凭据、MCP、权限。

## 常用命令

```bash
docker compose logs -f opencode          # 看日志
docker exec -it opencode-webui bash      # 进容器
docker exec opencode-webui opencode --version
docker exec opencode-webui opencode api get /api/info
./login.sh http://localhost:4096         # 生成登录链接
docker compose restart                   # 改完 .env 后生效
```

## 构建与发布

```bash
# 默认 lietxia/opencode:latest
./build.sh

# 自定义 tag
./build.sh lietxia/opencode:2.2.5

# 指定 OpenCode 版本（默认 2.2.5，传给官方安装脚本的 --version）
docker build --build-arg OPENCODE_VERSION=2.2.5 -t lietxia/opencode:2.2.5 .

docker push lietxia/opencode:latest
docker push ghcr.io/lietxia/opencode:latest
```

## 验证安装

```bash
docker exec opencode-webui bash -c '
  opencode --version &&
  git --version &&
  rg --version | head -1
'
```

正常输出 `opencode v2.2.5`。如果启动时报“不是 v2”，说明镜像还是旧的 v1，重新 `./build.sh`。

## 故障排查

| 现象 | 原因 / 处理 |
|---|---|
| `localhost:4096` 打不开 | `docker compose logs opencode` 看是否监听 `0.0.0.0:4096`；没加 `--hostname 0.0.0.0` 就只监听容器内 127.0.0.1 |
| 登录页一直“连接到服务器” | 服务器 URL 要能被浏览器访问；容器内是 `0.0.0.0:4096`，外面填宿主机 IP:4096 |
| 密码总是不对 | 用户名固定 `opencode`；确认容器内 `echo $OPENCODE_PASSWORD`；改过 `.env` 要 `docker compose up -d` 重建容器 |
| API 返回 401 | 没带 Basic auth，或密码不是当前值（改密码会让旧 cookie 全部失效） |
| 想免密进 | `./login.sh http://<host>:4096`，浏览器打开输出的链接 |
| 端口冲突 | 改 compose 的 `ports` 左侧，同时改 `command` 里的 `--port`（两处要一致） |
| 容器起来了但没模型 | v2 凭据放在 `./data`/`./config`，先在 UI 里连 provider 或写 `config/opencode/opencode.json` |

## 目录结构

```
.
├── Dockerfile              # 镜像定义（OpenCode 2 CLI，最小依赖）
├── docker-entrypoint.sh    # 入口：校验 v2 版本后启动
├── docker-compose.yml      # compose 配置
├── build.sh                # 本地构建脚本
├── login.sh                # 生成一次性登录链接
├── .env.example            # 固定密码示例
├── init.sh                 # 项目批量 clone 脚本（可选）
└── README.md
```

## License

MIT
