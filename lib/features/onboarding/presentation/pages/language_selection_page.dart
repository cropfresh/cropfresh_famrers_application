import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/widgets/loading_indicator.dart';

// * LANGUAGE SELECTION PAGE - CHOOSE PREFERRED LANGUAGE
class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String? _selectedLanguage;
  bool _isLoading = false;

  final List<Language> _languages = [
    Language(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇬🇧',
    ),
    Language(
      code: 'hi',
      name: 'Hindi',
      nativeName: 'हिन्दी',
      flag: '🇮🇳',
    ),
    Language(
      code: 'kn',
      name: 'Kannada',
      nativeName: 'ಕನ್ನಡ',
      flag: '🇮🇳',
    ),
    Language(
      code: 'te',
      name: 'Telugu',
      nativeName: 'తెలుగు',
      flag: '🇮🇳',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final savedLanguage = StorageService.getSelectedLanguage();
    setState(() {
      _selectedLanguage = savedLanguage;
    });
  }

  Future<void> _selectLanguage(String languageCode) async {
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  Future<void> _confirmLanguageSelection() async {
    if (_selectedLanguage == null) return;

    setState(() => _isLoading = true);

    try {
      // * Save selected language
      await StorageService.setSelectedLanguage(_selectedLanguage!);
      
      if (mounted) {
        // * Navigate to authentication
        context.go('/phone-number');
      }
    } catch (e) {
      // TODO: Show error message
      debugPrint('Error saving language: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // * HEADER
                const SizedBox(height: 32),
                Text(
                  'Choose Your Language',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select your preferred language for the app',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // * LANGUAGE LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: _languages.length,
                    itemBuilder: (context, index) {
                      final language = _languages[index];
                      final isSelected = _selectedLanguage == language.code;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? theme.colorScheme.primaryContainer
                                  : theme.colorScheme.surfaceVariant,
                            ),
                            child: Center(
                              child: Text(
                                language.flag,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          title: Text(
                            language.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            language.nativeName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: theme.colorScheme.primary,
                                )
                              : Icon(
                                  Icons.circle_outlined,
                                  color: theme.colorScheme.outline,
                                ),
                          onTap: () => _selectLanguage(language.code),
                        ),
                      );
                    },
                  ),
                ),
                
                // * CONTINUE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _selectedLanguage != null ? _confirmLanguageSelection : null,
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// * LANGUAGE MODEL
class Language {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
} 