# Deployment Guide

## 🚀 Deployment Overview

This guide covers deploying Synova AI applications with Supanova integration to various environments.

## 📋 Prerequisites

### Required Accounts & Services
- **GitHub**: Repository hosting and CI/CD
- **Vercel/Railway**: Application hosting
- **PostgreSQL**: Database (can use managed service)
- **Redis**: Caching and session storage
- **Domain**: Custom domain (optional)

### Environment Configuration
- Node.js 18+
- Docker (optional for containerized deployment)
- GitHub CLI for automation

## 🏗️ Deployment Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   GitHub Repo   │───▶│  CI/CD Pipeline  │───▶│  Production     │
│                 │    │                 │    │                 │
│ • Source Code   │    │ • Build & Test  │    │ • App Server    │
│ • Configs       │    │ • Security Scan │    │ • Database      │
│ • Assets        │    │ • Deploy        │    │ • Cache         │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🔧 Environment Setup

### 1. Production Environment Variables

Create `.env.production` with:

```bash
# App Configuration
NODE_ENV=production
APP_NAME=Your App Name
APP_VERSION=1.0.0

# Supanova Configuration
SUPANOVA_ENABLED=true
SUPANOVA_API_URL=https://your-api.com/api/supanova
SUPANOVA_API_KEY=prod-api-key-here

# Database
DATABASE_URL=postgresql://user:pass@host:5432/prod_db
REDIS_URL=redis://user:pass@host:6379

# Security
JWT_SECRET=super-secure-jwt-secret
SESSION_SECRET=super-secure-session-secret

# Monitoring
SENTRY_DSN=your-sentry-dsn
LOG_LEVEL=error

# Feature Flags
FEATURE_ADVANCED_AI=true
FEATURE_BETA_FEATURES=false
```

### 2. Database Setup

#### PostgreSQL
```sql
-- Create database
CREATE DATABASE your_app_prod;

-- Create user
CREATE USER your_app_user WITH PASSWORD 'secure_password';

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE your_app_prod TO your_app_user;

-- Run migrations
npm run migrate:prod
```

#### Redis Configuration
```bash
# Redis configuration
maxmemory 256mb
maxmemory-policy allkeys-lru
save 900 1
save 300 10
save 60 10000
```

## 🌐 Deployment Options

### Option 1: Vercel (Recommended for Next.js)

#### Setup
1. Install Vercel CLI
```bash
npm i -g vercel
```

2. Login to Vercel
```bash
vercel login
```

3. Deploy project
```bash
vercel --prod
```

#### Configuration
Create `vercel.json`:
```json
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/next"
    }
  ],
  "env": {
    "DATABASE_URL": "@database_url",
    "REDIS_URL": "@redis_url",
    "JWT_SECRET": "@jwt_secret"
  },
  "functions": {
    "pages/api/**/*.js": {
      "maxDuration": 30
    }
  }
}
```

#### Environment Variables in Vercel
```bash
# Add environment variables
vercel env add DATABASE_URL production
vercel env add REDIS_URL production
vercel env add JWT_SECRET production
```

### Option 2: Railway (Full-Stack)

#### Setup
1. Install Railway CLI
```bash
npm install -g @railway/cli
```

2. Login
```bash
railway login
```

3. Initialize project
```bash
railway init
```

4. Add services
```bash
railway add postgresql
railway add redis
```

#### Configuration
Create `railway.toml`:
```toml
[build]
builder = "nixpacks"

[deploy]
healthcheckPath = "/api/health"
healthcheckTimeout = 100
restartPolicyType = "on_failure"
restartPolicyMaxRetries = 10

[[services]]
name = "app"

[services.variables]
NODE_ENV = "production"
PORT = "3000"
```

### Option 3: Docker Deployment

#### Dockerfile
```dockerfile
FROM node:18-alpine AS base

# Install dependencies only when needed
FROM base AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --only=production

# Build the application
FROM base AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production image
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/package.json ./package.json

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["npm", "start"]
```

#### Docker Compose
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://postgres:password@db:5432/app
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  db:
    image: postgres:15
    environment:
      - POSTGRES_DB=app
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

## 🔒 Security Configuration

### SSL/TLS Setup
```bash
# Generate SSL certificate (Let's Encrypt)
certbot --nginx -d yourdomain.com
```

### Firewall Rules
```bash
# Allow only necessary ports
ufw allow 22    # SSH
ufw allow 80    # HTTP
ufw allow 443   # HTTPS
ufw enable
```

