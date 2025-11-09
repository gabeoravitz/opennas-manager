# OpenNAS Manager - Quick Start Guide

## 🚀 Getting Started (Mac Development → Linux Production)

This guide helps you set up OpenNAS Manager on your Mac for development, with deployment instructions for Linux production servers.

### Prerequisites

**Mac (Development):**
- macOS 10.15+
- Node.js 18+ ([Download](https://nodejs.org/))
- Docker Desktop for Mac ([Download](https://www.docker.com/products/docker-desktop))
- Python 3.8+ (pre-installed on macOS)

**Linux (Production):**
- Ubuntu 20.04+ / Debian 11+ / RHEL 8+
- Docker & Docker Compose
- Node.js 18+

## Development Setup (Mac)

### 1. Install Dependencies

```bash
cd opennas-manager

# Install root dependencies
npm install

# Install frontend dependencies
cd frontend && npm install && cd ..

# Install backend dependencies
cd backend && npm install && cd ..

# Install E2E test dependencies
cd e2e && npm install && cd ..
```

### 2. Start Development Environment

```bash
# Start PostgreSQL and Redis with Docker
docker-compose up -d

# Wait for services to be ready (about 10 seconds)
sleep 10

# Start development servers (frontend + backend)
npm run dev
```

The application will be available at:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:3001
- **API Docs**: http://localhost:3001/api/docs

### 3. Login

Default credentials:
- **Username**: `admin`
- **Password**: `admin123`

## Project Structure

```
opennas-manager/
├── backend/              # NestJS API server
│   ├── src/
│   │   ├── modules/     # Feature modules (auth, users, files, etc.)
│   │   ├── common/      # Shared utilities
│   │   └── main.ts      # Application entry point
│   └── package.json
├── frontend/             # React SPA
│   ├── src/
│   │   ├── components/  # UI components
│   │   ├── pages/       # Application pages
│   │   ├── store/       # State management
│   │   └── main.tsx     # Application entry point
│   └── package.json
├── e2e/                  # Playwright E2E tests
├── docs/                 # Documentation
├── docker/               # Docker configurations
└── docker-compose.yml    # Development environment
```

## Development Workflow

### Running Tests

```bash
# All tests
npm test

# Backend tests only
cd backend && npm test

# Frontend tests only
cd frontend && npm test

# E2E tests
cd e2e && npm test

# E2E tests with UI
cd e2e && npm run test:ui
```

### Linting & Formatting

```bash
# Lint all code
npm run lint

# Fix linting issues
npm run lint:fix

# Format code
npm run format
```

### Building for Production

```bash
# Build both frontend and backend
npm run build

# Build individually
cd frontend && npm run build
cd backend && npm run build
```

## Production Deployment (Linux)

### Option 1: Docker Compose (Recommended)

```bash
# On your Linux server
git clone <repository-url>
cd opennas-manager

# Create production environment file
cp backend/.env.example .env

# Edit .env with production values
nano .env

# Build and start production containers
docker-compose -f docker-compose.prod.yml up -d

# Check logs
docker-compose -f docker-compose.prod.yml logs -f
```

The application will be available at http://your-server-ip

### Option 2: Manual Deployment

```bash
# Install Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PostgreSQL
sudo apt-get install postgresql postgresql-contrib

# Clone and build
git clone <repository-url>
cd opennas-manager
npm install
npm run build

# Start backend
cd backend
NODE_ENV=production node dist/main.js &

# Serve frontend with nginx
sudo apt-get install nginx
sudo cp frontend/dist/* /var/www/html/
```

## Environment Variables

### Backend (.env)

```bash
NODE_ENV=production
PORT=3001

# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=opennas
DATABASE_USER=opennas
DATABASE_PASSWORD=<strong-password>

# JWT
JWT_SECRET=<generate-strong-secret>
JWT_EXPIRATION=24h

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# Frontend URL
FRONTEND_URL=http://your-domain.com
```

### Frontend (.env)

```bash
VITE_API_URL=http://your-domain.com/api
VITE_WS_URL=ws://your-domain.com
```

## Troubleshooting

### Port Already in Use

```bash
# Find process using port 3000 or 3001
lsof -ti:3000
lsof -ti:3001

# Kill the process
kill -9 <PID>
```

### Docker Issues on Mac

```bash
# Reset Docker
docker-compose down -v
docker system prune -a

# Restart Docker Desktop
```

### Database Connection Failed

```bash
# Check PostgreSQL is running
docker ps | grep postgres

# Check logs
docker logs opennas-postgres

# Restart database
docker-compose restart postgres
```

### Frontend Build Errors

```bash
# Clear cache and rebuild
cd frontend
rm -rf node_modules dist .vite
npm install
npm run build
```

## Performance Optimization

### Mac Development

```bash
# Increase Docker resources
# Docker Desktop → Preferences → Resources
# - CPUs: 4+
# - Memory: 8GB+
# - Swap: 2GB+
```

### Linux Production

```bash
# Enable production optimizations
export NODE_ENV=production

# Use PM2 for process management
npm install -g pm2
pm2 start backend/dist/main.js --name opennas-backend
pm2 startup
pm2 save
```

## Security Checklist

Before deploying to production:

- [ ] Change default admin password
- [ ] Generate strong JWT_SECRET
- [ ] Use strong database passwords
- [ ] Enable HTTPS with SSL certificates
- [ ] Configure firewall rules
- [ ] Enable rate limiting
- [ ] Set up regular backups
- [ ] Review security settings in Security Advisor

## Monitoring

### Development

```bash
# View logs
docker-compose logs -f

# Monitor resources
docker stats
```

### Production

```bash
# System logs
journalctl -u opennas -f

# Application logs
pm2 logs opennas-backend

# Database logs
sudo tail -f /var/log/postgresql/postgresql-*.log
```

## Updating

```bash
# Pull latest changes
git pull origin main

# Install dependencies
npm install

# Rebuild
npm run build

# Restart services
docker-compose restart  # Development
pm2 restart all         # Production
```

## Getting Help

- **Documentation**: See `docs/` directory
- **API Reference**: http://localhost:3001/api/docs
- **Issues**: Open an issue on GitHub
- **Community**: Join our Discord/Slack

## Next Steps

1. ✅ Complete setup following this guide
2. 📖 Read `docs/FEATURE_MAPPING.md` for feature overview
3. 🎨 Review `docs/DESIGN_SPEC.md` for UI guidelines
4. 🧪 Run tests with `npm test`
5. 🚀 Deploy to production following deployment guide

---

**Built with ❤️ for the open-source community**
