# CropFresh Farmers App 🌾

A comprehensive digital platform empowering farmers with direct marketplace access, smart logistics, input procurement, and agricultural services.

## 📱 App Overview

CropFresh Farmers App is a Flutter-based mobile application that serves as a complete farming solution, enabling farmers to:

- **Sell Directly**: Access buyers without middlemen through direct marketplace
- **Smart Logistics**: Book transportation with real-time tracking
- **Input Procurement**: Purchase seeds, fertilizers, and equipment
- **Agricultural Services**: Soil testing, veterinary services, and expert consultation
- **Knowledge Hub**: Access farming best practices and expert advice

## 🎨 Design System

Our app follows a **60-30-10 color rule** based on the CropFresh brand identity:

- **60%** - Clean white and warm backgrounds for readability
- **30%** - CropFresh green for agricultural identity and navigation
- **10%** - Orange accents for calls-to-action and highlights

## 🏗️ Project Structure

```
cropfresh_farmers_app/
├── lib/
│   ├── core/                          # Core functionality
│   │   ├── constants/                 # App constants
│   │   ├── theme/                     # Theme and styling
│   │   ├── utils/                     # Utility functions
│   │   └── services/                  # Core services
│   ├── features/                      # Feature-based modules
│   │   ├── splash/                    # Splash screen
│   │   ├── auth/                      # Authentication
│   │   ├── dashboard/                 # Main dashboard
│   │   ├── marketplace/               # Direct marketplace
│   │   ├── logistics/                 # Logistics booking
│   │   ├── inputs/                    # Input procurement
│   │   ├── services/                  # Agricultural services
│   │   └── profile/                   # User profile
│   ├── shared/                        # Shared components
│   │   ├── widgets/                   # Reusable widgets
│   │   └── models/                    # Data models
│   └── main.dart                      # App entry point
├── assets/                            # Static assets
│   ├── images/                        # Images and icons
│   ├── lottie/                        # Lottie animations
│   └── fonts/                         # Custom fonts
├── docs/                              # Documentation
│   ├── design/                        # Design guidelines
│   ├── api/                          # API documentation
│   └── architecture/                  # Architecture docs
└── test/                             # Test files
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.16.0 or higher)
- Dart SDK (3.2.0 or higher)
- Android Studio / VS Code
- Android/iOS development environment

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/cropfresh/farmers-app.git
   cd cropfresh_farmers_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📋 Features

### ✅ Phase 1 - Core Features (Months 1-6)
- [x] Splash Screen with 3D Animation
- [x] User Authentication (Phone + OTP)
- [x] Profile Setup & Farm Details
- [ ] Dashboard with Weather & Market Prices
- [ ] Direct Marketplace
- [ ] Logistics Booking
- [ ] Input Procurement
- [ ] Agricultural Services

### 🔄 Phase 2 - AI Integration (Months 7-12)
- [ ] AI Crop Scanner
- [ ] Price Prediction
- [ ] Smart Recommendations
- [ ] Yield Forecasting

### 💰 Phase 3 - Financial Services (Months 13-18)
- [ ] Digital Payments
- [ ] Credit Assessment
- [ ] Insurance Integration
- [ ] Government Schemes

## 🎨 Design Guidelines

See our comprehensive design documentation:
- [Color System](docs/design/colors.md) - Brand colors and usage guidelines
- [Typography](docs/design/typography.md) - Font system and hierarchy
- [Components](docs/design/components.md) - UI component library
- [Icons](docs/design/icons.md) - Icon system and guidelines

## 🏛️ Architecture

The app follows **Clean Architecture** principles with feature-based organization:

- **Presentation Layer**: UI components, pages, and widgets
- **Business Logic Layer**: BLoC/Cubit for state management
- **Data Layer**: Repositories, data sources, and models

## 📚 Tech Stack

- **Framework**: Flutter 3.16+
- **Language**: Dart 3.2+
- **State Management**: BLoC/Cubit
- **Navigation**: GoRouter
- **Local Storage**: Hive/SharedPreferences
- **HTTP Client**: Dio
- **Animations**: Lottie, Rive
- **Maps**: Google Maps
- **Push Notifications**: Firebase Cloud Messaging

## 🌐 Localization

Supports multiple Indian languages:
- **English** (Primary)
- **Kannada** (Karnataka farmers)
- **Telugu** (Andhra Pradesh/Telangana farmers)
- **Hindi** (Pan-India support)

## 🧪 Testing

Run tests with:
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test.dart
```

## 📊 Performance

- **App Size**: < 25MB
- **Startup Time**: < 3 seconds
- **Frame Rate**: 60 FPS
- **Memory Usage**: < 150MB
- **Network**: Optimized for 2G/3G

## 🔐 Security

- **Authentication**: JWT tokens with refresh mechanism
- **Data**: End-to-end encryption for sensitive information
- **Storage**: Encrypted local storage
- **API**: HTTPS with certificate pinning

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and queries:
- **Email**: developers@cropfresh.com
- **Documentation**: [docs.cropfresh.com](https://docs.cropfresh.com)
- **Issues**: [GitHub Issues](https://github.com/cropfresh/farmers-app/issues)

## 🌟 Acknowledgments

- **UI/UX Design**: Material Design 3 principles
- **Icons**: Material Icons and custom agricultural icons
- **Animations**: Lottie animations for smooth user experience
- **Farmers**: Our farmer community for continuous feedback

---

**Built with ❤️ for Indian Farmers**

*Empowering agriculture through technology*
