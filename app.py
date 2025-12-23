from flask import Flask, jsonify

app = Flask(__name__)

class Calculator:
    def add(self, a, b):
        return a + b
    
    def subtract(self, a, b):
        return a - b
    
    def multiply(self, a, b):
        return a * b
    
    def divide(self, a, b):
        if b == 0:
            raise ZeroDivisionError("Division by zero")
        return a / b

calc = Calculator()

@app.route('/')
def hello_world():
    return f"Hello, world"

@app.route('/health')
def health_check():
    return jsonify({"status": "healthy"}), 200

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
    except ZeroDivisionError:
        return "Cannot divide by zero", 400

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)