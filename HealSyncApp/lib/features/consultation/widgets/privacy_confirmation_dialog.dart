import 'package:flutter/material.dart';

class PrivacyConfirmationDialog extends StatelessWidget {
  const PrivacyConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Privacy Confirmation'),
      content: const Text(
        'You are about to start a video consultation. Your camera and microphone will be used. This consultation will be recorded for medical purposes. Do you want to continue?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Allow'),
        ),
      ],
    );
  }
}
