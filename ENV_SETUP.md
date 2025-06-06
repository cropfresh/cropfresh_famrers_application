# Environment Configuration Guide

This guide explains how to set up and manage environment variables and secrets for the CropFresh Farmers App.

## Overview

The app uses a comprehensive environment configuration system that supports:
- Multiple environments (development, staging, production)
- Secure secret management
- CI/CD integration
- Local development setup

## Quick Start

### 1. Initial Setup

```bash
# Clone the repository
git clone <repository-url>
cd cropfresh_farmers_app

# Copy the example environment file
cp .env.example .env.local

# Install dependencies
flutter pub get
```

### 2. Configure Environment

Edit `.env.local` with your actual values:

```bash
# Basic configuration
APP_ENV=development
API_BASE_URL=https://api-dev.cropfresh.com/v1

# Add your actual secrets
FIREBASE_API_KEY=your_actual_firebase_key
GOOGLE_MAPS_API_KEY=your_actual_maps_key
JWT_SECRET_KEY=your_actual_jwt_secret
```

### 3. Generate Secrets (Optional)

Use the provided script to generate secure secrets:

```bash
chmod +x scripts/env_config.sh
./scripts/env_config.sh secrets
```

## File Structure

```
├── .env.example          # Template with all available variables
├── .env.development      # Development environment defaults
├── .env.staging          # Staging environment configuration
├── .env.production       # Production environment configuration
├── .env.local           # Your local configuration (gitignored)
└── scripts/
    └── env_config.sh    # Environment management script
```

## Environment Files

### `.env.example`
Contains all available environment variables with example values. This file is safe to commit to version control.

### `.env.development`
Default configuration for development environment with safe defaults and mock values.

### `.env.staging`
Staging environment configuration with placeholders for secrets that will be injected during CI/CD.

### `.env.production`
Production environment configuration with placeholders for secrets.

### `.env.local`
Your personal local configuration. **This file should NEVER be committed to version control.**

## Available Environment Variables

### App Configuration
```bash
APP_ENV=development|staging|production
APP_NAME=CropFresh Farmers
APP_VERSION=1.0.0
```

### API Configuration
```bash
API_BASE_URL=https://api.cropfresh.com/v1
API_TIMEOUT=30000
API_RETRY_ATTEMPTS=3
```

### Firebase Configuration (REMOVED)
```bash
# Firebase removed - using Django backend only
# All push notifications will be handled via Django backend
# using alternative services like OneSignal, Pusher, or custom implementation
```

### Google Services
```bash
GOOGLE_MAPS_API_KEY=your_maps_key
GOOGLE_PLACES_API_KEY=your_places_key
```

### Authentication & Security
```bash
JWT_SECRET_KEY=your_jwt_secret
ENCRYPTION_KEY=your_32_char_encryption_key
```

### Third-party Services
```bash
WEATHER_API_KEY=your_weather_key
TWILIO_ACCOUNT_SID=your_twilio_sid
TWILIO_AUTH_TOKEN=your_twilio_token
RAZORPAY_KEY_ID=your_razorpay_key
```

### Feature Flags
```bash
ENABLE_BIOMETRIC_AUTH=true|false
ENABLE_PUSH_NOTIFICATIONS=true|false
ENABLE_OFFLINE_MODE=true|false
ENABLE_DARK_MODE=true|false
ENABLE_AI_FEATURES=true|false
ENABLE_FINANCIAL_SERVICES=true|false
```

## Environment Management Script

The `scripts/env_config.sh` script provides several utilities:

### Setup Environment
```bash
./scripts/env_config.sh setup development
./scripts/env_config.sh setup staging
./scripts/env_config.sh setup production
```

### Switch Environment
```bash
./scripts/env_config.sh switch staging
```

### Validate Configuration
```bash
./scripts/env_config.sh validate production
```

### Manage Secrets
```bash
./scripts/env_config.sh secrets
```

### Backup/Restore Configuration
```bash
# Backup current configuration
./scripts/env_config.sh backup

# Restore from backup
./scripts/env_config.sh restore backups/env_backup_20241205_143022.tar.gz
```

### Clean Temporary Files
```bash
./scripts/env_config.sh clean
```

## CI/CD Integration

### GitHub Secrets Setup

Add the following secrets to your GitHub repository:

#### Development/Staging Secrets
- `FIREBASE_PROJECT_ID_STAGING`
- `FIREBASE_API_KEY_STAGING`
- `GOOGLE_MAPS_API_KEY_STAGING`
- `JWT_SECRET_KEY_STAGING`
- `ENCRYPTION_KEY_STAGING`

#### Production Secrets
- `FIREBASE_PROJECT_ID_PRODUCTION`
- `FIREBASE_API_KEY_PRODUCTION`
- `GOOGLE_MAPS_API_KEY_PRODUCTION`
- `JWT_SECRET_KEY_PRODUCTION`
- `ENCRYPTION_KEY_PRODUCTION`

