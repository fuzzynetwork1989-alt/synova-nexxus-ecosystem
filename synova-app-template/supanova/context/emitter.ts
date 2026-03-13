/**
 * Supanova Context Emitter
 * Emits structured events from the app to Supanova
 */

export interface ContextEvent {
  type: string;
  timestamp: string;
  user_id?: string;
  session_id: string;
  data: Record<string, any>;
}

export interface AppContext {
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

class ContextEmitter {
  private session_id: string;
  private event_queue: ContextEvent[] = [];
  private subscribers: ((event: ContextEvent) => void)[] = [];

  constructor() {
    this.session_id = this.generateSessionId();
  }

  private generateSessionId(): string {
    return `session_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  /**
   * Emit a context event
   */
  emit(event: Omit<ContextEvent, 'timestamp' | 'session_id'>): void {
    const fullEvent: ContextEvent = {
      ...event,
      timestamp: new Date().toISOString(),
      session_id: this.session_id
    };

    this.event_queue.push(fullEvent);
    this.notifySubscribers(fullEvent);
  }

  /**
   * Emit route change event
   */
  emitRouteChange(route: string, params?: Record<string, any>): void {
    this.emit({
      type: 'route_change',
      data: {
        route,
        params,
        timestamp: Date.now()
      }
    });
  }

  /**
   * Emit entity selection event
   */
  emitEntitySelection(entityIds: string[], entityType: string): void {
    this.emit({
      type: 'entity_selection',
      data: {
        entity_ids: entityIds,
        entity_type,
        count: entityIds.length
      }
    });
  }

  /**
   * Emit user action event
   */
  emitUserAction(action: string, target: string, data?: Record<string, any>): void {
    this.emit({
      type: 'user_action',
      data: {
        action,
        target,
        data,
        timestamp: Date.now()
      }
    });
  }

  /**
   * Emit system error event
   */
  emitSystemError(error: Error, context?: string): void {
    this.emit({
      type: 'system_error',
      data: {
        error_message: error.message,
        error_stack: error.stack,
        context,
        timestamp: Date.now()
      }
    });
  }

  /**
   * Get current app context snapshot
   */
  getCurrentContext(): AppContext {
    // This should be implemented based on your app's state management
    return {
      current_route: window?.location?.pathname || '/',
      selected_entities: [],
      user_intent: {
        recent_actions: this.getRecentActions()
      },
      system_state: {
        loading: false,
        error_count: this.getRecentErrorCount()
      },
      metadata: {
        app_version: '1.0.0',
        screen_size: `${window?.innerWidth || 0}x${window?.innerHeight || 0}`,
        user_agent: navigator?.userAgent || 'Unknown'
      }
    };
  }

  /**
   * Subscribe to context events
   */
  subscribe(callback: (event: ContextEvent) => void): () => void {
    this.subscribers.push(callback);
    
    // Return unsubscribe function
    return () => {
      const index = this.subscribers.indexOf(callback);
      if (index > -1) {
        this.subscribers.splice(index, 1);
      }
    };
  }

  /**
   * Get event history
   */
  getEventHistory(limit: number = 50): ContextEvent[] {
    return this.event_queue.slice(-limit);
  }

  /**
   * Clear event history
   */
  clearHistory(): void {
    this.event_queue = [];
  }

  private notifySubscribers(event: ContextEvent): void {
    this.subscribers.forEach(callback => {
      try {
        callback(event);
      } catch (error) {
        console.error('Error in context event subscriber:', error);
      }
    });
  }

  private getRecentActions(): string[] {
    return this.event_queue
      .filter(event => event.type === 'user_action')
      .slice(-10)
      .map(event => event.data.action);
  }

  private getRecentErrorCount(): number {
    const fiveMinutesAgo = Date.now() - (5 * 60 * 1000);
    return this.event_queue.filter(event => 
      event.type === 'system_error' && 
      new Date(event.timestamp).getTime() > fiveMinutesAgo
    ).length;
  }
}

// Export singleton instance
export const contextEmitter = new ContextEmitter();

export default contextEmitter;
