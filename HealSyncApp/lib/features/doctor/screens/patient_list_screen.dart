import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/info_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/app_state.dart';
import '../../records/screens/history_screen.dart';

class PatientListScreen extends StatelessWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();

    return AppShell(
      title: l10n.patientList,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: state.patients.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final patient = state.patients[index];
          final accessGranted = state.hasDoctorAccess(patient.id);
          return InfoCard(
            title: patient.name,
            subtitle: patient.email,
            icon: Icons.person_outline,
            trailing: Wrap(
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryScreen(
                        patientId: patient.id,
                        title: l10n.historyTitle(patient.name),
                      ),
                    ),
                  ),
                  child: Text(l10n.records),
                ),
                FilledButton.tonal(
                  onPressed: () async {
                    try {
                      await state.toggleDoctorAccess(patient.id);
                      if (!context.mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            accessGranted
                                ? l10n.doctorAccessRevoked
                                : l10n.doctorAccessGranted,
                          ),
                        ),
                      );
                    } catch (_) {
                      if (!context.mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.updateAccessPermissionsError),
                        ),
                      );
                    }
                  },
                  child: Text(
                    accessGranted ? l10n.revokeAccess : l10n.grantAccess,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
