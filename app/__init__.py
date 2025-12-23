from flask import Flask, jsonify
from entity.calculator import Calculator

app = Flask(__name__)
calc = Calculator()

@app.route('/')
def hello_world():
    return f"Hello, world from {app.config.get('COLOR', 'unknown')}"

@app.route('/health')
def health_check():
    return jsonify({"status": "healthy", "version": app.config.get('COLOR', 'unknown')}), 200

@app.route("/add/<int:a>&<int:b>")
def add(a, b):
    return f"Add {a} and {b}. Got {calc.add(a, b)}!"

@app.route("/multiply/<int:a>&<int:b>")
def multiply(a, b):
    return f"Multiply {a} and {b}. Got {calc.multiply(a, b)}!"

@app.route("/subtract/<int:a>&<int:b>")
def subtract(a, b):
    return f"Subtract {a} and {b}. Got {calc.subtract(a, b)}!"

@app.route("/divide/<int:a>&<int:b>")
def divide(a, b):
    try:
        result = calc.divide(a, b)
        return f"Divide {a} and {b}. Got {result}!"
    except ValueError as e:
        return str(e), 400

@app.route('/switch/<version>')
def switch_version(version):
    if version in ['blue', 'green']:
        # 这里可以记录切换日志或更新配置
        return f"Switched to {version} version"
    return "Invalid version", 400

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)