import pytest
import os
from typing import Generator
from fastapi.testclient import TestClient
from app.main import app
from app.config import Settings

@pytest.fixture(scope="session")
def test_settings() -> Settings:
    """Override settings for testing"""
    return Settings(
        SECRET_KEY="test-secret-key",
        ACCESS_TOKEN_EXPIRE_MINUTES=30,
        BACKEND_CORS_ORIGINS=["http://localhost:3000"],
        GOOGLE_CLIENT_ID="test-client-id",
        GOOGLE_CLIENT_SECRET="test-client-secret",
        GOOGLE_REDIRECT_URI="http://localhost:8000/api/v1/auth/google/callback"
    )

@pytest.fixture(scope="session")
def client() -> Generator:
    """Create a test client"""
    with TestClient(app) as test_client:
        yield test_client

@pytest.fixture(autouse=True)
def setup_test_environment():
    """Setup test environment variables"""
    os.environ["TESTING"] = "1"
    yield
    os.environ.pop("TESTING", None) 