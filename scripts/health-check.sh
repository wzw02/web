#!/bin/bash
URL=$1
MAX_ATTEMPTS=30
ATTEMPT=0

echo "检查服务健康: ${URL}"

while [ ${ATTEMPT} -lt ${MAX_ATTEMPTS} ]; do
    if curl -f ${URL} > /dev/null 2>&1; then
        echo "服务健康!"
        exit 0
    fi
    echo "等待服务... (${ATTEMPT}/${MAX_ATTEMPTS})"
    ATTEMPT=$((ATTEMPT + 1))
    sleep 2
done

echo "错误: 服务在 ${MAX_ATTEMPTS} 次尝试后未就绪"
exit 1