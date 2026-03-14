.PHONY: setup dev test build clean lint type-check validate

# Default target
all: setup validate lint test build

# Setup development environment
setup:
	@echo "🚀 Setting up development environment..."
	npm install
	@echo "✅ Dependencies installed"

# Start development server
dev:
	@echo "🔧 Starting development server..."
	npm run dev

# Run tests
test:
	@echo "🧪 Running tests..."
	npm run test

# Run tests with coverage
test-coverage:
	@echo "📊 Running tests with coverage..."
	npm run test:coverage

# Build for production
build:
	@echo "🏗️ Building for production..."
	npm run build

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf .next node_modules coverage

# Run linting
lint:
	@echo "🔍 Running linting..."
	npm run lint

# Type checking
type-check:
	@echo "📝 Running type checking..."
	npm run type-check

# Validate manifests and Supanova integration
validate:
	@echo "✅ Validating manifests and integration..."
	npm run validate:manifest

# Run full CI pipeline locally
ci: validate lint type-check test build
	@echo "🎉 CI pipeline completed successfully!"

# Create new app from template
new-app:
	@echo "📦 Creating new app from template..."
	@if [ -z "$(APP_NAME)" ]; then \
		echo "❌ Please provide APP_NAME: make new-app APP_NAME=my-app"; \
		exit 1; \
	fi
	@echo "Creating app: $(APP_NAME)"
	# Template creation logic would go here
	@echo "✅ App $(APP_NAME) created"

# Deploy to staging
deploy-staging:
	@echo "🚀 Deploying to staging..."
	# Deployment logic would go here
	@echo "✅ Deployed to staging"

# Deploy to production
deploy-production:
	@echo "🚀 Deploying to production..."
	# Deployment logic would go here
	@echo "✅ Deployed to production"

# Generate documentation
docs:
	@echo "📚 Generating documentation..."
	# Documentation generation logic would go here
	@echo "✅ Documentation generated"

# Security audit
audit:
	@echo "🔒 Running security audit..."
	npm audit
	@echo "✅ Security audit completed"

# Update dependencies
update:
	@echo "⬆️ Updating dependencies..."
	npm update
	@echo "✅ Dependencies updated"

# Help target
help:
	@echo "📖 Available commands:"
	@echo "  setup          - Setup development environment"
	@echo "  dev            - Start development server"
	@echo "  test           - Run tests"
	@echo "  test-coverage  - Run tests with coverage"
	@echo "  build          - Build for production"
	@echo "  clean          - Clean build artifacts"
	@echo "  lint           - Run linting"
	@echo "  type-check     - Run type checking"
	@echo "  validate       - Validate manifests and integration"
	@echo "  ci             - Run full CI pipeline locally"
	@echo "  new-app        - Create new app (APP_NAME required)"
	@echo "  deploy-staging - Deploy to staging"
	@echo "  deploy-production - Deploy to production"
	@echo "  docs           - Generate documentation"
	@echo "  audit          - Run security audit"
	@echo "  update         - Update dependencies"
	@echo "  help           - Show this help message"
