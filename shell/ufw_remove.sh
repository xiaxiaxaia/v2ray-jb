#!/usr/bin/env bash
set -euo pipefail

# wget -P /tmp -N --no-check-certificate "https://raw.githubusercontent.com/panhuanghe/v2ray-agent/master/shell/ufw_remove.sh" && chmod 700 /tmp/ufw_remove.sh && /tmp/ufw_remove.sh

confirm_dangerous_action() {
    if [[ "${1:-}" == "--force" ]]; then
        return 0
    fi
    echo "警告：此脚本将停止 ufw 并清空 iptables 规则。" >&2
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

systemctl stop ufw
systemctl disable ufw
iptables -F
iptables -I INPUT -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -I OUTPUT -o eth0 -d 0.0.0.0/0 -j ACCEPT
