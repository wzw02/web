FROM python:3.9-alpine

WORKDIR /app

# 安装依赖
RUN apk add --no-cache build-base linux-headers

# 复制依赖文件
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY src/ .

# 创建非root用户
RUN adduser -D -u 1001 appuser && chown -R appuser:appuser /app
USER appuser

# 暴露端口
EXPOSE 5000

# 运行应用
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app", "--workers", "4"]