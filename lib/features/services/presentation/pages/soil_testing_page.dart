import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

/// * SOIL TESTING PAGE
/// * Book soil testing services and view results
/// * Integration with certified soil testing laboratories
class SoilTestingPage extends StatefulWidget {
  const SoilTestingPage({super.key});

  @override
  State<SoilTestingPage> createState() => _SoilTestingPageState();
}

class _SoilTestingPageState extends State<SoilTestingPage> {
  String _selectedTestType = 'Basic';
  final List<String> _testTypes = ['Basic', 'Comprehensive', 'Organic Certification'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Secondary,
      appBar: CustomAppBar(
        title: 'Soil Testing',
        backgroundColor: CropFreshColors.green30Primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // * Test Type Selection
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Test Type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _testTypes.map((type) {
                      final isSelected = type == _selectedTestType;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTestType = type;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? CropFreshColors.green30Primary : Colors.transparent,
                            ),
                            color: isSelected 
                                ? CropFreshColors.green30Primary.withOpacity(0.1) 
                                : Colors.transparent,
                          ),
                          child: Text(
                            type,
                            style: TextStyle(
                              color: isSelected 
                                  ? CropFreshColors.green30Primary 
                                  : CropFreshColors.onBackground60Secondary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // * Test Labs List
          Expanded(
            child: _buildTestLabsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTestLabsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Mock data
      itemBuilder: (context, index) {
        return _buildLabCard(index);
      },
    );
  }

  Widget _buildLabCard(int index) {
    final isGovernmentLab = index % 2 == 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * Lab Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CropFreshColors.green30Container,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isGovernmentLab ? Icons.account_balance : Icons.science,
                  color: CropFreshColors.green30Primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isGovernmentLab 
                          ? 'Government Soil Testing Lab ${index + 1}' 
                          : 'AgriTech Lab ${index + 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${2 + index} km away • ${isGovernmentLab ? 'Government' : 'Private'}',
                      style: TextStyle(
                        color: CropFreshColors.onBackground60Secondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isGovernmentLab 
                      ? CropFreshColors.green30Container 
                      : CropFreshColors.orange10Container,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 12,
                      color: isGovernmentLab 
                          ? CropFreshColors.green30Primary 
                          : CropFreshColors.orange10Primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${4.2 + (index * 0.1)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isGovernmentLab 
                            ? CropFreshColors.green30Primary 
                            : CropFreshColors.orange10Primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // * Test Packages
          _buildTestPackages(),

          const SizedBox(height: 16),

          // * Book Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _bookTest(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: CropFreshColors.green30Primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Book Test',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestPackages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Test Packages',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: CropFreshColors.onBackground60Tertiary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTestType,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CropFreshColors.green30Primary,
                    ),
                  ),
                  Text(
                    _getTestPrice(_selectedTestType),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _getTestDescription(_selectedTestType),
                style: TextStyle(
                  color: CropFreshColors.onBackground60Secondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getTestPrice(String testType) {
    switch (testType) {
      case 'Basic':
        return '₹150';
      case 'Comprehensive':
        return '₹350';
      case 'Organic Certification':
        return '₹500';
      default:
        return '₹150';
    }
  }

  String _getTestDescription(String testType) {
    switch (testType) {
      case 'Basic':
        return 'pH, NPK, Organic Carbon • 3-5 days turnaround';
      case 'Comprehensive':
        return 'pH, NPK, Micro nutrients, Heavy metals • 5-7 days turnaround';
      case 'Organic Certification':
        return 'Full organic compliance test • 7-10 days turnaround';
      default:
        return 'pH, NPK, Organic Carbon • 3-5 days turnaround';
    }
  }

  void _bookTest(int labIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Book Soil Test'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Confirm booking for soil testing?'),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: CropFreshColors.green30Primary),
                const SizedBox(width: 8),
                const Text('Test Details:', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Text('• Sample collection from your farm'),
            const Text('• Digital report delivery'),
            const Text('• Expert interpretation included'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showBookingSuccess();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CropFreshColors.green30Primary,
            ),
            child: const Text('Confirm Booking', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showBookingSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Soil test booking confirmed!'),
          ],
        ),
        backgroundColor: CropFreshColors.green30Primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Show mock test results for demo
    _showTestResults();
  }

  void _showTestResults() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // * Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CropFreshColors.green30Primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.description, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Soil Test Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // * Results Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResultSection('Soil Health Overview', [
                      _buildResultParameter('pH Level', '6.8', 'Optimal', CropFreshColors.green30Primary),
                      _buildResultParameter('Nitrogen (N)', 'Medium', 'Good', CropFreshColors.green30Primary),
                      _buildResultParameter('Phosphorus (P)', 'Medium', 'Good', CropFreshColors.green30Primary),
                      _buildResultParameter('Potassium (K)', 'High', 'Excellent', CropFreshColors.green30Primary),
                      _buildResultParameter('Organic Carbon', '0.8%', 'Good', CropFreshColors.green30Primary),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    _buildRecommendations(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection(String title, List<Widget> parameters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...parameters,
      ],
    );
  }

  Widget _buildResultParameter(String parameter, String value, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              parameter,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommendations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CropFreshColors.orange10Container,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: CropFreshColors.orange10Primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Expert Recommendations',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                '• Your soil pH is optimal for most crops\n'
                '• Consider adding organic compost to improve nitrogen levels\n'
                '• Potassium levels are excellent - maintain current practices\n'
                '• Recommended crops: Tomato, Maize, Cotton',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 