import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

/// * COUNTRY CODE PICKER MODAL
/// * Material 3 bottom sheet for selecting country codes
/// * Features search functionality and common countries
class CountryCodePicker extends StatefulWidget {
  final String selectedCountryCode;
  final Function(String countryCode, String countryName, String flag) onCountrySelected;

  const CountryCodePicker({
    super.key,
    required this.selectedCountryCode,
    required this.onCountrySelected,
  });

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  final TextEditingController _searchController = TextEditingController();
  List<CountryData> _filteredCountries = [];
  
  // * COUNTRY DATA
  final List<CountryData> _countries = [
    CountryData(code: '+91', name: 'India', flag: '🇮🇳'),
    CountryData(code: '+1', name: 'United States', flag: '🇺🇸'),
    CountryData(code: '+44', name: 'United Kingdom', flag: '🇬🇧'),
    CountryData(code: '+61', name: 'Australia', flag: '🇦🇺'),
    CountryData(code: '+49', name: 'Germany', flag: '🇩🇪'),
    CountryData(code: '+33', name: 'France', flag: '🇫🇷'),
    CountryData(code: '+39', name: 'Italy', flag: '🇮🇹'),
    CountryData(code: '+81', name: 'Japan', flag: '🇯🇵'),
    CountryData(code: '+86', name: 'China', flag: '🇨🇳'),
    CountryData(code: '+82', name: 'South Korea', flag: '🇰🇷'),
    CountryData(code: '+65', name: 'Singapore', flag: '🇸🇬'),
    CountryData(code: '+60', name: 'Malaysia', flag: '🇲🇾'),
    CountryData(code: '+66', name: 'Thailand', flag: '🇹🇭'),
    CountryData(code: '+62', name: 'Indonesia', flag: '🇮🇩'),
    CountryData(code: '+63', name: 'Philippines', flag: '🇵🇭'),
    CountryData(code: '+92', name: 'Pakistan', flag: '🇵🇰'),
    CountryData(code: '+880', name: 'Bangladesh', flag: '🇧🇩'),
    CountryData(code: '+94', name: 'Sri Lanka', flag: '🇱🇰'),
    CountryData(code: '+977', name: 'Nepal', flag: '🇳🇵'),
    CountryData(code: '+971', name: 'UAE', flag: '🇦🇪'),
    CountryData(code: '+966', name: 'Saudi Arabia', flag: '🇸🇦'),
    CountryData(code: '+27', name: 'South Africa', flag: '🇿🇦'),
    CountryData(code: '+234', name: 'Nigeria', flag: '🇳🇬'),
    CountryData(code: '+55', name: 'Brazil', flag: '🇧🇷'),
    CountryData(code: '+52', name: 'Mexico', flag: '🇲🇽'),
    CountryData(code: '+7', name: 'Russia', flag: '🇷🇺'),
  ];

  @override
  void initState() {
    super.initState();
    _filteredCountries = List.from(_countries);
    _searchController.addListener(_filterCountries);
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = _countries.where((country) {
        return country.name.toLowerCase().contains(query) ||
               country.code.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // * HANDLE BAR
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: CropFreshColors.onBackground60Disabled,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
          ),
          
          // * HEADER
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'Select Country',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: CropFreshColors.onBackground60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                ),
              ],
            ),
          ),
          
          // * SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: CropFreshColors.onBackground60,
              ),
              decoration: InputDecoration(
                hintText: 'Search countries...',
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: CropFreshColors.onBackground60Tertiary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: CropFreshColors.onBackground60Secondary,
                ),
                filled: true,
                fillColor: CropFreshColors.background60Secondary,
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // * COUNTRIES LIST
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = country.code == widget.selectedCountryCode;
                
                return InkWell(
                  onTap: () {
                    widget.onCountrySelected(
                      country.code,
                      country.name,
                      country.flag,
                    );
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? CropFreshColors.green30Container
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        // * FLAG
                        Text(
                          country.flag,
                          style: const TextStyle(fontSize: 24),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // * COUNTRY NAME
                        Expanded(
                          child: Text(
                            country.name,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: isSelected 
                                  ? CropFreshColors.onGreen30Container
                                  : CropFreshColors.onBackground60,
                              fontWeight: isSelected 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        
                        // * COUNTRY CODE
                        Text(
                          country.code,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isSelected 
                                ? CropFreshColors.onGreen30Container
                                : CropFreshColors.onBackground60Secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        // * SELECTED INDICATOR
                        if (isSelected) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.check_circle,
                            color: CropFreshColors.green30Primary,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// * COUNTRY DATA MODEL
class CountryData {
  final String code;
  final String name;
  final String flag;

  CountryData({
    required this.code,
    required this.name,
    required this.flag,
  });
} 