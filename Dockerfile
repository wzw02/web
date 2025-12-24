FROM python:3.9-slim

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖文件
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY app.py calculator.py .

# 创建非root用户
RUN useradd -m -u 1000 flaskuser && chown -R flaskuser:flaskuser /app
USER flaskuser

# 暴露端口
EXPOSE 5000

# 健康检查（使用Python替代curl）
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import requests; r = requests.get('http://localhost:5000/health', timeout=2); exit(0 if r.status_code == 200 else 1)"

# 启动应用
CMD ["python", "app.py"]