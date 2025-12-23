FROM python:3.9-slim

WORKDIR /app

# 复制所有文件
COPY . .

# 安装依赖
RUN pip install --no-cache-dir Flask==2.3.3

# 暴露端口
EXPOSE 5000

# 启动应用
CMD ["python", "app.py"]