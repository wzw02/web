import sys
import os

# 将项目根目录添加到Python路径
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.app import app

def test_hello_world():
    """测试首页"""
    with app.test_client() as client:
        response = client.get('/')
        assert response.status_code == 200
        assert b'Hello, world' in response.data

def test_health_check():
    """测试健康检查端点"""
    with app.test_client() as client:
        response = client.get('/health')
        assert response.status_code == 200
        assert b'healthy' in response.data

def test_add():
    """测试加法"""
    with app.test_client() as client:
        response = client.get('/add/5&3')
        assert response.status_code == 200
        assert b'Add 5 and 3. Got 8!' in response.data

def test_multiply():
    """测试乘法"""
    with app.test_client() as client:
        response = client.get('/multiply/4&6')
        assert response.status_code == 200
        assert b'Multiply 4 and 6. Got 24!' in response.data

def test_subtract():
    """测试减法"""
    with app.test_client() as client:
        response = client.get('/subtract/10&4')
        assert response.status_code == 200
        assert b'Subtract 10 and 4. Got 6!' in response.data

def test_divide():
    """测试除法"""
    with app.test_client() as client:
        response = client.get('/divide/20&5')
        assert response.status_code == 200
        assert b'Divide 20 and 5. Got 4.0!' in response.data

def test_divide_by_zero():
    """测试除以零"""
    with app.test_client() as client:
        response = client.get('/divide/10&0')
        assert response.status_code == 400
        assert b'Cannot divide by zero' in response.data