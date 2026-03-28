import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/app_state.dart';
import 'payment_screen.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _doctorId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final doctors = state.doctors;
    final selectedDoctor = _doctorId == null
        ? null
        : doctors.cast().firstWhere((doctor) => doctor.id == _doctorId);

    return AppShell(
      title: l10n.bookAppointment,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (doctors.isEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E8),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        l10n.noDoctorAccountAvailable,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  DropdownButtonFormField<String>(
                    initialValue: _doctorId,
                    decoration: InputDecoration(
                      labelText: l10n.selectDoctor,
                    ),
                    items: doctors
                        .map(
                          (doctor) => DropdownMenuItem(
                            value: doctor.id,
                            child: Text(l10n.telemedicineSuffix(doctor.name)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _doctorId = value),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    title: Text(l10n.consultationDateTime),
                    subtitle: Text(
                      DateFormat.yMMMMd().add_jm().format(_selectedDate),
                    ),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: _selectedDate,
                      );
                      if (date == null || !context.mounted) {
                        return;
                      }

                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_selectedDate),
                      );
                      if (time == null) {
                        return;
                      }

                      setState(() {
                        _selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  GradientButton(
                    label: l10n.confirmBooking,
                    icon: Icons.check_circle_outline,
                    onPressed: _doctorId == null
                        ? null
                        : () async {
                            final paymentSuccess =
                                await Navigator.of(context).push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => PaymentScreen(
                                      doctorName:
                                          selectedDoctor?.name ??
                                          l10n.doctorLabel,
                                      appointmentDateTime: _selectedDate,
                                    ),
                                  ),
                                );
                            if (paymentSuccess != true || !context.mounted) {
                              return;
                            }

                            await state.bookAppointment(
                              _doctorId!,
                              _selectedDate,
                            );
                            if (!context.mounted) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.appointmentConfirmed),
                              ),
                            );
                            Navigator.pop(context);
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
