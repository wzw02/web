FROM python:3.9-slim

WORKDIR /app

# 复制依赖文件
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY app/ .

# 创建非root用户
RUN useradd -m -u 1000 flaskuser && chown -R flaskuser:flaskuser /app
USER flaskuser

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import requests; r = requests.get('http://localhost:5000/health'); exit(0 if r.status_code == 200 else 1)"

# 暴露端口
EXPOSE 5000

# 启动应用
CMD ["python", "app.py"]