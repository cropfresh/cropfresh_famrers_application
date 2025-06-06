# Architecture Documentation 🏗️

## Overview

CropFresh Farmers App follows **Clean Architecture** principles with a feature-based modular structure, ensuring maintainability, testability, and scalability.

## Architectural Layers

### 1. Presentation Layer
- **UI Components**: Flutter widgets and screens
- **State Management**: BLoC/Cubit pattern
- **Navigation**: GoRouter for declarative routing
- **Theme**: Material Design 3 with CropFresh 60-30-10 color system

### 2. Domain Layer
- **Entities**: Core business objects
- **Use Cases**: Business logic implementation
- **Repository Interfaces**: Abstract data contracts
- **Value Objects**: Immutable data structures

### 3. Data Layer
- **Repositories**: Implementation of domain interfaces
- **Data Sources**: Remote (API) and Local (Hive/SharedPreferences)
- **Models**: Data transfer objects with JSON serialization
- **Network**: Dio HTTP client with interceptors

## Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── constants/                  # App-wide constants
│   │   ├── colors.dart            # 60-30-10 color system
│   │   ├── strings.dart           # Text constants
│   │   ├── dimensions.dart        # Spacing and sizing
│   │   └── assets.dart            # Asset paths
│   ├── theme/                     # App theming
│   │   ├── theme.dart             # Main theme configuration
│   │   ├── text_styles.dart       # Typography system
│   │   └── decorations.dart       # Common decorations
│   ├── utils/                     # Utility functions
│   │   ├── validators.dart        # Form validation
│   │   ├── formatters.dart        # Data formatting
│   │   ├── extensions.dart        # Dart extensions
│   │   └── helpers.dart           # Helper functions
│   ├── services/                  # Core services
│   │   ├── api_service.dart       # HTTP client configuration
│   │   ├── storage_service.dart   # Local storage service
│   │   ├── auth_service.dart      # Authentication service
│   │   └── notification_service.dart # Push notifications
│   ├── error/                     # Error handling
│   │   ├── failures.dart          # Custom failure types
│   │   ├── exceptions.dart        # Custom exceptions
│   │   └── error_handler.dart     # Global error handler
│   └── network/                   # Network layer
│       ├── api_endpoints.dart     # API endpoint constants
│       ├── network_info.dart      # Connectivity checker
│       └── interceptors/          # HTTP interceptors
├── features/                      # Feature modules
│   ├── splash/                    # Splash screen feature
│   │   ├── presentation/          # UI layer
│   │   │   ├── pages/            # Screen widgets
│   │   │   ├── widgets/          # Feature-specific widgets
│   │   │   └── bloc/             # State management
│   │   ├── domain/               # Business logic
│   │   │   ├── entities/         # Business objects
│   │   │   ├── repositories/     # Repository interfaces
│   │   │   └── usecases/         # Business use cases
│   │   └── data/                 # Data layer
│   │       ├── models/           # Data models
│   │       ├── repositories/     # Repository implementations
│   │       └── datasources/      # Data sources
│   ├── auth/                     # Authentication
│   ├── dashboard/                # Main dashboard
│   ├── marketplace/              # Direct marketplace
│   ├── logistics/                # Logistics booking
│   ├── inputs/                   # Input procurement
│   ├── services/                 # Agricultural services
│   │   ├── soil_testing/
│   │   ├── veterinary/
│   │   └── nursery/
│   ├── livestock/                # Livestock management
│   ├── knowledge/                # Knowledge hub
│   └── profile/                  # User profile
├── shared/                       # Shared components
│   ├── widgets/                  # Reusable widgets
│   │   ├── buttons/
│   │   ├── cards/
│   │   ├── forms/
│   │   ├── loaders/
│   │   └── dialogs/
│   ├── models/                   # Shared data models
│   └── utils/                    # Shared utilities
└── main.dart                     # App entry point
```

This architecture ensures the CropFresh Farmers App is scalable, maintainable, and follows industry best practices while implementing the 60-30-10 color design system throughout.
