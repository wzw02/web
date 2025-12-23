#!/bin/bash

# 蓝绿部署脚本
set -e

# 颜色定义
BLUE="blue"
GREEN="green"
ACTIVE=""
NEW=""

# 获取当前活跃版本
if docker ps --filter "name=app_blue" --format "{{.Names}}" | grep -q "app_blue"; then
    ACTIVE=$BLUE
    NEW=$GREEN
else
    ACTIVE=$GREEN
    NEW=$BLUE
fi

echo "当前活跃版本: $ACTIVE"
echo "将要部署版本: $NEW"

# 拉取新版本镜像
NEW_TAG=$1
if [ -z "$NEW_TAG" ]; then
    echo "请输入镜像标签"
    exit 1
fi

# 更新docker-compose中的环境变量
if [ "$NEW" = "blue" ]; then
    export BLUE_TAG=$NEW_TAG
else
    export GREEN_TAG=$NEW_TAG
fi

# 启动新版本
echo "启动 $NEW 版本..."
docker-compose up -d app_$NEW

# 等待健康检查
echo "等待 $NEW 版本健康检查..."
for i in {1..12}; do
    if docker-compose exec -T app_$NEW curl -f http://localhost:5000/health > /dev/null 2>&1; then
        echo "$NEW 版本已就绪"
        break
    fi
    if [ $i -eq 12 ]; then
        echo "$NEW 版本健康检查失败，回滚"
        docker-compose stop app_$NEW
        exit 1
    fi
    sleep 5
done

# 切换流量（这里假设有专门的切换端点）
echo "切换流量到 $NEW 版本..."
# curl -X POST http://localhost/switch?version=$NEW

# 停止旧版本
echo "停止 $ACTIVE 版本..."
docker-compose stop app_$ACTIVE

# 清理旧镜像
echo "清理未使用的镜像..."
docker image prune -f

echo "部署完成! 当前活跃版本: $NEW"