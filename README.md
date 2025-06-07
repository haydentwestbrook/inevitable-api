# Inevitable API

This is a FastAPI-based API project.

## Setup

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

### Local Development

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
docker build -t inevitable-api .
```

2. Run the production container:
```bash
docker run -d -p 8000:8000 --name inevitable-api inevitable-api
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
vercel
```

4. For production deployment:
```bash
vercel --prod
```

Note: For production deployment, make sure to:
- Set up proper environment variables in Vercel dashboard
- Configure a production database
- Set up proper SSL/TLS
- Configure proper security settings 