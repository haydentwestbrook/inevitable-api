.PHONY: help install test test-cov clean build run docker-build docker-run docker-stop deploy-vercel

# Variables
PYTHON := python
VENV := venv
PIP := $(VENV)/Scripts/pip
PYTEST := $(VENV)/Scripts/pytest
UVICORN := $(VENV)/Scripts/uvicorn

help:
	@echo "Available commands:"
	@echo "  make install        - Create virtual environment and install dependencies"
	@echo "  make test          - Run all tests"
	@echo "  make test-cov      - Run tests with coverage report"
	@echo "  make clean         - Remove virtual environment and cache files"
	@echo "  make build         - Build the application"
	@echo "  make run           - Run the development server"
	@echo "  make docker-build  - Build Docker image"
	@echo "  make docker-run    - Run Docker container"
	@echo "  make docker-stop   - Stop Docker container"
	@echo "  make deploy-vercel - Deploy to Vercel"

install:
	@echo "Creating virtual environment..."
	$(PYTHON) -m venv $(VENV)
	@echo "Installing dependencies..."
	$(PIP) install -r requirements.txt
	$(PIP) install pytest pytest-cov pytest-asyncio

test:
	@echo "Running tests..."
	$(PYTEST) tests/

test-cov:
	@echo "Running tests with coverage..."
	$(PYTEST) --cov=app tests/ --cov-report=term-missing --cov-report=html

clean:
	@echo "Cleaning up..."
	rm -rf $(VENV)
	rm -rf __pycache__
	rm -rf .pytest_cache
	rm -rf .coverage
	rm -rf htmlcov
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

build:
	@echo "Building application..."
	$(PYTHON) -m pip install --upgrade pip
	$(PIP) install -r requirements.txt

run:
	@echo "Starting development server..."
	$(UVICORN) app.main:app --reload

docker-build:
	@echo "Building Docker image..."
	docker build -t inevitable-api .

docker-run:
	@echo "Running Docker container..."
	docker run -d -p 8000:8000 --name inevitable-api inevitable-api

docker-stop:
	@echo "Stopping Docker container..."
	docker stop inevitable-api
	docker rm inevitable-api

deploy-vercel:
	@echo "Deploying to Vercel..."
	vercel --prod 