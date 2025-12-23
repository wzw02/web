
#!/bin/bash
# 监控服务状态

# 检查所有容器状态
docker-compose ps

# 检查日志
docker-compose logs --tail=50

# 检查资源使用
docker stats --no-stream

# 发送监控数据到外部系统（如 Prometheus）
