import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Firebase removed - using Django backend only
import 'package:flutter_localizations/flutter_localizations.dart';

// Core imports
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/services/localization_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/environment_config.dart';

// BLoC imports
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Environment Configuration first
    await EnvironmentConfig.initialize();
    
    // Validate environment variables
    EnvironmentConfig.validateEnvironment();
    
    // Initialize services based on environment
    await _initializeServices();
    
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    
    // Set preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    runApp(const CropFreshFarmersApp());
  } catch (e) {
    // Handle initialization errors
    runApp(ErrorApp(error: e.toString()));
  }
}

/// Initialize all app services
Future<void> _initializeServices() async {
  // Initialize Hive for local storage
  await Hive.initFlutter();
  await StorageService.initialize();
  
  // Firebase removed - using Django backend for all services
  
  // Initialize notifications if enabled
  if (EnvironmentConfig.enablePushNotifications) {
    await NotificationService.initialize();
  }
}

class CropFreshFarmersApp extends StatelessWidget {
  const CropFreshFarmersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(CheckAuthStatusRequested()),
        ),
        BlocProvider<DashboardBloc>(
          create: (context) => DashboardBloc(),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: EnvironmentConfig.appName,
            debugShowCheckedModeBanner: EnvironmentConfig.debugMode,
            
            // Theme Configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: EnvironmentConfig.enableDarkMode 
                ? ThemeMode.system 
                : ThemeMode.light,
            
            // Localization
            localizationsDelegates: const [
              LocalizationService.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocalizationService.supportedLocales,
            locale: Locale(EnvironmentConfig.defaultLanguage, 'IN'),
            
            // Router Configuration
            routerConfig: AppRouter.router,
            
            // Global builder for responsive design
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
                ),
                child: Stack(
                  children: [
                    child!,
                    // Performance overlay if enabled
                    if (EnvironmentConfig.enablePerformanceOverlay)
                      Positioned(
                        top: 100,
                        right: 0,
                        child: PerformanceOverlay.allEnabled(),
                      ),
                    // Environment indicator for non-production
                    if (!EnvironmentConfig.isProduction)
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: EnvironmentConfig.isStaging 
                                ? Colors.orange.withOpacity(0.8)
                                : Colors.red.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            EnvironmentConfig.environment.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Error App for initialization failures
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CropFresh - Error',
      home: Scaffold(
        backgroundColor: Colors.red.shade50,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'App Initialization Failed',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    error,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Please check your environment configuration and try again.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Restart the app
                      SystemNavigator.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Restart App'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Auth Bloc Events (placeholder)
abstract class AuthEvent {}
class CheckAuthStatusRequested extends AuthEvent {}

/// Custom Auth Bloc States (placeholder)
abstract class AuthState {}
class AuthInitial extends AuthState {}

/// Custom Auth Bloc (placeholder)
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatusRequested>(_onCheckAuthStatus);
  }

  void _onCheckAuthStatus(CheckAuthStatusRequested event, Emitter<AuthState> emit) {
    // Check authentication status using environment config
    // This would normally check stored tokens, validate them, etc.
  }
}
