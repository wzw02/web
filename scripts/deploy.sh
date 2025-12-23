#!/bin/bash
set -e

echo "=== 开始蓝绿部署 ==="

# 确定当前活跃颜色
if docker ps --filter "name=app_blue" --format "{{.Status}}" | grep -q "Up"; then
    CURRENT_ACTIVE="blue"
    NEW_ACTIVE="green"
else
    CURRENT_ACTIVE="green"
    NEW_ACTIVE="blue"
fi

echo "当前活跃实例: ${CURRENT_ACTIVE}"
echo "新部署实例: ${NEW_ACTIVE}"

# 启动新实例
echo "启动 ${NEW_ACTIVE} 实例..."
docker-compose up -d app_${NEW_ACTIVE}

# 等待新实例健康
echo "等待 ${NEW_ACTIVE} 实例健康..."
MAX_WAIT=60
WAITED=0
while [ ${WAITED} -lt ${MAX_WAIT} ]; do
    if docker-compose ps app_${NEW_ACTIVE} | grep -q "(healthy)"; then
        echo "${NEW_ACTIVE} 实例已健康"
        break
    fi
    echo "等待 ${NEW_ACTIVE} 实例健康... (${WAITED}/${MAX_WAIT}秒)"
    sleep 5
    WAITED=$((WAITED + 5))
done

if [ ${WAITED} -ge ${MAX_WAIT} ]; then
    echo "错误: ${NEW_ACTIVE} 实例在 ${MAX_WAIT} 秒内未健康"
    docker-compose logs app_${NEW_ACTIVE}
    docker-compose stop app_${NEW_ACTIVE}
    exit 1
fi

# 更新 Nginx 配置指向新实例
echo "更新 Nginx 配置指向 ${NEW_ACTIVE} 实例..."
cat > nginx/conf.d/default.conf << EOF
upstream backend {
    server app_${NEW_ACTIVE}:5000;
    server app_${CURRENT_ACTIVE}:5000 backup;
}

server {
    listen 80;
    server_name localhost;
    
    location / {
        proxy_pass http://backend;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
    
    location /health {
        access_log off;
        return 200 'healthy\n';
        add_header Content-Type text/plain;
    }
}
EOF

# 重启 Nginx
echo "重启 Nginx..."
docker-compose restart nginx

# 等待 Nginx 健康
sleep 10

# 可选：运行冒烟测试
echo "运行冒烟测试..."
if curl -f http://localhost/health; then
    echo "冒烟测试通过"
else
    echo "错误: 冒烟测试失败"
    # 回滚到旧实例
    echo "正在回滚到 ${CURRENT_ACTIVE} 实例..."
    cat > nginx/conf.d/default.conf << EOF
upstream backend {
    server app_${CURRENT_ACTIVE}:5000;
}
server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}
EOF
    docker-compose restart nginx
    docker-compose stop app_${NEW_ACTIVE}
    exit 1
fi

# 停止旧实例（可选，保持作为备份）
echo "停止旧 ${CURRENT_ACTIVE} 实例..."
docker-compose stop app_${CURRENT_ACTIVE}

echo "=== 部署完成 ==="
echo "新活跃实例: ${NEW_ACTIVE}"
echo "旧实例已停止（可作为快速回滚点）"