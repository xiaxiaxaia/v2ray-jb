# VPS 节点部署与配置总结

## 1. 当前服务器结构
使用 sing-box 核心，同时部署：

```
Reality (主用)      → sing-box
Hysteria2 (备用)    → sing-box
VLESS + WS + TLS    → Nginx → Cloudflare
```

## 2. Cloudflare 橙色云使用规则
| 协议 | Cloudflare 设置 |
| ---- | --------------- |
| VLESS + WS + TLS | 🟧 橙色云（Proxied） |
| Reality | ☁️ 灰色云（DNS only） |
| Hysteria2 | ☁️ 灰色云（DNS only） |

## 3. Nginx 路径结构
```
/alone        → VLESS + WS 节点
/200MB.zip    → 测速文件
/index.html   → 伪装站
```
不要把测速文件放在 `/alone` 下。

## 4. 测速文件部署
```
cd /usr/share/nginx/html
fallocate -l 200M 200MB.zip
```
访问 `https://<你的域名>/200MB.zip` 进行测速。

## 5. Cloudflare 对测速的影响
- 开橙云：测速结果包含 Cloudflare → VPS 线路。
- 要测 VPS 真实带宽：暂时关橙云（DNS only）。

## 6. 当前 VPS IP 状态（示例）
```
144.202.102.101 (Vultr US)
OpenAI API 可访问
```
IP 质量良好，无需 WARP。

## 7. 节点推荐使用顺序
```
Reality → 主用
Hysteria2 → 网络差时
WS + Cloudflare → 备用
```

## 8. 完成项
- sing-box 核心安装
- Reality 节点
- Hysteria2 节点
- Cloudflare WS 节点
- BBR 已启用
- OpenAI 访问测试通过

## 9. 结论
测速文件 `https://<你的域名>/200MB.zip` 合法且不影响节点，可放心使用。
