# me/v2ray-jb 同步迁移记录（2026-03-04）

## 1. 迁移范围
本次迁移已覆盖：
- 核心脚本升级（`install.sh`、`shell/install_en.sh`）
- 模块级 Bug 修复
- 模块级优化同步
- 高风险运维脚本安全加固
- 文档更新（`README.md` + 本迁移文档）

## 2. 安全审计结果
### 结论
已审阅脚本中未发现明显木马特征（如反弹 shell 载荷、混淆解密执行链、隐藏命令加载器等）。

### 风险分级发现
- 高风险运维脚本（若被误调用，影响较大）：
  - `shell/ufw_remove.sh`（关闭防火墙并清空 iptables）
  - `shell/empty_login_history.sh`（清空登录与历史日志）
  - `shell/init_gcp_ssh.sh`（重写 sshd 认证配置）
- 中风险操作（安装流程常见）：
  - 远程下载/安装步骤（`curl|sh`、远程二进制下载）
  - 卸载或重置时的大范围 `rm -rf`

### 已实施缓解
以上高风险脚本均已加入显式确认门禁：
- 交互模式：必须输入 `YES`
- 非交互模式：必须传入 `--force`

## 3. 已同步内容
- 已将 `me/v2ray-jb/install.sh` 基于 `v2ray-agent/install.sh` 进行同步。
- 已将 `me/v2ray-jb/shell/install_en.sh` 基于 `v2ray-agent/shell/install_en.sh` 进行同步。
- 在核心 + 协议 + 订阅范围内同步了以下能力：
  - `sing-box` 相关流程
  - `Reality`
  - `Hysteria2`
  - `Tuic`
  - 订阅本地/远程聚合模型
  - `UpdateGeo` 定时更新链路
  - 安装稳定性与兼容性优化
  - 自动生成 `/usr/share/nginx/html/200MB.zip` 测速文件

## 4. 上游来源策略（保持）
按当前策略，脚本中的上游来源保持在你的现有链路：
- `mack-a/v2ray-agent` 已替换为 `panhuanghe/v2ray-agent`

这样可确保后续自更新与下载链路和你现有仓库策略一致。

## 5. 高风险脚本门禁变更
已更新脚本：
- `shell/ufw_remove.sh`
- `shell/empty_login_history.sh`
- `shell/init_gcp_ssh.sh`

行为变化：
- 默认要求人工确认（输入 `YES`）
- 自动化执行时需显式传入 `--force`

## 6. 升级检查清单
1. 先备份目标机 `/etc/v2ray-agent` 与当前运行配置。
2. 部署更新后的脚本。
3. 运行安装脚本并检查服务状态与菜单入口。
4. 重新生成并校验订阅内容。
5. 校验定时任务（证书续签、Geo 更新）。

## 7. 回滚指引
若发现兼容性问题：
1. 恢复旧版脚本。
2. 恢复 `/etc/v2ray-agent` 备份。
3. 重启相关服务（`xray` / `sing-box` / `nginx`）。
4. 重新校验订阅地址与客户端配置。

## 8. 已知差异
- 订阅目录结构与生成逻辑已升级。
- 协议/核心菜单与路由管理能力明显扩展。
- 高风险脚本不再默认静默执行。

## 9. 验收点
- 关键词存在：`sing-box`、`reality`、`hysteria2`、`tuic`、`subscribe_local`、`UpdateGeo`
- 来源策略正确：更新后的 `me` 目标脚本中不应残留 `mack-a` 链接
- 门禁生效：高风险脚本无 `YES` / `--force` 时应拒绝执行