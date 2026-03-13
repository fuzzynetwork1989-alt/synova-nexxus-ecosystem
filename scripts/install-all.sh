#!/bin/bash

# Install dependencies for all Synova Nexxus Ecosystem packages

set -e

echo "📦 Installing dependencies for all Synova packages..."

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

# List of all packages
PACKAGES=(
    "synova-nexxus"
    "synova-packages-supanova-sdk"
    "synova-packages-ui"
    "synova-app-template"
    "synova-app-task-manager"
    "synova-automation"
)

# Install dependencies for each package
for package in "${PACKAGES[@]}"; do
    if [ -d "packages/$package" ]; then
        print_step "Installing dependencies for $package..."
        
        cd "packages/$package"
        
        # Check if package.json exists
        if [ -f "package.json" ]; then
            # Install dependencies
            npm install
            
            if [ $? -eq 0 ]; then
                print_success "Dependencies installed for $package"
            else
                print_error "Failed to install dependencies for $package"
                exit 1
            fi
        else
            print_error "package.json not found in packages/$package"
            exit 1
        fi
        
        cd ../..
    else
        print_error "Package directory packages/$package not found"
        exit 1
    fi
done

echo ""
echo "🎉 All remaining dependencies installed successfully!"
echo ""
echo "📋 Next steps:"
echo "   1. Start development servers:"
echo "      - synova-nexxus: cd packages/synova-nexxus && npm run dev"
echo "   2. Build packages:"
echo "      - Supanova SDK: cd packages/synova-packages-supanova-sdk && npm run build"
echo "      - UI Components: cd packages/synova-packages-ui && npm run build"
echo "   3. Set up databases and test services"
echo ""
