import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../services/app_state.dart';

class MedicalHistoryEditorScreen extends StatefulWidget {
  const MedicalHistoryEditorScreen({super.key});

  @override
  State<MedicalHistoryEditorScreen> createState() =>
      _MedicalHistoryEditorScreenState();
}

class _MedicalHistoryEditorScreenState
    extends State<MedicalHistoryEditorScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _controller = TextEditingController(
      text: state.currentUser?.medicalHistory ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return AppShell(
      title: 'Medical History',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add previous health conditions for the doctor to review during consultation.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText:
                          'Example: BP for 5 years, diabetes, thyroid, asthma, regular medicines, allergies, previous surgeries.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GradientButton(
                    label: state.isBusy ? 'Saving...' : 'Save Medical History',
                    icon: Icons.save_outlined,
                    onPressed: state.isBusy
                        ? null
                        : () async {
                            await state.updateMedicalHistory(
                              medicalHistory: _controller.text.trim(),
                            );
                            if (!context.mounted) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Medical history updated'),
                              ),
                            );
                          },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