#### Shared Secrets
- `WEATHER_API_KEY`
- `TWILIO_ACCOUNT_SID`
- `TWILIO_AUTH_TOKEN`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### Workflow Usage

The CI/CD pipeline automatically selects the appropriate environment:
- `main` branch → production
- `develop` branch → staging
- Manual dispatch → user-selected environment

```yaml
# Example: Manual deployment to staging
name: Deploy to Staging
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Target environment'
        required: true
        default: 'staging'
        type: choice
        options:
        - staging
        - production
```

## Flutter Integration

### Accessing Environment Variables

```dart
import 'package:your_app/core/services/environment_config.dart';

void main() async {
  // Initialize environment configuration
  await EnvironmentConfig.initialize();
  
  // Access configuration
  final apiUrl = EnvironmentConfig.apiBaseUrl;
  final isProduction = EnvironmentConfig.isProduction;
  final enabledFeatures = EnvironmentConfig.enableBiometricAuth;
  
  runApp(MyApp());
}
```

### Environment-Specific Code

```dart
// Different behavior based on environment
if (EnvironmentConfig.isProduction) {
  // Production-only code
  FirebaseCrashlytics.instance.recordError(error, stackTrace);
} else {
  // Development/staging code
  print('Debug: $error');
}

// Feature flags
if (EnvironmentConfig.enableAiFeatures) {
  // AI features enabled
  showAIRecommendations();
}
```

### Build Flavors

```bash
# Development build
flutter run --dart-define=FLAVOR=development

# Staging build
flutter build apk --dart-define=FLAVOR=staging

# Production build
flutter build apk --release --dart-define=FLAVOR=production
```

## Security Best Practices

### 1. Never Commit Secrets
- Always add `.env.local` to `.gitignore`
- Never commit files containing real API keys or secrets
- Use placeholder values in committed environment files

### 2. Use Strong Secrets
```bash
# Generate strong encryption key (32 bytes)
openssl rand -hex 32

# Generate JWT secret (64 characters)
openssl rand -base64 64 | tr -d "=+/" | cut -c1-64
```

### 3. Rotate Secrets Regularly
- Change API keys periodically
- Update JWT secrets on security incidents
- Monitor for exposed secrets in code

### 4. Validate Environment
```bash
# Always validate before deploying
./scripts/env_config.sh validate production
```

## Troubleshooting

### Common Issues

#### 1. Missing .env.local file
```bash
Error: .env.local file not found!
Solution: Copy .env.example to .env.local and configure it
```

#### 2. Invalid environment variables
```bash
Error: Missing required environment variables
Solution: Check and add all required variables for your environment
```

#### 3. Build failures due to missing secrets
```bash
Error: Firebase configuration not found
Solution: Ensure all Firebase environment variables are set
```

#### 4. CI/CD deployment failures
```bash
Error: Secrets not configured
Solution: Add required secrets to GitHub repository settings
```

### Debug Environment Configuration

```dart
// Debug environment in app
print('Environment: ${EnvironmentConfig.environment}');
print('API URL: ${EnvironmentConfig.apiBaseUrl}');
print('Debug Mode: ${EnvironmentConfig.debugMode}');

// Print all public configuration (non-sensitive)
print(EnvironmentConfig.getPublicConfig());

// Print secrets status (masked)
print(EnvironmentConfig.getSensitiveConfig());
```

### Validation Commands

```bash
# Validate current environment
flutter test test/environment_test.dart

# Check for hardcoded secrets
grep -r "api_key\|secret\|password" lib/ --include="*.dart"

# Verify build with environment
flutter build apk --debug --dart-define=FLAVOR=development
```

## Examples

### Local Development Setup
```bash
# 1. Setup development environment
./scripts/env_config.sh setup development

# 2. Add your actual API keys to .env.local
nano .env.local

# 3. Run the app
flutter run --dart-define=FLAVOR=development
```

### Production Deployment
```bash
# 1. Validate production configuration
./scripts/env_config.sh validate production

# 2. Deploy via GitHub Actions
git push origin main  # Triggers production deployment
```

### Feature Flag Testing
```bash
# Test with AI features enabled
echo "ENABLE_AI_FEATURES=true" >> .env.local
flutter run

# Test with AI features disabled
echo "ENABLE_AI_FEATURES=false" >> .env.local
flutter run
```

## Support

For questions or issues with environment configuration:

1. Check this documentation
2. Validate your configuration: `./scripts/env_config.sh validate local`
3. Check the example file: `.env.example`
4. Contact the development team

## Changelog

### v1.0.0
- Initial environment configuration system
- Support for development, staging, and production environments
- Comprehensive secret management
- CI/CD integration
- Management scripts and documentation
