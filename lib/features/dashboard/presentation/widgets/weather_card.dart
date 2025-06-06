import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Weather Card Widget for Dashboard
class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherCard({
    super.key,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryGreen.withOpacity(0.1),
              AppTheme.accentOrange.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.accentOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getWeatherIcon(weatherData['condition']),
                          color: AppTheme.accentOrange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Weather Today',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _showDetailedWeather(context),
                    child: const Text('Details'),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Current weather
              Row(
                children: [
                  // Temperature
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weatherData['temperature']}',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                            Text(
                              '°C',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          weatherData['condition'],
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Weather details
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _buildWeatherDetail(
                          context,
                          Icons.water_drop,
                          'Humidity',
                          '${weatherData['humidity']}%',
                        ),
                        const SizedBox(height: 8),
                        _buildWeatherDetail(
                          context,
                          Icons.air,
                          'Wind',
                          '${weatherData['windSpeed']} km/h',
                        ),
                        const SizedBox(height: 8),
                        _buildWeatherDetail(
                          context,
                          Icons.wb_sunny,
                          'UV Index',
                          '${weatherData['uvIndex']}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // 5-day forecast
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '5-Day Forecast',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (final forecast in weatherData['forecast'].take(5))
                          _buildForecastItem(context, forecast),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForecastItem(BuildContext context, Map<String, dynamic> forecast) {
    return Column(
      children: [
        Text(
          forecast['day'],
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Icon(
          _getWeatherIcon(forecast['condition']),
          size: 20,
          color: AppTheme.accentOrange,
        ),
        const SizedBox(height: 4),
        Text(
          '${forecast['high']}°',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${forecast['low']}°',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'partly cloudy':
        return Icons.wb_cloudy;
      case 'cloudy':
        return Icons.cloud;
      case 'rain':
        return Icons.umbrella;
      case 'storm':
        return Icons.thunderstorm;
      default:
        return Icons.wb_sunny;
    }
  }

  void _showDetailedWeather(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Detailed Weather',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            
            // Detailed weather content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Today's detailed info
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Today\'s Conditions',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildDetailedWeatherStat(
                                  context,
                                  Icons.thermostat,
                                  'Temperature',
                                  '${weatherData['temperature']}°C',
                                ),
                                _buildDetailedWeatherStat(
                                  context,
                                  Icons.water_drop,
                                  'Humidity',
                                  '${weatherData['humidity']}%',
                                ),
                                _buildDetailedWeatherStat(
                                  context,
                                  Icons.air,
                                  'Wind Speed',
                                  '${weatherData['windSpeed']} km/h',
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildDetailedWeatherStat(
                                  context,
                                  Icons.umbrella,
                                  'Rainfall',
                                  '${weatherData['rainfall']} mm',
                                ),
                                _buildDetailedWeatherStat(
                                  context,
                                  Icons.wb_sunny,
                                  'UV Index',
                                  '${weatherData['uvIndex']}/10',
                                ),
                                _buildDetailedWeatherStat(
                                  context,
                                  Icons.visibility,
                                  'Condition',
                                  weatherData['condition'],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Farming advice based on weather
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: AppTheme.accentOrange,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Farming Advice',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _getWeatherAdvice(weatherData),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedWeatherStat(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryGreen,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getWeatherAdvice(Map<String, dynamic> weather) {
    final condition = weather['condition'].toString().toLowerCase();
    final temp = weather['temperature'] as int;
    final humidity = weather['humidity'] as int;
    
    if (condition.contains('rain')) {
      return 'Good day for irrigation! Rainwater will help your crops. Avoid fertilizer application today.';
    } else if (temp > 35) {
      return 'Very hot day ahead. Ensure adequate irrigation for your crops and provide shade for livestock.';
    } else if (humidity > 80) {
      return 'High humidity may increase fungal disease risk. Monitor your crops closely and ensure good ventilation.';
    } else if (condition.contains('sunny') && temp > 25) {
      return 'Perfect weather for field work! Good day for harvesting and crop maintenance activities.';
    } else {
      return 'Moderate weather conditions. Good day for general farm activities and crop monitoring.';
    }
  }
}
