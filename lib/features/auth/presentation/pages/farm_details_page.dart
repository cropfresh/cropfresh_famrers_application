import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FarmDetailsPage extends StatelessWidget {
  const FarmDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farm Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Farm Details Page'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/document-upload'),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
} 