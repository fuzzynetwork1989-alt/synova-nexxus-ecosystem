#!/bin/bash

# Synova Workspace Setup Script
# This script creates a complete workspace structure for the Synova Nexxus Ecosystem

set -e

echo "🗂️ Setting up Synova Workspace..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${YELLOW}📋 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Create workspace directory
print_step "Creating workspace directory..."
mkdir -p synova-workspace
cd synova-workspace

# Create subdirectories
print_step "Creating directory structure..."
mkdir -p packages scripts docs data/{postgres,redis,logs}

# Move all packages to workspace
print_step "Moving packages to workspace..."
if [ -d "../synova-app-template" ]; then
    mv ../synova-app-template packages/
    print_success "Moved synova-app-template"
fi

if [ -d "../synova-core-api" ]; then
    mv ../synova-core-api packages/
    print_success "Moved synova-core-api"
fi

if [ -d "../synova-research-pipeline" ]; then
    mv ../synova-research-pipeline packages/
    print_success "Moved synova-research-pipeline"
fi

if [ -d "../synova-nexxus" ]; then
    mv ../synova-nexxus packages/
    print_success "Moved synova-nexxus"
fi

if [ -d "../synova-packages-supanova-sdk" ]; then
    mv ../synova-packages-supanova-sdk packages/
    print_success "Moved synova-packages-supanova-sdk"
fi

if [ -d "../synova-packages-ui" ]; then
    mv ../synova-packages-ui packages/
    print_success "Moved synova-packages-ui"
fi

if [ -d "../synova-automation" ]; then
    mv ../synova-automation packages/
    print_success "Moved synova-automation"
fi

if [ -d "../synova-app-task-manager" ]; then
    mv ../synova-app-task-manager packages/
    print_success "Moved synova-app-task-manager"
fi

# Move scripts and documentation
print_step "Moving scripts and documentation..."
if [ -d "../scripts" ]; then
    mv ../scripts scripts/
    print_success "Moved scripts"
fi

if [ -d "../docker-compose.yml" ]; then
    mv ../docker-compose.yml .
    print_success "Moved docker-compose.yml"
fi

if [ -d "../README.md" ]; then
    mv ../README.md .
    print_success "Moved README.md"
fi

if [ -d "../DEPLOYMENT_GUIDE.md" ]; then
    mv ../DEPLOYMENT_GUIDE.md docs/
    print_success "Moved DEPLOYMENT_GUIDE.md"
fi

if [ -d "../QUICK_START.md" ]; then
    mv ../QUICK_START.md docs/
    print_success "Moved QUICK_START.md"
fi

if [ -d "../FIX_TYPESCRIPT.md" ]; then
    mv ../FIX_TYPESCRIPT.md docs/
    print_success "Moved FIX_TYPESCRIPT.md"
fi

if [ -d "../INSTALLATION_COMPLETE.md" ]; then
    mv ../INSTALLATION_COMPLETE.md docs/
    print_success "Moved INSTALLATION_COMPLETE.md"
fi

# Create shared environment file
print_step "Creating shared environment..."
cat > .env << 'EOF'
# Shared environment variables
NODE_ENV=development
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=synova_workspace
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password
REDIS_HOST=localhost
REDIS_PORT=6379
EOF

print_success "Shared environment created"

# Create workspace README
print_step "Creating workspace README..."
cat > README.md << 'EOF'
# 🗂️ Synova Nexxus Workspace

Complete workspace for the Synova Nexxus Ecosystem.

