#!/bin/bash

# 项目名称和仓库 URL
PROJECT_NAME="LayerEdge-BOT"
REPO_URL="https://github.com/aowei010/LayerEdge-BOT"

# Step 1: 检查并安装 Python3.9 或更高版本
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))' 2>/dev/null)
REQUIRED_PYTHON_VERSION="3.9"
if [[ "$(printf '%s\n' "$REQUIRED_PYTHON_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_PYTHON_VERSION" ]]; then
  echo "Python 3.9 or higher is required. Please install it first."
  exit 1
fi

# Step 2: 克隆仓库
echo "Cloning repository $REPO_URL..."
git clone $REPO_URL
cd $PROJECT_NAME

# Step 3: 安装依赖项
echo "Installing dependencies..."
pip install -r requirements.txt

# Step 4: 配置账户信息和代理信息
echo "Please enter your wallet private keys and corresponding proxies (one per line, end with an empty line)."
echo "Format: private_key,socks5://user:pass@ip:port (leave proxy empty if not needed)"

PRIVATE_KEYS=()
PROXIES=()

while IFS= read -r line; do
  [[ $line ]] || break  # 读取空行时结束
  IFS=',' read -r key proxy <<< "$line"
  PRIVATE_KEYS+=("$key")
  PROXIES+=("$proxy")
done

# 保存账户信息到 accounts.txt 文件
echo "Saving private keys to accounts.txt..."
for key in "${PRIVATE_KEYS[@]}"; do
  echo "$key" >> accounts.txt
done

# 保存代理信息到 proxy.txt 文件
echo "Saving proxy information to proxy.txt..."
for proxy in "${PROXIES[@]}"; do
  echo "$proxy" >> proxy.txt
done

# Step 5: 运行脚本
echo "Starting LayerEdge-BOT..."
python3 bot.py

echo "LayerEdge-BOT setup complete!"
