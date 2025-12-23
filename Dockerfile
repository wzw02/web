FROM python:3.9-slim

WORKDIR /app

# 安装系统依赖（包括 curl）
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 复制应用代码
COPY app.py calculator.py requirements.txt ./

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 创建非root用户
RUN useradd -m -u 1000 flaskuser && chown -R flaskuser:flaskuser /app
USER flaskuser

# 暴露端口
EXPOSE 5000

# 启动应用
CMD ["python", "app.py"]