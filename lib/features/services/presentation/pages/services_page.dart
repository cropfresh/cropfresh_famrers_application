import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Services'),
      body: Center(child: Text('Services Page - Coming Soon')),
    );
  }
} 