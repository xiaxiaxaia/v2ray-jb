#!/usr/bin/env bash
set -euo pipefail

# bash <(curl -L -s https://raw.githubusercontent.com/panhuanghe/v2ray-agent/master/init_GCP_ssh.sh)

confirm_dangerous_action() {
    if [[ "${1:-}" == "--force" ]]; then
        return 0
    fi
    echo "警告：此脚本将重写 sshd 认证配置并重启 ssh 服务。" >&2
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

if [[ ! -f "$HOME/.ssh/authorized_keys" ]]; then
    echo "正在初始化 authorized_keys"
    mkdir -p "$HOME/.ssh"
    touch "$HOME/.ssh/authorized_keys"
    chmod 600 "$HOME/.ssh/authorized_keys"
fi

if [[ ! -f "/etc/ssh/sshd_config" ]]; then
    echo "未找到 sshd 配置文件: /etc/ssh/sshd_config" >&2
    exit 1
fi

sed -i 's/^\s*PasswordAuthentication\s\+.*/#&/g' /etc/ssh/sshd_config
sed -i 's/^\s*RSAAuthentication\s\+.*/#&/g' /etc/ssh/sshd_config
sed -i 's/^\s*PubkeyAuthentication\s\+.*/#&/g' /etc/ssh/sshd_config
sed -i 's/^\s*AuthorizedKeysFile\s\+.*/#&/g' /etc/ssh/sshd_config
sed -i 's/^\s*PermitRootLogin\s\+.*/#&/g' /etc/ssh/sshd_config

sed -i '1iAuthorizedKeysFile .ssh/authorized_keys' /etc/ssh/sshd_config
sed -i '1iPubkeyAuthentication yes' /etc/ssh/sshd_config
sed -i '1iRSAAuthentication yes' /etc/ssh/sshd_config
sed -i '1iPasswordAuthentication no' /etc/ssh/sshd_config

if command -v systemctl >/dev/null 2>&1; then
    systemctl restart sshd || systemctl restart ssh || service sshd restart || service ssh restart
else
    service sshd restart || service ssh restart
fi