### Security Headers
Add to `next.config.js`:
```javascript
const securityHeaders = [
  {
    key: 'X-DNS-Prefetch-Control',
    value: 'on'
  },
  {
    key: 'Strict-Transport-Security',
    value: 'max-age=63072000; includeSubDomains; preload'
  },
  {
    key: 'X-XSS-Protection',
    value: '1; mode=block'
  },
  {
    key: 'X-Frame-Options',
    value: 'DENY'
  },
  {
    key: 'X-Content-Type-Options',
    value: 'nosniff'
  }
];

module.exports = {
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: securityHeaders,
      },
    ];
  },
};
```

## 📊 Monitoring & Logging

### Sentry Integration
```javascript
// sentry.client.config.js
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 1.0,
});
```

### Health Check Endpoint
```typescript
// pages/api/health.ts
export default function handler(req, res) {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: process.env.APP_VERSION,
    supanova: {
      enabled: process.env.SUPANOVA_ENABLED === 'true',
      api_url: process.env.SUPANOVA_API_URL,
    },
  });
}
```

### Performance Monitoring
```javascript
// lib/monitoring.ts
export const performanceMonitor = {
  trackPageView: (url: string) => {
    // Track page views
  },
  
  trackToolExecution: (tool: string, duration: number) => {
    // Track tool performance
  },
  
  trackError: (error: Error, context: any) => {
    // Track errors
  },
};
```

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow
```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run tests
      run: npm test
    
    - name: Build application
      run: npm run build
    
    - name: Deploy to Vercel
      uses: amondnet/vercel-action@v20
      with:
        vercel-token: ${{ secrets.VERCEL_TOKEN }}
        vercel-org-id: ${{ secrets.ORG_ID }}
        vercel-project-id: ${{ secrets.PROJECT_ID }}
        vercel-args: '--prod'
```

### Environment Management
```bash
# Development
npm run dev

# Staging
npm run build
npm run start

# Production
npm run build:prod
npm run start:prod
```

## 🚨 Rollback Procedures

### Quick Rollback
```bash
# Vercel rollback
vercel rollback

# Railway rollback
railway rollback

# Docker rollback
docker-compose down
docker-compose up -d --force-recreate
```

### Database Rollback
```bash
# Run migration rollback
npm run migrate:rollback

# Restore from backup
pg_restore -h host -U user -d database backup.sql
```

## 📈 Performance Optimization

### Caching Strategy
```typescript
// lib/cache.ts
import Redis from 'ioredis';

const redis = new Redis(process.env.REDIS_URL);

export const cache = {
  get: async (key: string) => {
    return await redis.get(key);
  },
  
  set: async (key: string, value: any, ttl: number = 3600) => {
    return await redis.setex(key, ttl, JSON.stringify(value));
  },
  
  del: async (key: string) => {
    return await redis.del(key);
  },
};
```

### CDN Configuration
```javascript
// next.config.js
module.exports = {
  images: {
    domains: ['your-cdn-domain.com'],
  },
  assetPrefix: process.env.NODE_ENV === 'production' 
    ? 'https://your-cdn-domain.com' 
    : '',
};
```

## 🔧 Troubleshooting

### Common Issues

#### Build Failures
```bash
# Clear build cache
rm -rf .next
npm run build

# Check for memory issues
node --max-old-space-size=4096 node_modules/.bin/next build
```

#### Database Connection Issues
```bash
# Test database connection
psql $DATABASE_URL

# Check connection pool
npm run db:test-connection
```

#### Supanova Integration Issues
```bash
# Test Supanova connection
curl -H "Authorization: Bearer $SUPANOVA_API_KEY" \
     $SUPANOVA_API_URL/health

# Check tool permissions
npm run supanova:test-permissions
```

### Debug Mode
```bash
# Enable debug logging
DEBUG=supanova:* npm run dev

# Run with verbose output
npm run dev -- --verbose
```

## 📋 Deployment Checklist

### Pre-Deployment
- [ ] All tests passing
- [ ] Security scans completed
- [ ] Environment variables configured
- [ ] Database migrations applied
- [ ] Backup strategy in place

### Post-Deployment
- [ ] Health checks passing
- [ ] Monitoring configured
- [ ] Performance metrics collected
- [ ] Error tracking active
- [ ] Rollback plan tested

### Security Verification
- [ ] SSL certificate valid
- [ ] Security headers configured
- [ ] Rate limiting active
- [ ] Access controls verified
- [ ] Audit logging enabled

---

This deployment guide provides comprehensive instructions for deploying Synova AI applications to production environments. Always test deployments in a staging environment before applying to production.
