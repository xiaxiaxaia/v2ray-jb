# Cloudflare 优选 IP & 端口使用教程

## 适用场景
手里有被阻断或闲置的 VPS，通过优选 IP + CDN 套壳提升可用性。Cloudflare 代理 HTTPS 仅支持端口：443、2053、2083、2087、2096、8443；其他端口只能直连。

## 步骤概览
1. 优选 IP（CloudflareSpeedTest）
2. 脚本安装支持 CDN 的协议（WS / gRPC / HTTPUpgrade 推荐）
3. 在脚本中写入优选 IP
4. 拉取订阅到客户端
5. 客户端开启自动优选（可选）

## 1. 优选 IP
- 下载 CloudflareSpeedTest（GitHub Releases 或蓝奏云），按 CPU 架构选择二进制。
- 解压后直接运行可执行文件（macOS/Linux 执行 `./CloudflareST`，Windows 运行 `.exe`），得到延迟/带宽排序结果。

## 2. 端口选择（重要）
- 使用 Cloudflare 代理时，仅选用 443/2053/2083/2087/2096/8443。
- 若选择其他端口，Cloudflare 不代理，只能直连。
- 在脚本端口输入步骤会提示并校验：非列表端口将提示“仅直连”。

## 3. 脚本安装与优选 IP 写入
- 运行脚本（vasma）安装支持 CDN 的协议（WS/gRPC/HTTPUpgrade）。
- 通过菜单写入优选 IP：`vasma -> 10 -> 5`，粘贴 CloudflareSpeedTest 结果中的优选 IP。

## 4. 拉取订阅
- 进入脚本：`vasma -> 7.账号管理 -> 2.查看订阅`，复制订阅链接到客户端。
- 订阅端口应与步骤 2 选择的端口一致（默认 443 或你指定的 CF 允许端口）。

## 5. 客户端自动优选（以 Clash Verge Rev 为例）
- 导入订阅后，打开订阅配置文件，找到：
```yaml
health-check:
  enable: true
  url: http://www.gstatic.com/generate_204
  interval: 60   # 单位秒，按需调节
```
- 在 Proxies 里把对应策略改为自动选择（url-test/fallback）。

## FAQ
- **端口被占用**：先用 `ss -lntp | grep ':端口'` 确认占用，若已被核心占用，改用其他 CF 允许端口。
- **证书缺失**：订阅/伪装 server 使用域名证书，缺失时先完成 TLS 证书申请再启动订阅。
- **非允许端口**：可用但仅直连，Cloudflare 不会代理，命中运营商策略风险更高。