## 📁 Structure
\`\`\`
├── packages/           # All ecosystem packages
├── scripts/           # Setup and utility scripts
├── docs/              # Documentation and guides
├── data/              # Local development data
├── docker-compose.yml   # Complete containerized setup
├── .env               # Shared environment
└── README.md          # This file
\`\`\`

## 🚀 Getting Started

1. **Complete Setup**: Run \`./scripts/setup-workspace.sh\`
2. **Install Dependencies**: Run \`./scripts/install-all.sh\`
3. **Start Services**: \`docker-compose up -d\` or \`./scripts/start-all.sh\`
4. **Develop**: Work in \`packages/\` directory

## 📚 Documentation

- \`docs/DEPLOYMENT_GUIDE.md\` - Production deployment
- \`docs/QUICK_START.md\` - Quick start guide
- \`docs/FIX_TYPESCRIPT.md\` - TypeScript troubleshooting
- \`docs/INSTALLATION_COMPLETE.md\` - Installation summary

## 🔧 Development Workflow

\`\`\`bash
# Start all services
docker-compose up -d

# Or start individually
./scripts/start-all.sh

# Work on packages
cd packages/synova-core-api
npm run dev
\`\`\`

## 🎯 Benefits of Workspace

### ✅ Organization
- All packages in one location
- Shared configuration and scripts
- Easy dependency management
- Consistent development environment

### ✅ Productivity
- Quick context switching between projects
- Unified testing and building
- Simplified deployment process
- Shared documentation and knowledge base

### ✅ Collaboration
- Single source of truth for team
- Easy onboarding for new developers
- Consistent tooling and workflows
- Shared documentation and knowledge base

## 🚀 Ready to Use

The workspace structure is now ready for organized development of the entire Synova Nexxus Ecosystem!

**Next Steps:**
1. Run the complete setup script
2. Install any remaining dependencies
3. Start development services
4. Begin building your AI-powered applications

---

**🎉 Your organized Synova workspace awaits!** 🗂️
EOF

print_success "Workspace README created"

# Create setup script
print_step "Creating setup script..."
cat > scripts/setup-workspace.sh << 'EOF'
#!/bin/bash

echo "🗂️ Setting up Synova Workspace..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${YELLOW}📋 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Create workspace directory
print_step "Creating workspace directory..."
mkdir -p synova-workspace
cd synova-workspace

# Create subdirectories
print_step "Creating directory structure..."
mkdir -p packages scripts docs data/{postgres,redis,logs}

# Move all packages to workspace
print_step "Moving packages to workspace..."
if [ -d "../synova-app-template" ]; then
    mv ../synova-app-template packages/
    print_success "Moved synova-app-template"
fi

if [ -d "../synova-core-api" ]; then
    mv ../synova-core-api packages/
    print_success "Moved synova-core-api"
fi

if [ -d "../synova-research-pipeline" ]; then
    mv ../synova-research-pipeline packages/
    print_success "Moved synova-research-pipeline"
fi

if [ -d "../synova-nexxus" ]; then
    mv ../synova-nexxus packages/
    print_success "Moved synova-nexxus"
fi

if [ -d "../synova-packages-supanova-sdk" ]; then
    mv ../synova-packages-supanova-sdk packages/
    print_success "Moved synova-packages-supanova-sdk"
fi

if [ -d "../synova-packages-ui" ]; then
    mv ../synova-packages-ui packages/
    print_success "Moved synova-packages-ui"
fi

if [ -d "../synova-automation" ]; then
    mv ../synova-automation packages/
    print_success "Moved synova-automation"
fi

if [ -d "../synova-app-task-manager" ]; then
    mv ../synova-app-task-manager packages/
    print_success "Moved synova-app-task-manager"
fi

# Move scripts and documentation
print_step "Moving scripts and documentation..."
if [ -d "../scripts" ]; then
    mv ../scripts scripts/
    print_success "Moved scripts"
fi

if [ -d "../docker-compose.yml" ]; then
    mv ../docker-compose.yml .
    print_success "Moved docker-compose.yml"
fi

if [ -d "../README.md" ]; then
    mv ../README.md .
    print_success "Moved README.md"
fi

if [ -d "../DEPLOYMENT_GUIDE.md" ]; then
    mv ../DEPLOYMENT_GUIDE.md docs/
    print_success "Moved DEPLOYMENT_GUIDE.md"
fi

if [ -d "../QUICK_START.md" ]; then
    mv ../QUICK_START.md docs/
    print_success "Moved QUICK_START.md"
fi

if [ -d "../FIX_TYPESCRIPT.md" ]; then
    mv ../FIX_TYPESCRIPT.md docs/
    print_success "Moved FIX_TYPESCRIPT.md"
fi

if [ -d "../INSTALLATION_COMPLETE.md" ]; then
    mv ../INSTALLATION_COMPLETE.md docs/
    print_success "Moved INSTALLATION_COMPLETE.md"
fi

# Create shared environment file
print_step "Creating shared environment..."
cat > .env << 'EOF'
# Shared environment variables
NODE_ENV=development
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=synova_workspace
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password
REDIS_HOST=localhost
REDIS_PORT=6379
EOF

print_success "Shared environment created"

# Create workspace README
print_step "Creating workspace README..."
cat > README.md << 'EOF'
# 🗂️ Synova Nexxus Workspace

Complete workspace for the Synova Nexxus Ecosystem.

## 📁 Structure
\`\`\`
├── packages/           # All ecosystem packages
├── scripts/           # Setup and utility scripts
├── docs/              # Documentation and guides
├── data/              # Local development data
├── docker-compose.yml   # Complete containerized setup
├── .env               # Shared environment
└── README.md          # This file
\`\`\`

## 🚀 Getting Started

1. **Complete Setup**: Run \`./scripts/setup-workspace.sh\`
2. **Install Dependencies**: Run \`./scripts/install-all.sh\`
3. **Start Services**: \`docker-compose up -d\` or \`./scripts/start-all.sh\`
4. **Develop**: Work in \`packages/\` directory

## 📚 Documentation

- \`docs/DEPLOYMENT_GUIDE.md\` - Production deployment
- \`docs/QUICK_START.md\` - Quick start guide
- \`docs/FIX_TYPESCRIPT.md\` - TypeScript troubleshooting
- \`docs/INSTALLATION_COMPLETE.md\` - Installation summary

## 🔧 Development Workflow

\`\`\`bash
# Start all services
docker-compose up -d

# Or start individually
./scripts/start-all.sh

# Work on packages
cd packages/synova-core-api
npm run dev
\`\`\`

## 🎯 Benefits of Workspace

### ✅ Organization
- All packages in one location
- Shared configuration and scripts
- Easy dependency management
- Consistent development environment

### ✅ Productivity
- Quick context switching between projects
- Unified testing and building
- Simplified deployment process
- Shared documentation and knowledge base

### ✅ Collaboration
- Single source of truth for team
- Easy onboarding for new developers
- Consistent tooling and workflows
- Shared documentation and knowledge base

## 🚀 Ready to Use

The workspace structure is now ready for organized development of the entire Synova Nexxus Ecosystem!

**Next Steps:**
1. Run the complete setup script
2. Install any remaining dependencies
3. Start development services
4. Begin building your AI-powered applications

---

**🎉 Your organized Synova workspace awaits!** 🗂️
EOF

print_success "Setup script created"

# Make executable
chmod +x scripts/setup-workspace.sh

print_success "Workspace setup complete!"
echo ""
echo "🎉 Synova Workspace Setup Complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Run: ./scripts/setup-workspace.sh"
echo "   2. Install: ./scripts/install-all.sh"
echo "   3. Start: docker-compose up -d"
echo "   4. Develop: Work in packages/ directory"
echo ""
echo "🚀 Your organized Synova workspace awaits!"
