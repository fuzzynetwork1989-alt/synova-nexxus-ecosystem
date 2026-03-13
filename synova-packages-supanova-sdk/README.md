# @synova/supanova-sdk

The official SDK for integrating Synova AI's Smart AI Super-Agent (Supanova) into applications.

## 🚀 Features

- **Context-Aware Assistant**: Supanova understands your app's current state and user context
- **Action-Capable Tools**: Execute meaningful actions within your application through a secure tool framework
- **Permission-Based Security**: Comprehensive permission system with role-based access control
- **Real-Time Context Events**: Automatic context emission for rich AI understanding
- **TypeScript First**: Full TypeScript support with comprehensive type definitions
- **Security Focused**: Built-in input validation, output sanitization, and audit logging

## 📦 Installation

```bash
npm install @synova/supanova-sdk
```

## 🔧 Quick Start

```typescript
import { createSupanovaSDK, createDefaultConfig } from '@synova/supanova-sdk';

// Create configuration
const config = createDefaultConfig({
  api_url: 'https://your-api.com/api/supanova',
  api_key: 'your-api-key',
  app_name: 'My App',
  app_version: '1.0.0',
  permissions: {
    'app.search': {
      requires_confirmation: false,
      allowed_roles: ['viewer', 'editor', 'owner'],
      rate_limit: { requests_per_minute: 60, burst: 10 },
      data_access: 'read_only',
    },
    'app.create_or_update': {
      requires_confirmation: true,
      allowed_roles: ['editor', 'owner'],
      rate_limit: { requests_per_minute: 20, burst: 3 },
      data_access: 'limited_write',
    },
  },
});

// Create SDK instance
const supanova = createSupanovaSDK(config);

// Start the SDK
await supanova.start();

// Register tools
supanova.registerTool('app.search', async (request) => {
  const { query, type } = request.args;
  
  // Implement your search logic
  const results = await searchItems(query, type);
  
  return {
    request_id: request.request_id,
    success: true,
    data: results,
  };
});

// Execute tools
const response = await supanova.executeTool('app.search', {
  query: 'example',
  type: 'projects',
}, {
  route: '/search',
  selected_ids: ['item-123'],
});
```

## 🏗️ Architecture

The SDK is organized into several key components:

### Tool Manager
Manages tool registration, execution, and middleware chain.

```typescript
import { ToolManager } from '@synova/supanova-sdk/tools';

const tools = new ToolManager();

// Register a tool
tools.registerTool('my-tool', async (request) => {
  // Tool implementation
});

// Execute with middleware
tools.use(loggingMiddleware);
tools.use(rateLimitMiddleware);
```

### Context Emitter
Handles real-time context events and state tracking.

```typescript
import { ContextEmitter } from '@synova/supanova-sdk/context';

const context = new ContextEmitter();

// Emit events
context.emitRouteChange('/projects', { id: '123' });
context.emitEntitySelection(['proj-123'], 'project');
context.emitUserAction('create', 'project', { name: 'New Project' });

// Subscribe to events
context.subscribe((event) => {
  console.log('Context event:', event);
});
```

### Permission Manager
Manages role-based permissions and security controls.

```typescript
import { PermissionManager, PermissionPresets } from '@synova/supanova-sdk/permissions';

const permissions = new PermissionManager();

// Set permissions
permissions.updatePermissions('app.search', PermissionPresets.readOnly());

// Check permissions
const result = await permissions.checkPermission('app.search', {
  user_id: 'user-123',
  role: 'editor',
});
```

## 🔒 Security

### Input Validation
```typescript
import { SecurityUtils } from '@synova/supanova-sdk/permissions';

const validation = SecurityUtils.validateInput(userInput);
if (!validation.valid) {
  console.error('Security threats detected:', validation.errors);
}
```

### Permission Presets
```typescript
import { PermissionPresets } from '@synova/supanova-sdk/permissions';

// Read-only access
const readOnly = PermissionPresets.readOnly(['viewer', 'editor', 'owner']);

// Destructive actions (requires confirmation)
const destructive = PermissionPresets.destructive(['owner']);

// Admin-only access
const adminOnly = PermissionPresets.adminOnly();
```

## 📊 Context Events

The SDK automatically tracks and emits context events:

### Event Types
- `route_change` - Navigation events
- `entity_selection` - Item selection events
- `user_action` - User interaction events
- `system_error` - Error events
- `search_query` - Search events
- `data_loaded` - Data loading events

