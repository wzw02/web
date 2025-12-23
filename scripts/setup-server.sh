#!/bin/bash
# 在生产服务器上运行此脚本进行初始化

# 1. 安装 Docker 和 Docker Compose
apt-get update
apt-get install -y docker.io docker-compose

# 2. 创建项目目录
PROJECT_DIR="/opt/web-calculator"
mkdir -p ${PROJECT_DIR}/{nginx/conf.d,scripts,logs}

# 3. 复制部署文件
# （假设从 CI/CD 服务器复制）

# 4. 设置权限
chmod +x ${PROJECT_DIR}/scripts/*.sh

# 5. 创建 .env 文件（安全地存储敏感信息）
cat > ${PROJECT_DIR}/.env << EOF
BLUE_TAG=initial
GREEN_TAG=initial
EOF

# 6. 设置防火墙
ufw allow 80/tcp
ufw allow 22/tcp
ufw --force enable

# 7. 设置 Docker 日志轮转
cat > /etc/docker/daemon.json << EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

systemctl restart docker

echo "服务器初始化完成"
