// ===================================================================
// * ERROR WIDGETS
// * Purpose: Provides consistent error display across the application
// * Features: Different error types, retry buttons, customization
// ===================================================================

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_theme.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final String? buttonText;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? animationAsset;
  final Color? color;
  final bool showRetryButton;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.buttonText,
    this.onRetry,
    this.icon,
    this.animationAsset,
    this.color,
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = color ?? theme.colorScheme.error;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // * Error Icon or Animation
            if (animationAsset != null)
              SizedBox(
                width: 150,
                height: 150,
                child: Lottie.asset(
                  animationAsset!,
                  repeat: false,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.error_outline,
                      size: 80,
                      color: errorColor,
                    );
                  },
                ),
              )
            else
              Icon(
                icon ?? Icons.error_outline,
                size: 80,
                color: errorColor,
              ),

            const SizedBox(height: 24),

            // * Error Title
            if (title != null)
              Text(
                title!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: errorColor,
                ),
                textAlign: TextAlign.center,
              ),

            if (title != null) const SizedBox(height: 8),

            // * Error Message
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // * Retry Button
            if (showRetryButton && onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(buttonText ?? 'Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Connection Problem',
      message: message ?? 'Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
      buttonText: 'Retry',
    );
  }
}

class NotFoundErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onGoBack;

  const NotFoundErrorWidget({
    super.key,
    this.message,
    this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Not Found',
      message: message ?? 'The content you\'re looking for doesn\'t exist.',
      icon: Icons.search_off,
      onRetry: onGoBack,
      buttonText: 'Go Back',
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onAction;
  final IconData? icon;
  final String? animationAsset;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onAction,
    this.icon,
    this.animationAsset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // * Empty State Icon or Animation
            if (animationAsset != null)
              SizedBox(
                width: 150,
                height: 150,
                child: Lottie.asset(
                  animationAsset!,
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.inbox_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    );
                  },
                ),
              )
            else
              Icon(
                icon ?? Icons.inbox_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),

            const SizedBox(height: 24),

            // * Empty State Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // * Empty State Message
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // * Action Button
            if (onAction != null && buttonText != null)
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(buttonText!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const ServerErrorWidget({
    super.key,
    this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Server Error',
      message: message ?? 'Something went wrong on our end. Please try again later.',
      icon: Icons.dns_outlined,
      onRetry: onRetry,
      buttonText: 'Try Again',
    );
  }
}

class TimeoutErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const TimeoutErrorWidget({
    super.key,
    this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Request Timeout',
      message: message ?? 'The request took too long to complete. Please try again.',
      icon: Icons.access_time,
      onRetry: onRetry,
      buttonText: 'Retry',
    );
  }
}

class UnauthorizedErrorWidget extends StatelessWidget {
  final VoidCallback? onLogin;
  final String? message;

  const UnauthorizedErrorWidget({
    super.key,
    this.onLogin,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Authentication Required',
      message: message ?? 'Please log in to access this content.',
      icon: Icons.lock_outline,
      onRetry: onLogin,
      buttonText: 'Login',
    );
  }
}

class MaintenanceWidget extends StatelessWidget {
  final String? message;
  final String? estimatedTime;

  const MaintenanceWidget({
    super.key,
    this.message,
    this.estimatedTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.build_outlined,
              size: 80,
              color: Colors.orange.shade400,
            ),

            const SizedBox(height: 24),

            const Text(
              'Under Maintenance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              message ?? 'We\'re currently performing maintenance to improve your experience.',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),

            if (estimatedTime != null) ...[
              const SizedBox(height: 16),
              Text(
                'Estimated completion: $estimatedTime',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// * Error boundary widget for catching widget errors
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stackTrace)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!, _stackTrace) ??
          CustomErrorWidget(
            title: 'Something went wrong',
            message: 'An unexpected error occurred. Please try again.',
            onRetry: () {
              setState(() {
                _error = null;
                _stackTrace = null;
              });
            },
          );
    }

    return widget.child;
  }
}

// * No Internet Connection Widget
class NoInternetWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
      icon: Icons.signal_wifi_off,
      onRetry: onRetry,
      buttonText: 'Retry',
      color: Colors.orange,
    );
  }
} 