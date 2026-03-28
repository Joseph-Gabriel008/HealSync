import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../../core/models/app_models.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/info_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/app_state.dart';
import '../../../services/prescription_service.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({super.key});

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  final PrescriptionService _prescriptionService = PrescriptionService();
  Map<String, SavedPrescriptionFile> _savedByPrescriptionId = const {};
  bool _loadingSaved = true;

  @override
  void initState() {
    super.initState();
    _loadSavedPrescriptions();
  }

  Future<void> _loadSavedPrescriptions() async {
    final saved = await _prescriptionService.getSavedPrescriptions();
    if (!mounted) {
      return;
    }

    setState(() {
      _savedByPrescriptionId = {
        for (final item in saved) item.prescriptionId: item,
      };
      _loadingSaved = false;
    });
  }

  Future<void> _downloadPrescription(
    BuildContext context,
    Prescription prescription,
    String patientName,
  ) async {
    try {
      final bytes = await _prescriptionService.generatePrescriptionPDF(
        PrescriptionPdfData(
          prescriptionId: prescription.id,
          patientName: patientName,
          doctorName: prescription.doctorName,
          date: prescription.createdAt,
          condition: prescription.condition,
          prescription: prescription.medication,
          notes: prescription.notes,
        ),
      );
      await _prescriptionService.savePDFLocally(
        prescriptionId: prescription.id,
        bytes: bytes,
      );
      await _loadSavedPrescriptions();
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prescription saved successfully')),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to save file')));
    }
  }

  Future<void> _previewPrescription(
    BuildContext context,
    Prescription prescription,
    String patientName, {
    SavedPrescriptionFile? savedFile,
  }) async {
    Uint8List bytes;
    try {
      if (savedFile != null && File(savedFile.filePath).existsSync()) {
        bytes = await File(savedFile.filePath).readAsBytes();
      } else {
        bytes = await _prescriptionService.generatePrescriptionPDF(
          PrescriptionPdfData(
            prescriptionId: prescription.id,
            patientName: patientName,
            doctorName: prescription.doctorName,
            date: prescription.createdAt,
            condition: prescription.condition,
            prescription: prescription.medication,
            notes: prescription.notes,
          ),
        );
      }
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open prescription')),
      );
      return;
    }

    if (!context.mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _PrescriptionPreviewScreen(
          title: prescription.medication,
          bytes: bytes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final prescriptions = state.patientPrescriptions;
    final patientName = state.currentUser?.name ?? 'Patient';

    return AppShell(
      title: l10n.prescriptionsTitle,
      actions: [
        IconButton(
          onPressed: _loadingSaved ? null : _loadSavedPrescriptions,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      child: prescriptions.isEmpty
          ? const Center(child: Text('No prescriptions available yet.'))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: prescriptions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final prescription = prescriptions[index];
                final savedFile = _savedByPrescriptionId[prescription.id];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoCard(
                          title: prescription.medication,
                          subtitle:
                              '${prescription.doctorName} - ${DateFormat.yMMMd().format(prescription.createdAt)}\nCondition: ${prescription.condition.isEmpty ? 'General consultation' : prescription.condition}\n${prescription.notes}',
                          icon: Icons.description,
                          trailing: Icon(
                            savedFile == null
                                ? Icons.picture_as_pdf_outlined
                                : Icons.download_done_rounded,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            FilledButton.tonalIcon(
                              onPressed: () => _previewPrescription(
                                context,
                                prescription,
                                patientName,
                                savedFile: savedFile,
                              ),
                              icon: const Icon(Icons.visibility_outlined),
                              label: const Text('View PDF'),
                            ),
                            FilledButton.icon(
                              onPressed: () => _downloadPrescription(
                                context,
                                prescription,
                                patientName,
                              ),
                              icon: const Icon(Icons.download_rounded),
                              label: Text(
                                savedFile == null
                                    ? 'Download Prescription'
                                    : 'Save Again',
                              ),
                            ),
                            if (savedFile != null)
                              Text(
                                'Saved offline: ${savedFile.fileName}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _PrescriptionPreviewScreen extends StatelessWidget {
  const _PrescriptionPreviewScreen({required this.title, required this.bytes});

  final String title;
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: title,
      child: PdfPreview(
        build: (format) async => bytes,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        allowPrinting: true,
        allowSharing: false,
      ),
    );
  }
}
