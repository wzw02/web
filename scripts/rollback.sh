#!/bin/bash
# 快速回滚到上一个版本

# 确定当前活跃实例
if docker ps --filter "name=app_blue" --format "{{.Status}}" | grep -q "Up"; then
    CURRENT="blue"
    ROLLBACK="green"
else
    CURRENT="green"
    ROLLBACK="blue"
fi

echo "当前实例: ${CURRENT}"
echo "回滚到: ${ROLLBACK}"

# 检查回滚实例是否可用
if docker-compose ps | grep -q "app_${ROLLBACK}"; then
    echo "找到可用的回滚实例"
    
    # 切换到回滚实例
    sed -i "s/server app_${CURRENT}:5000.*/server app_${ROLLBACK}:5000;/" nginx/conf.d/default.conf
    sed -i "s/server app_${ROLLBACK}:5000 backup/server app_${CURRENT}:5000 backup/" nginx/conf.d/default.conf
    
    docker-compose restart nginx
    echo "已回滚到 ${ROLLBACK} 实例"
else
    echo "错误: 没有可用的回滚实例"
    exit 1
fi
