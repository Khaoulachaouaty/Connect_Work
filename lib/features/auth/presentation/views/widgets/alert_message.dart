// lib/auth/presentation/views/widgets/alert_message.dart
import 'package:flutter/material.dart';

class AlertMessageWidget extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const AlertMessageWidget({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}