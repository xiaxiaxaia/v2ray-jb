#!/usr/bin/env bash
set -euo pipefail

# 清空登录与 shell 历史日志
# wget -P /tmp -N --no-check-certificate "https://raw.githubusercontent.com/panhuanghe/v2ray-agent/master/shell/empty_login_history.sh" && chmod 700 /tmp/empty_login_history.sh && /tmp/empty_login_history.sh

confirm_dangerous_action() {
    if [[ "${1:-}" == "--force" ]]; then
        return 0
    fi
    echo "警告：此脚本会清空主机登录与历史日志。" >&2
    echo "如需非交互执行，请使用 --force。" >&2
    if [[ ! -t 0 ]]; then
        echo "非交互模式未提供 --force，已拒绝执行。" >&2
        exit 1
    fi
    read -r -p "输入 YES 后继续执行: " confirm
    if [[ "${confirm}" != "YES" ]]; then
        echo "已取消执行。"
        exit 1
    fi
}

confirm_dangerous_action "${1:-}"

echo "正在清空日志文件..."
: > /var/log/wtmp
: > /var/log/btmp
: > /var/log/lastlog
: > ~/.bash_history

echo "正在清理临时脚本..."
rm -rf /tmp/empty_login_history.sh
history -c || true
echo "执行完成。"
