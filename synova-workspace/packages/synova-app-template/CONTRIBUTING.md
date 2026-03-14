# Contributing to Synova App Template

Thank you for your interest in contributing to this Synova AI application template! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites
- Node.js 18+ 
- npm or yarn
- Git

### Setup
1. Fork this repository
2. Clone your fork locally
3. Install dependencies: `make setup` or `npm install`
4. Copy `.env.example` to `.env` and configure as needed
5. Start development: `make dev` or `npm run dev`

## 📋 Development Workflow

### 1. Create a Branch
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-fix-name
```

### 2. Make Changes
- Follow the existing code style and patterns
- Ensure all Supanova integration requirements are met
- Add tests for new functionality
- Update documentation as needed

### 3. Run Tests and Validation
```bash
# Run full CI pipeline locally
make ci

# Or run individual checks
make validate    # Validate manifests and Supanova integration
make lint        # Run linting
make test        # Run tests
make build       # Build project
```

### 4. Submit Pull Request
- Push your branch to your fork
- Create a pull request to the main branch
- Fill out the pull request template
- Wait for review and feedback

## 🎯 Supanova Integration Requirements

All contributions must maintain Supanova integration standards:

### Required Files
- `supanova/manifest.json` - Supanova capabilities definition
- `supanova/tools/index.ts` - Tool implementations
- `supanova/context/emitter.ts` - Context event emitter
- `supanova/policies/permissions.json` - Permission settings
- `synova.app.json` - Ecosystem manifest

### Tool Standards
- All 5 required tools must be implemented: `app.search`, `app.summarize`, `app.create_or_update`, `app.navigate`, `app.settings`
- Tools must use the standard `ToolRequest`/`ToolResponse` interfaces
- Destructive actions require confirmation
- Proper error handling and validation

### Context Integration
- Emit context events for user actions
- Provide current app context snapshot
- Include relevant metadata

## 🧪 Testing

### Unit Tests
- Write tests for all new functions and components
- Use Jest as the test framework
- Aim for high code coverage

### Integration Tests
- Test Supanova tool workflows
- Verify context emission
- Test permission enforcement

### Manual Testing
- Test the full user experience
- Verify Supanova assistant functionality
- Test error scenarios

## 📝 Code Style

### TypeScript
- Use TypeScript for all new code
- Provide proper type definitions
- Avoid `any` types when possible

### Formatting
- Use Prettier for code formatting
- Configure ESLint rules
- Follow existing naming conventions

### Comments
- Add JSDoc comments for public APIs
- Explain complex logic
- Document Supanova integration points

## 🔒 Security

### Data Protection
- Never commit secrets or API keys
- Sanitize user inputs
- Follow the principle of least privilege

### Supanova Security
- Implement proper permission checks
- Validate all tool inputs
- Audit sensitive operations

## 📚 Documentation

### Code Documentation
- Update inline comments for complex code
- Document Supanova tool interfaces
- Explain configuration options

### User Documentation
- Update README.md for user-facing changes
- Document new Supanova capabilities
- Update SUPANOVA_INTEGRATION.md if needed

## 🐛 Bug Reports

When reporting bugs, please include:
- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Environment details
- Screenshots if applicable

## ✨ Feature Requests

When suggesting features:
- Describe the use case clearly
- Explain why it's valuable
- Consider Supanova integration implications
- Suggest implementation approach if possible

## 🏷️ Labels and Tags

Use these labels for issues and pull requests:
- `bug` - Bug reports
- `enhancement` - Feature requests
- `documentation` - Documentation changes
- `supanova` - Supanova integration changes
- `security` - Security-related changes
- `good first issue` - Good for newcomers
- `help wanted` - Community help requested

## 🤝 Code of Conduct

Be respectful, inclusive, and constructive:
- Welcome newcomers and help them learn
- Assume good intentions
- Focus on what is best for the community
- Show empathy towards other community members

## 📦 Release Process

1. Update version in `package.json`
2. Update `CHANGELOG.md`
3. Run full test suite
4. Create GitHub release
5. Deploy to production

## 🎉 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Annual contributor highlights

## 📞 Getting Help

- Create an issue for questions
- Join our community discussions
- Check existing documentation
- Review similar issues and PRs

---

Thank you for contributing to Synova AI! Your contributions help make our ecosystem better for everyone. 🚀
