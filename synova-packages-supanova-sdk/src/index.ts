/**
 * Main Supanova SDK entry point
 */

import { ToolManager } from './tools';
import { ContextEmitter } from './context';
import { PermissionManager } from './permissions';
import {
  SupanovaClient,
  SupanovaConfig,
  ToolRequest,
  ToolResponse,
  PermissionCheckResult,
  ToolRegistry
} from './types';

/**
 * Main Supanova SDK Client
 */
export class SupanovaSDK implements SupanovaClient {
  public readonly config: SupanovaConfig;
  public readonly tools: ToolManager & ToolRegistry;
  public readonly context: ContextEmitter;
  public readonly permissions: PermissionManager;

  private started = false;

  constructor(config: SupanovaConfig) {
    this.config = this.validateConfig(config);
    this.tools = new ToolManager();
    this.context = new ContextEmitter();
    this.permissions = new PermissionManager();

    this.setupEventListeners();
    this.setupDefaultMiddleware();
  }

  /**
   * Start the Supanova SDK
   */
  async start(): Promise<void> {
    if (this.started) {
      return;
    }

    // Initialize permissions
    for (const [toolName, permission] of Object.entries(this.config.permissions)) {
      this.permissions.updatePermissions(toolName, permission);
    }

    // Validate all permissions
    if (!this.permissions.validatePermissions()) {
      throw new Error('Invalid permissions configuration');
    }

    this.started = true;
    this.emitEvent('sdk:started', { config: this.config });
  }

  /**
   * Stop the Supanova SDK
   */
  async stop(): Promise<void> {
    if (!this.started) {
      return;
    }

    this.context.clearHistory();
    this.permissions.clearAuditLog();
    this.started = false;

    this.emitEvent('sdk:stopped', {});
  }

  /**
   * Execute a tool with permission checking
   */
  async executeTool(
    toolName: string,
    args: Record<string, any>,
    context?: Partial<ToolRequest['context']>
  ): Promise<ToolResponse> {
    if (!this.started) {
      throw new Error('Supanova SDK is not started');
    }

    // Create tool request
    const request = ToolManager.createRequest(
      toolName,
      args,
      {
        user_id: 'current-user', // This would come from authentication
        role: 'editor', // This would come from user session
        session_id: this.context.getSessionId(),
      },
      {
        route: context?.route || '/',
        selected_ids: context?.selected_ids || [],
        app_version: this.config.app_version,
        screen_size: context?.screen_size || 'unknown',
      }
    );

    // Check permissions
    const permissionResult = await this.checkPermission(toolName, request.actor);
    if (!permissionResult.allowed) {
      return ToolManager.createErrorResponse(
        request.request_id,
        permissionResult.reason || 'Permission denied'
      );
    }

    // Execute tool
    return await this.tools.executeTool(request);
  }

  /**
   * Check permission for a tool
   */
  async checkPermission(toolName: string, actor: ToolRequest['actor']): Promise<PermissionCheckResult> {
    return await this.permissions.checkPermission(toolName, actor);
  }

  /**
   * Register a new tool
   */
  registerTool(name: string, handler: (request: ToolRequest) => Promise<ToolResponse>): void {
    this.tools.registerTool(name, handler);
    this.emitEvent('tool:registered', { name });
  }

  /**
   * Unregister a tool
   */
  unregisterTool(name: string): void {
    this.tools.unregisterTool(name);
    this.emitEvent('tool:unregistered', { name });
  }

  /**
   * Get SDK statistics
   */
  getStatistics(): {
    tools: {
      registered: number;
      execution_count: number;
      error_count: number;
    };
    context: {
      total_events: number;
      session_duration: number;
      last_event_time: string | null;
    };
    permissions: {
      total_checks: number;
      allowed_checks: number;
      denied_checks: number;
    };
  } {
    const contextStats = this.context.getStatistics();
    const permissionStats = this.permissions.getStatistics();

    return {
      tools: {
        registered: this.tools.getToolNames().length,
        execution_count: 0, // This would be tracked by tool manager
        error_count: 0, // This would be tracked by tool manager
      },
      context: {
        total_events: contextStats.total_events,
        session_duration: contextStats.session_duration,
        last_event_time: contextStats.last_event_time,
      },
      permissions: {
        total_checks: permissionStats.permission_checks,
        allowed_checks: permissionStats.allowed_checks,
        denied_checks: permissionStats.denied_checks,
      },
    };
  }

  /**
   * Validate configuration
   */
  private validateConfig(config: SupanovaConfig): SupanovaConfig {
    if (!config.api_url) {
      throw new Error('api_url is required');
    }

    if (!config.api_key) {
      throw new Error('api_key is required');
    }

    if (!config.app_name) {
      throw new Error('app_name is required');
    }

    if (!config.app_version) {
      throw new Error('app_version is required');
    }

    if (!config.permissions || typeof config.permissions !== 'object') {
      throw new Error('permissions configuration is required');
    }

    return config;
  }

  /**
   * Setup event listeners between components
   */
  private setupEventListeners(): void {
    // Forward tool events
    this.tools.on('tool:executed', (data) => {
      this.emitEvent('tool:executed', data);
    });

    this.tools.on('tool:error', (data) => {
      this.emitEvent('tool:error', data);
    });

    // Forward permission events
    this.permissions.on('permission:checked', (data) => {
      this.emitEvent('permission:checked', data);
    });

    // Forward context events
    this.context.on('context:event', (event) => {
      this.emitEvent('context:event', event);
    });
  }

  /**
   * Setup default middleware
   */
  private setupDefaultMiddleware(): void {
    // Add logging middleware
    this.tools.use(async (request, next) => {
      console.log(`[Supanova] Executing tool: ${request.tool}`);
      const response = await next();
      console.log(`[Supanova] Tool ${request.tool} completed: ${response.success}`);
      return response;
    });

    // Add validation middleware
    this.tools.use(async (request, next) => {
      // Validate request structure
      if (!request.tool || !request.request_id || !request.actor) {
        return ToolManager.createErrorResponse(
          request.request_id,
          'Invalid request structure'
        );
      }

      return await next();
    });

    // Add permission middleware
    this.tools.use(async (request, next) => {
      const permissionResult = await this.checkPermission(request.tool, request.actor);
      
      if (!permissionResult.allowed) {
        return ToolManager.createErrorResponse(
          request.request_id,
          permissionResult.reason || 'Permission denied'
        );
      }

      return await next();
    });
  }

  /**
   * Emit event (internal)
   */
  private emitEvent(event: string, data: any): void {
    // This would typically emit to an event emitter
    console.log(`[Supanova Event] ${event}:`, data);
  }
}

/**
 * Factory function to create Supanova SDK instance
 */
export function createSupanovaSDK(config: SupanovaConfig): SupanovaSDK {
  return new SupanovaSDK(config);
}

/**
 * Default configuration factory
 */
export function createDefaultConfig(overrides: Partial<SupanovaConfig> = {}): SupanovaConfig {
  return {
    api_url: 'http://localhost:3001/api/supanova',
    api_key: 'demo-key',
    app_name: 'Demo App',
    app_version: '1.0.0',
    permissions: {},
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
    ...overrides,
  };
}

// Export main classes and utilities
export { ToolManager, ContextEmitter, PermissionManager };
export * from './types';
export * from './tools';
export * from './context';
export * from './permissions';

// Default export
export default SupanovaSDK;