### Context Structure
```typescript
interface AppContext {
  current_route: string;
  selected_entities: string[];
  user_intent: {
    search_query?: string;
    action_type?: string;
    recent_actions: string[];
  };
  system_state: {
    loading: boolean;
    error_count: number;
    last_error?: string;
  };
  metadata: {
    app_version: string;
    screen_size: string;
    user_agent: string;
  };
}
```

## 🛠️ Tool Development

### Standard Tool Implementation
```typescript
import { ToolRequest, ToolResponse, ToolManager } from '@synova/supanova-sdk';

const myTool = async (request: ToolRequest): Promise<ToolResponse> => {
  try {
    // 1. Validate inputs
    validateInputs(request.args);
    
    // 2. Execute business logic
    const result = await executeBusinessLogic(request.args);
    
    // 3. Return success response
    return {
      request_id: request.request_id,
      success: true,
      data: result,
    };
  } catch (error) {
    // 4. Return error response
    return {
      request_id: request.request_id,
      success: false,
      error: error.message,
    };
  }
};

// Register with tool manager
tools.registerTool('my-tool', myTool);
```

### Built-in Middleware
```typescript
import { 
  loggingMiddleware,
  rateLimitMiddleware,
  validationMiddleware,
  auditMiddleware 
} from '@synova/supanova-sdk/tools';

// Add middleware to tool execution chain
tools.use(loggingMiddleware);
tools.use(rateLimitMiddleware(rateLimiter));
tools.use(validationMiddleware);
tools.use(auditMiddleware);
```

## 📈 Analytics & Monitoring

### Context Analytics
```typescript
import { ContextAnalytics } from '@synova/supanova-sdk/context';

const events = context.getEventHistory(1000);
const analytics = ContextAnalytics.analyzeUserBehavior(events);

console.log('Most used tools:', analytics.most_used_tools);
console.log('Common actions:', analytics.common_actions);
```

### Permission Statistics
```typescript
const stats = permissions.getStatistics();

console.log('Permission checks:', stats.permission_checks);
console.log('Allowed vs denied:', stats.allowed_checks, stats.denied_checks);
console.log('Most denied tools:', stats.most_denied_tools);
```

## 🔧 Configuration

### Full Configuration Example
```typescript
const config: SupanovaConfig = {
  api_url: 'https://api.supanova.ai/v1',
  api_key: process.env.SUPANOVA_API_KEY,
  app_name: 'My Application',
  app_version: '1.0.0',
  permissions: {
    'app.search': {
      requires_confirmation: false,
      allowed_roles: ['viewer', 'editor', 'owner'],
      rate_limit: { requests_per_minute: 60, burst: 10 },
      data_access: 'read_only',
    },
    'app.create_or_update': {
      requires_confirmation: true,
      allowed_roles: ['editor', 'owner'],
      rate_limit: { requests_per_minute: 20, burst: 3 },
      data_access: 'limited_write',
      destructive_actions: {
        delete: 'confirmation_required',
        bulk_update: 'confirmation_required',
      },
    },
  },
  features: {
    context_feed: true,
    memory_aware: false,
    mode_adaptive: true,
  },
  security: {
    validate_inputs: true,
    sanitize_outputs: true,
    audit_all_actions: true,
  },
};
```

## 🧪 Testing

```typescript
import { createSupanovaSDK } from '@synova/supanova-sdk';

describe('My Supanova Integration', () => {
  let supanova: SupanovaSDK;

  beforeEach(async () => {
    const config = createDefaultConfig({
      api_key: 'test-key',
    });
    
    supanova = createSupanovaSDK(config);
    await supanova.start();
  });

  afterEach(async () => {
    await supanova.stop();
  });

  it('should execute tools successfully', async () => {
    supanova.registerTool('test-tool', async (request) => ({
      request_id: request.request_id,
      success: true,
      data: { message: 'Hello, World!' },
    }));

    const response = await supanova.executeTool('test-tool', {});
    
    expect(response.success).toBe(true);
    expect(response.data.message).toBe('Hello, World!');
  });
});
```

## 📚 API Reference

### Main Classes
- `SupanovaSDK` - Main SDK client
- `ToolManager` - Tool registration and execution
- `ContextEmitter` - Context event management
- `PermissionManager` - Permission and security management

### Utilities
- `SecurityUtils` - Security validation and sanitization
- `PermissionPresets` - Predefined permission configurations
- `ContextAnalytics` - Context event analytics
- `ContextValidator` - Event validation utilities

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🔗 Links

- [Synova AI Website](https://synova.ai)
- [Documentation](https://docs.synova.ai)
- [Support](mailto:support@synova.ai)
- [GitHub Issues](https://github.com/synova-ai/supanova-sdk/issues)

---

Built with ❤️ by the Synova AI team
