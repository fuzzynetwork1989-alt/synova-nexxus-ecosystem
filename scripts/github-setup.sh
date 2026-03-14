#!/bin/bash

# GitHub Repository Setup Script for Synova Nexxus Ecosystem

set -e

echo "🚀 Setting up GitHub repository for Synova Nexxus Ecosystem..."

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

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI (gh) is not installed. Please install it first:"
    echo "  brew install gh  # macOS"
    echo "  winget install GitHub.cli  # Windows"
    echo "  Or visit: https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    print_step "GitHub authentication required..."
    echo "Please run: gh auth login"
    exit 1
fi

print_step "Creating GitHub repository..."

# Create repository (you'll need to replace with your actual repo name)
REPO_NAME="synova-nexxus-ecosystem"

# Create private repository
gh repo create $REPO_NAME --private --description "Complete Synova Nexxus Ecosystem - AI-powered application development platform" --clone=false

if [ $? -eq 0 ]; then
    print_success "Repository created: https://github.com/your-username/$REPO_NAME"
else
    print_error "Failed to create repository"
    exit 1
fi

print_step "Adding remote and pushing..."

# Add remote (replace with your actual username)
git remote add origin https://github.com/your-username/$REPO_NAME.git

# Push to GitHub
git push -u origin main

if [ $? -eq 0 ]; then
    print_success "Repository pushed to GitHub successfully!"
    echo ""
    echo "🔗 Repository URL: https://github.com/your-username/$REPO_NAME"
    echo "📋 Next steps:"
    echo "   1. Visit repository and verify files"
    echo "   2. Set up GitHub Pages if needed"
    echo "   3. Add collaborators to your team"
    echo "   4. Set up branch protection rules"
    echo ""
    echo "🎉 Your Synova Nexxus Ecosystem is now on GitHub!"
else
    print_error "Failed to push to GitHub"
    exit 1
fi
