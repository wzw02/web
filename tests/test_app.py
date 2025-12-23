import pytest
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.app import app  # 现在从 app 模块导入

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_hello_world(client):
    response = client.get('/')
    assert response.status_code == 200
    assert b'Hello, world' in response.data

def test_add(client):
    response = client.get('/add/5&3')
    assert response.status_code == 200
    assert b'Add 5 and 3. Got 8!' in response.data

def test_multiply(client):
    response = client.get('/multiply/4&6')
    assert response.status_code == 200
    assert b'Multiply 4 and 6. Got 24!' in response.data

def test_subtract(client):
    response = client.get('/subtract/10&4')
    assert response.status_code == 200
    assert b'Subtract 10 and 4. Got 6!' in response.data

def test_divide(client):
    response = client.get('/divide/20&5')
    assert response.status_code == 200
    assert b'Divide 20 and 5. Got 4.0!' in response.data

def test_divide_by_zero(client):
    response = client.get('/divide/10&0')
    assert response.status_code == 500  # 或您的自定义错误处理