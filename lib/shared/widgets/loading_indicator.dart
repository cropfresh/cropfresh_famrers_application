import 'package:flutter/material.dart';

// * LOADING INDICATOR - REUSABLE LOADING WIDGET
class LoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final double strokeWidth;
  final String? message;

  const LoadingIndicator({
    super.key,
    this.size,
    this.color,
    this.strokeWidth = 3.0,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size ?? 24,
          height: size ?? 24,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? theme.colorScheme.primary,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

// * CIRCULAR LOADING OVERLAY
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: LoadingIndicator(
                    size: 32,
                    message: message ?? 'Loading...',
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
} 