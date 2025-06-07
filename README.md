# Inevitable API

This is a FastAPI-based API project.

## Setup

### Quick Setup

#### Linux

1. Make the setup script executable:
```bash
chmod +x setup/setup.sh
```

2. Run the setup script:
```bash
./setup/setup.sh
```

#### Windows

1. Open PowerShell as Administrator

2. Run the setup script:
```powershell
.\setup\setup.ps1
```

The setup scripts will install the following system dependencies:
- Python 3.12
- Node.js
- Docker and Docker Compose
- Vercel CLI

### Environment Variables

Create a `.env` file in the root directory with the following variables:

```bash
# Required
SECRET_KEY=your-secure-secret-key-here  # Generate a secure key for production

# Google OAuth (Required for Google Sign-In)
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
GOOGLE_REDIRECT_URI=http://localhost:8000/api/v1/auth/google/callback

# Optional
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
BACKEND_CORS_ORIGINS=["http://localhost:3000","https://yourdomain.com"]
```

For production, make sure to:
- Generate a secure SECRET_KEY (you can use `openssl rand -hex 32`)
- Set proper CORS origins
- Configure your database URL
- Update Google OAuth credentials for production

### Setting up Google OAuth

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google+ API
4. Go to Credentials
5. Create an OAuth 2.0 Client ID
6. Add authorized redirect URIs:
   - Development: `http://localhost:8000/api/v1/auth/google/callback`
   - Production: `https://your-domain.com/api/v1/auth/google/callback`
7. Copy the Client ID and Client Secret to your `.env` file

### Development

#### Using Make Commands

1. Install dependencies and set up environment:
```bash
make install
```

2. Run the development server:
```bash
make run
```

3. Run tests:
```bash
# Run all tests
make test

# Run tests with coverage
make test-cov
```

4. Clean up:
```bash
make clean
```

5. Docker commands:
```bash
# Build Docker image
make docker-build

# Run Docker container
make docker-run

# Stop Docker container
make docker-stop
```

6. Deploy to Vercel:
```bash
make deploy-vercel
```

For a list of all available commands:
```bash
make help
```

#### Manual Setup

1. Create a virtual environment:
```bash
python -m venv venv
```

2. Activate the virtual environment:
- Windows:
```bash
.\venv\Scripts\activate
```
- Unix/MacOS:
```bash
source venv/bin/activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Run the development server:
```bash
uvicorn app.main:app --reload
```

The API will be available at http://localhost:8000
API documentation will be available at http://localhost:8000/docs

### Testing

1. Run all tests:
```bash
make test
```

2. Run tests with coverage:
```bash
make test-cov
```

### Docker Development

1. Build and start the containers:
```bash
docker-compose up --build
```

2. To run in detached mode (background):
```bash
docker-compose up -d
```

3. To stop the containers:
```bash
docker-compose down
```

4. To view logs:
```bash
docker-compose logs -f
```

### Production Deployment

#### Docker Deployment

1. Build the production Docker image:
```bash
make docker-build
```

2. Run the production container:
```bash
make docker-run
```

#### Vercel Deployment

1. Install Vercel CLI:
```bash
npm install -g vercel
```

2. Login to Vercel:
```bash
vercel login
```

3. Deploy to Vercel:
```bash
make deploy-vercel
```

Note: For production deployment, make sure to:
- Set up proper environment variables in Vercel dashboard
- Configure a production database
- Set up proper SSL/TLS
- Configure proper security settings 