import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/app_state.dart';
import '../../consultation/screens/consultation_screen.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final appointments = state.patientAppointments;

    if (state.authError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.authError!)));
        context.read<AppState>().clearAuthError();
      });
    }

    return AppShell(
      title: l10n.myAppointments,
      child: appointments.isEmpty
          ? const _EmptyAppointmentsState()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: appointments.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return InfoCard(
                  title: appointment.doctorName,
                  subtitle: DateFormat.yMMMMd().add_jm().format(
                    appointment.dateTime,
                  ),
                  icon: Icons.event_note_outlined,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatusBadge(
                        label: appointment.status,
                        positive: appointment.status != 'Cancelled',
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ConsultationScreen(
                                title: l10n.consultationWithDoctor(
                                  appointment.doctorName,
                                ),
                                channelId: 'healsync-${appointment.id}',
                                appointmentId: appointment.id,
                                patientId: state.currentUser?.id,
                              ),
                            ),
                          );
                        },
                        child: Text(l10n.join),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _EmptyAppointmentsState extends StatelessWidget {
  const _EmptyAppointmentsState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7FF),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.calendar_month_outlined,
                size: 42,
                color: Color(0xFF0D7FD3),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.noAppointmentsYet,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.bookConsultationPrompt,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
