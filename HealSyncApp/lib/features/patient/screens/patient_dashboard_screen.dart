import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/app_state.dart';
import '../../consultation/screens/consultation_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../records/screens/health_passport_screen.dart';
import '../../records/screens/records_screen.dart';
import 'appointments_screen.dart';
import 'medical_history_editor_screen.dart';
import 'offline_emergency_tips_screen.dart';
import 'book_appointment_screen.dart';
import 'chat_screen.dart';
import 'prescriptions_screen.dart';

class PatientDashboardScreen extends StatelessWidget {
  const PatientDashboardScreen({super.key});

  Future<void> _handleEmergencyConsultantRequest(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final appointment = await context
          .read<AppState>()
          .requestEmergencyConsultant();
      if (!context.mounted) {
        return;
      }

      final shouldConnect = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Emergency consultant notified'),
            content: Text(
              '${appointment.doctorName} is the current available consultant. Tap OK to connect the emergency video session now.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Later'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      if (shouldConnect == true && context.mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ConsultationScreen(
              title: 'Emergency consultation with ${appointment.doctorName}',
              channelId: 'healsync-${appointment.id}',
              appointmentId: appointment.id,
              patientId: appointment.patientId,
            ),
          ),
        );
      }
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 430;
    final state = context.watch<AppState>();
    final user = state.currentUser!;
    final appointments = state.patientAppointments;
    final nextAppointment = appointments.isEmpty ? null : appointments.first;

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
      title: l10n.patientDashboardTitle,
      actions: [
        IconButton(
          onPressed: state.isBusy
              ? null
              : () => context.read<AppState>().refreshAppData(),
          tooltip: 'Refresh dashboard',
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
            _HeroPanel(
              title: l10n.welcomeBackUser(user.name),
              subtitle: l10n.patientHeroSubtitle,
              statOne: '${state.patientRecords.length}',
              statOneLabel: l10n.verifiedRecordsLabel,
              statTwo: '${appointments.length}',
              statTwoLabel: l10n.appointmentsLabel,
              actions: [
                GradientButton(
                  label: l10n.bookAppointment,
                  icon: Icons.calendar_month,
                  expanded: isCompact,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BookAppointmentScreen(),
                    ),
                  ),
                ),
                SizedBox(
                  width: isCompact ? double.infinity : null,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.9),
                        width: 1.4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RecordsScreen()),
                    ),
                    icon: const Icon(Icons.upload_file_outlined),
                    label: Text(
                      l10n.uploadRecord,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (nextAppointment != null)
              InfoCard(
                title: l10n.nextConsultation,
                subtitle:
                    '${nextAppointment.doctorName}\n${DateFormat.yMMMd().add_jm().format(nextAppointment.dateTime)}',
                icon: Icons.videocam_outlined,
                trailing: GradientButton(
                  label: l10n.join,
                  icon: Icons.call,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConsultationScreen(
                        title: l10n.consultationWithDoctor(
                          nextAppointment.doctorName,
                        ),
                        channelId: 'healsync-${nextAppointment.id}',
                        appointmentId: nextAppointment.id,
                        patientId: user.id,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            InfoCard(
              title: 'Emergency Consultant',
              subtitle:
                  'Need urgent help? Notify the current available consultant and connect the video session as soon as they are assigned.',
              icon: Icons.emergency_outlined,
              trailing: GradientButton(
                label: 'Connect Now',
                icon: Icons.notifications_active_outlined,
                onPressed: state.isBusy
                    ? null
                    : () => _handleEmergencyConsultantRequest(context),
              ),
            ),
            const SizedBox(height: 20),
            InfoCard(
              title: 'AI Health Assistant',
              subtitle:
                  'Ask for general health suggestions with text, voice, or an image placeholder review. Severe symptoms will be redirected to a doctor.',
              icon: Icons.smart_toy_outlined,
              trailing: GradientButton(
                label: 'Open Chat',
                icon: Icons.chat_bubble_outline,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _QuickLinkGrid(
              items: [
                _QuickLinkItem(
                  title: l10n.appointmentsLabel,
                  subtitle: l10n.trackBookingsStatuses,
                  icon: Icons.event_available,
                  accent: AppTheme.softBlue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppointmentsScreen(),
                    ),
                  ),
                ),
                _QuickLinkItem(
                  title: l10n.medicalHistory,
                  subtitle:
                      'Add past conditions and regular medicines for doctors to review during consultation.',
                  icon: Icons.folder_shared_outlined,
                  accent: AppTheme.softGreen,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MedicalHistoryEditorScreen(),
                    ),
                  ),
                ),
                _QuickLinkItem(
                  title: l10n.prescriptionsTitle,
                  subtitle: l10n.doctorMedicationsNotes,
                  icon: Icons.description_outlined,
                  accent: const Color(0xFFEAF7FF),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrescriptionsScreen(),
                    ),
                  ),
                ),
                _QuickLinkItem(
                  title: 'Offline Emergency Tips',
                  subtitle:
                      '15 quick first-aid life hacks available even without internet.',
                  icon: Icons.health_and_safety_outlined,
                  accent: const Color(0xFFFDEFD8),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OfflineEmergencyTipsScreen(),
                    ),
                  ),
                ),
                _QuickLinkItem(
                  title: l10n.healthPassport,
                  subtitle: l10n.portableVerifiedProfile,
                  icon: Icons.verified_user_outlined,
                  accent: const Color(0xFFF1FDEA),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HealthPassportScreen(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.recentRecords,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...state.patientRecords
                .take(3)
                .map(
                  (record) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InfoCard(
                      title: record.fileName,
                      subtitle: l10n.referenceCode(record.referenceCode),
                      icon: Icons.health_and_safety_outlined,
                      trailing: StatusBadge(
                        label: record.verified
                            ? l10n.verified
                            : l10n.notVerified,
                        positive: record.verified,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.title,
    required this.subtitle,
    required this.statOne,
    required this.statOneLabel,
    required this.statTwo,
    required this.statTwoLabel,
    required this.actions,
  });

  final String title;
  final String subtitle;
  final String statOne;
  final String statOneLabel;
  final String statTwo;
  final String statTwoLabel;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 430;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient,
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
            style: const TextStyle(
              color: Colors.white,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _StatPill(value: statOne, label: statOneLabel),
              _StatPill(value: statTwo, label: statTwoLabel),
            ],
          ),
          const SizedBox(height: 22),
          if (isCompact)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = 0; index < actions.length; index++) ...[
                  actions[index],
                  if (index != actions.length - 1) const SizedBox(height: 12),
                ],
              ],
            )
          else
            Wrap(spacing: 12, runSpacing: 12, children: actions),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickLinkGrid extends StatelessWidget {
  const _QuickLinkGrid({required this.items});

  final List<_QuickLinkItem> items;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 430;
    final localeCode = Localizations.localeOf(context).languageCode;
    final usesTallScript = localeCode == 'ta' || localeCode == 'ml';

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: usesTallScript
            ? (isCompact ? 0.72 : 0.88)
            : (isCompact ? 0.86 : 1.0),
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: item.onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: item.accent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(item.icon, color: AppTheme.deepBlue),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    item.title,
                    maxLines: usesTallScript ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      height: usesTallScript ? 1.2 : 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      item.subtitle,
                      maxLines: usesTallScript
                          ? (isCompact ? 4 : 3)
                          : (isCompact ? 3 : 2),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.ink.withValues(alpha: 0.78),
                        height: usesTallScript ? 1.28 : 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickLinkItem {
  const _QuickLinkItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
}
