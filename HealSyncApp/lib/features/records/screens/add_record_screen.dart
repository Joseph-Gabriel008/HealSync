import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/models/app_models.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/record_service.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({
    super.key,
    required this.doctor,
    required this.patient,
  });

  final UserProfile doctor;
  final UserProfile patient;

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _conditionController = TextEditingController();
  final _prescriptionController = TextEditingController();
  final RecordService _recordService = RecordService();
  Uint8List? _selectedBytes;
  String? _selectedFileName;
  bool _saving = false;

  @override
  void dispose() {
    _conditionController.dispose();
    _prescriptionController.dispose();
    _recordService.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result == null || result.files.single.bytes == null) {
      return;
    }

    setState(() {
      _selectedBytes = result.files.single.bytes;
      _selectedFileName = result.files.single.name;
    });
  }

  Future<void> _saveRecord() async {
    final l10n = AppLocalizations.of(context)!;

    if (_conditionController.text.trim().isEmpty ||
        _prescriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.conditionPrescriptionRequired),
        ),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await _recordService.addRecord(
        patientId: widget.patient.id,
        doctorId: widget.doctor.id,
        patientName: widget.patient.name,
        condition: _conditionController.text.trim(),
        prescription: _prescriptionController.text.trim(),
        fileName: _selectedFileName,
        fileBytes: _selectedBytes,
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppShell(
      title: l10n.addRecordTitle,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.patientLabel(widget.patient.name)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _conditionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: l10n.condition,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _prescriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: l10n.prescription,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _saving ? null : _pickFile,
                    icon: const Icon(Icons.attach_file_outlined),
                    label: Text(
                      _selectedFileName ?? l10n.uploadFileOptional,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GradientButton(
                    label: _saving ? l10n.saving : l10n.saveRecord,
                    icon: Icons.save_outlined,
                    expanded: true,
                    onPressed: _saving ? null : _saveRecord,
                  ),
                  if (_saving) ...[
                    const SizedBox(height: 16),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
