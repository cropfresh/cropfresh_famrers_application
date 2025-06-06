import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DocumentUploadPage extends StatelessWidget {
  const DocumentUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Document Upload')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Document Upload Page'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Complete Setup'),
            ),
          ],
        ),
      ),
    );
  }
} 