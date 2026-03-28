import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/app_models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/info_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/app_state.dart';
import '../../consultation/screens/consultation_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../records/screens/records_screen.dart';
import 'patient_list_screen.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (!mounted) {
        return;
      }

      unawaited(context.read<AppState>().refreshAppData());
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final doctor = state.currentUser!;

    if (state.authSuccess != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.authSuccess!)));
        context.read<AppState>().clearAuthSuccess();
      });
    }

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
      title: l10n.doctorDashboardTitle,
      actions: [
        IconButton(
          onPressed: state.isBusy
              ? null
              : () => context.read<AppState>().refreshAppData(),
          tooltip: 'Refresh appointments',
          icon: const Icon(Icons.refresh_rounded),
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          ),
          icon: const Icon(Icons.account_circle_outlined),
        ),
        IconButton(
          onPressed: () async {
            await context.read<AppState>().logout();
          },
          tooltip: l10n.logout,
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
      child: RefreshIndicator(
        onRefresh: () => context.read<AppState>().refreshAppData(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _DoctorHero(
              title: l10n.doctorGreeting(doctor.name),
              subtitle: l10n.doctorHeroSubtitle,
              appointmentCount: '${state.doctorAppointments.length}',
              patientCount: '${state.patients.length}',
              appointmentLabel: l10n.appointmentsLabel,
              patientLabel: l10n.patientsLabel,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.quickActions,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              GradientButton(
                                label: l10n.patientList,
                                icon: Icons.groups_2_outlined,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PatientListScreen(),
                                  ),
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RecordsScreen(),
                                  ),
                                ),
                                icon: const Icon(Icons.verified_outlined),
                                label: Text(l10n.recordsHub),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.upcomingConsultations,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (state.doctorAppointments.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Center(child: Text('No appointments yet')),
              ),
            ...state.doctorAppointments.map(
              (appointment) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InfoCard(
                  title: appointment.patientName,
                  subtitle: _appointmentSubtitle(appointment),
                  icon: appointment.status.toLowerCase().contains('emergency')
                      ? Icons.emergency_share_outlined
                      : Icons.monitor_heart_outlined,
                  trailing: GradientButton(
                    label:
                        appointment.status.toLowerCase().contains('emergency')
                        ? 'Accept'
                        : l10n.start,
                    icon: appointment.status.toLowerCase().contains('emergency')
                        ? Icons.notifications_active_outlined
                        : Icons.play_arrow,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConsultationScreen(
                          title: l10n.consultationWithDoctor(
                            appointment.patientName,
                          ),
                          channelId: 'healsync-${appointment.id}',
                          appointmentId: appointment.id,
                          patientId: appointment.patientId,
                          allowDiagnosisActions: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _appointmentSubtitle(Appointment appointment) {
    final consultantLine = appointment.consultantNames.isEmpty
        ? ''
        : '\nConsultants: ${appointment.consultantNames.join(', ')}';
    if (appointment.status.toLowerCase().contains('emergency')) {
      return '${appointment.status}\nPatient is waiting for an emergency video session.$consultantLine';
    }
    return '${appointment.status}\nRemote consultation ready$consultantLine';
  }
}

class _DoctorHero extends StatelessWidget {
  const _DoctorHero({
    required this.title,
    required this.subtitle,
    required this.appointmentCount,
    required this.patientCount,
    required this.appointmentLabel,
    required this.patientLabel,
  });

  final String title;
  final String subtitle;
  final String appointmentCount;
  final String patientCount;
  final String appointmentLabel;
  final String patientLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A60B1), Color(0xFF1295D7), Color(0xFF55C63D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.blue.withValues(alpha: 0.16),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, height: 1.45),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _MetricTile(value: appointmentCount, label: appointmentLabel),
              const SizedBox(width: 12),
              _MetricTile(value: patientCount, label: patientLabel),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
