// ===================================================================
// * NEGOTIATION PAGE
// * Purpose: Handle price negotiations between buyers and sellers
// * Features: Chat interface, price offers, negotiation history
// ===================================================================

import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_app_bar.dart';

class NegotiationPage extends StatelessWidget {
  final String negotiationId;

  const NegotiationPage({
    super.key,
    required this.negotiationId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Negotiation',
      ),
      body: Column(
        children: [
          // Product Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.agriculture),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fresh Tomatoes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text('₹25/kg - 100kg'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Chat Messages
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                Text(
                  'Start negotiating for the best price!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // TODO: Send message
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 