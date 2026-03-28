import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/payment_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.doctorName,
    required this.appointmentDateTime,
    this.amount = 500,
  });

  final String doctorName;
  final DateTime appointmentDateTime;
  final int amount;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  bool _isPaying = false;

  Future<void> _handlePayment() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isPaying = true;
    });

    final success = await _paymentService.simulatePayment();

    if (!mounted) {
      return;
    }

    setState(() {
      _isPaying = false;
    });

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.paymentFailedTryAgain)),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.paymentSuccessful),
        content: Text(l10n.appointmentConfirmedMessage),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formattedDate =
        DateFormat.yMMMMd().add_jm().format(widget.appointmentDateTime);

    return AppShell(
      title: l10n.payment,
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
                    l10n.consultationPayment,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  _PaymentRow(
                    label: l10n.doctorLabel,
                    value: widget.doctorName,
                  ),
                  const SizedBox(height: 14),
                  _PaymentRow(
                    label: l10n.appointmentTime,
                    value: formattedDate,
                  ),
                  const SizedBox(height: 14),
                  _PaymentRow(
                    label: l10n.amount,
                    value: 'Rs. ${widget.amount}',
                    emphasize: true,
                  ),
                  const SizedBox(height: 28),
                  if (_isPaying) ...[
                    const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(l10n.processingPayment),
                    ),
                    const SizedBox(height: 20),
                  ],
                  GradientButton(
                    label: _isPaying ? l10n.processing : l10n.payNow,
                    icon: Icons.payments_outlined,
                    expanded: true,
                    onPressed: _isPaying ? null : _handlePayment,
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

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final valueStyle = emphasize
        ? Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          )
        : Theme.of(context).textTheme.titleMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        Text(value, style: valueStyle),
      ],
    );
  }
}
