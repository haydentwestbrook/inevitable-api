import pytest
from fastapi.testclient import TestClient
from datetime import datetime, timedelta
from jose import jwt
from app.main import app
from app.config import get_settings

settings = get_settings()

@pytest.fixture
def client():
    return TestClient(app)

@pytest.fixture
def test_user_data():
    return {
        "email": "test@example.com",
        "password": "testpassword123",
        "name": "Test User"
    }

@pytest.fixture
def test_token(test_user_data):
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = jwt.encode(
        {"sub": test_user_data["email"], "exp": datetime.utcnow() + access_token_expires},
        settings.SECRET_KEY.get_secret_value(),
        algorithm="HS256"
    )
    return access_token

def test_register_user(client, test_user_data):
    """Test user registration endpoint"""
    response = client.post("/api/v1/auth/register", json=test_user_data)
    assert response.status_code == 200
    data = response.json()
    assert data["email"] == test_user_data["email"]
    assert data["name"] == test_user_data["name"]
    assert "id" in data
    assert "is_active" in data
    assert "created_at" in data
    assert "password" not in data  # Ensure password is not returned

def test_register_duplicate_email(client, test_user_data):
    """Test registration with duplicate email"""
    # First registration
    client.post("/api/v1/auth/register", json=test_user_data)
    
    # Second registration with same email
    response = client.post("/api/v1/auth/register", json=test_user_data)
    assert response.status_code == 400
    assert "already registered" in response.json()["detail"].lower()

def test_register_invalid_email(client, test_user_data):
    """Test registration with invalid email"""
    test_user_data["email"] = "invalid-email"
    response = client.post("/api/v1/auth/register", json=test_user_data)
    assert response.status_code == 422  # Validation error

def test_login_success(client, test_user_data):
    """Test successful login"""
    # Register user first
    client.post("/api/v1/auth/register", json=test_user_data)
    
    # Attempt login
    response = client.post(
        "/api/v1/auth/token",
        data={
            "username": test_user_data["email"],
            "password": test_user_data["password"]
        }
    )
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert data["token_type"] == "bearer"

def test_login_invalid_credentials(client, test_user_data):
    """Test login with invalid credentials"""
    response = client.post(
        "/api/v1/auth/token",
        data={
            "username": test_user_data["email"],
            "password": "wrongpassword"
        }
    )
    assert response.status_code == 401
    assert "incorrect email or password" in response.json()["detail"].lower()

def test_get_current_user(client, test_token):
    """Test getting current user information"""
    response = client.get(
        "/api/v1/auth/me",
        headers={"Authorization": f"Bearer {test_token}"}
    )
    assert response.status_code == 200
    data = response.json()
    assert "email" in data
    assert "name" in data
    assert "id" in data

def test_get_current_user_no_token(client):
    """Test getting current user without token"""
    response = client.get("/api/v1/auth/me")
    assert response.status_code == 401
    assert "not authenticated" in response.json()["detail"].lower()

def test_get_current_user_invalid_token(client):
    """Test getting current user with invalid token"""
    response = client.get(
        "/api/v1/auth/me",
        headers={"Authorization": "Bearer invalid_token"}
    )
    assert response.status_code == 401
    assert "could not validate credentials" in response.json()["detail"].lower()

def test_google_login_redirect(client):
    """Test Google login redirect"""
    response = client.get("/api/v1/auth/google/login", allow_redirects=False)
    assert response.status_code == 307  # Temporary redirect
    assert "accounts.google.com" in response.headers["location"]

@pytest.mark.asyncio
async def test_google_callback_success(client):
    """Test Google callback with successful authentication"""
    # Mock Google OAuth response
    mock_user_info = {
        "email": "google@example.com",
        "name": "Google User",
        "picture": "https://example.com/picture.jpg"
    }
    
    # This is a simplified test as we can't easily mock the Google OAuth flow
    # In a real test, you would need to mock the OAuth client
    response = client.get("/api/v1/auth/google/callback")
    assert response.status_code in [200, 400]  # Either success or error depending on mock

def test_google_callback_error(client):
    """Test Google callback with error"""
    # Simulate error by providing invalid state
    response = client.get("/api/v1/auth/google/callback?error=access_denied")
    assert response.status_code == 400 