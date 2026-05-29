# EduNext

EduNext is an intelligent education platform for Tawjihi students. The project has three parts:

- `Frontend`: React + Vite web app.
- `backend`: ASP.NET Core API.
- `ai_chatbot`: FastAPI AI service for chat, exam analysis, and recommendations.

## Quick Start

### 1. Backend

Requirements:

- .NET SDK 10
- PostgreSQL database

Run:

```powershell
cd backend
dotnet restore
dotnet run --launch-profile http
```

Local configuration can be set in `backend/appsettings.Development.json` or environment variables:

```powershell
$env:ConnectionStrings__DefaultConnection="Host=localhost;Port=5432;Database=edunext;Username=postgres;Password=postgres"
$env:Jwt__Key="change-this-to-a-long-secret-at-least-32-bytes"
```

### 2. Frontend

```powershell
cd Frontend
npm install
npm run dev
```

Optional local env file:

```powershell
Copy-Item .env.example .env
```

### 3. AI Chatbot

Create the AI env file once:

```powershell
Copy-Item ai_chatbot\.env.example ai_chatbot\.env
```

Put your Gemini key in `ai_chatbot/.env`:

```env
GEMINI_API_KEY=your-gemini-api-key
```

Run from the project root:

```powershell
.\start-ai.ps1 -Foreground
```

Or on Windows CMD:

```cmd
start-ai.cmd
```

The script creates `ai_chatbot/.venv`, installs `requirements.txt`, starts the API on `http://127.0.0.1:5001`, and writes request logs to:

- `ai_chatbot/chatbot.host.out.log`
- `ai_chatbot/chatbot.host.err.log`

Useful AI URLs:

- `http://127.0.0.1:5001/docs`
- `http://127.0.0.1:5001/health`

## GitHub Notes

Do not commit generated dependencies or local secrets:

- `Frontend/node_modules`
- `Frontend/dist`
- `backend/bin`
- `backend/obj`
- `ai_chatbot/.venv`
- `ai_chatbot/.python_packages`
- `.env` files
- runtime logs

If a real database password or API key was ever committed, rotate it before making the repository public.
