import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../services/app_state.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  final _patientNameController = TextEditingController();
  Uint8List? _selectedBytes;
  String? _selectedFileName;
  bool _isImagePreview = false;

  @override
  void dispose() {
    _patientNameController.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (image == null) {
      return;
    }

    final bytes = await image.readAsBytes();
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedBytes = bytes;
      _selectedFileName = image.name;
      _isImagePreview = true;
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (result == null || result.files.single.bytes == null) {
      return;
    }

    if (!mounted) {
      return;
    }
    final name = result.files.single.name;
    setState(() {
      _selectedBytes = result.files.single.bytes!;
      _selectedFileName = name;
      _isImagePreview =
          name.toLowerCase().endsWith('.png') ||
          name.toLowerCase().endsWith('.jpg') ||
          name.toLowerCase().endsWith('.jpeg');
    });
  }

  Future<void> _uploadRecord(BuildContext context) async {
    final state = context.read<AppState>();
    if (_selectedBytes == null || _selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a file before uploading.')),
      );
      return;
    }
    if (_patientNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter the patient name first.')),
      );
      return;
    }

    try {
      await state.uploadRecord(
        patientName: _patientNameController.text,
        selectedFileName: _selectedFileName!,
        bytes: _selectedBytes!,
      );
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Medical record uploaded and stored on the local blockchain.',
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      final message =
          state.authError ?? 'We could not upload the medical record.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 430;
    final state = context.watch<AppState>();
    final records = state.visibleRecords;

    return AppShell(
      title: 'Medical Records',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: isCompact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Send a medical record to your local backend and store its filename on your local Ganache blockchain.',
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _patientNameController,
                          decoration: const InputDecoration(
                            labelText: 'Patient Name',
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_selectedFileName != null) ...[
                          _SelectedFilePreview(
                            fileName: _selectedFileName!,
                            bytes: _selectedBytes,
                            isImagePreview: _isImagePreview,
                          ),
                          const SizedBox(height: 16),
                        ],
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            OutlinedButton.icon(
                              onPressed: state.isBusy ? null : _pickFromGallery,
                              icon: const Icon(Icons.photo_library_outlined),
                              label: const Text('Gallery'),
                            ),
                            OutlinedButton.icon(
                              onPressed: state.isBusy ? null : _pickFile,
                              icon: const Icon(Icons.attach_file_outlined),
                              label: const Text('Files'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GradientButton(
                          label: state.isBusy
                              ? 'Uploading...'
                              : 'Upload Medical Record',
                          icon: Icons.upload_file_outlined,
                          expanded: true,
                          onPressed: state.isBusy
                              ? null
                              : () => _uploadRecord(context),
                        ),
                        if (state.isBusy) ...[
                          const SizedBox(height: 16),
                          const Center(child: CircularProgressIndicator()),
                        ],
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Send a medical record to your local backend and store its filename on your local Ganache blockchain.',
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _patientNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Patient Name',
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (_selectedFileName != null) ...[
                                _SelectedFilePreview(
                                  fileName: _selectedFileName!,
                                  bytes: _selectedBytes,
                                  isImagePreview: _isImagePreview,
                                ),
                                const SizedBox(height: 16),
                              ],
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: state.isBusy
                                        ? null
                                        : _pickFromGallery,
                                    icon: const Icon(
                                      Icons.photo_library_outlined,
                                    ),
                                    label: const Text('Gallery'),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: state.isBusy ? null : _pickFile,
                                    icon: const Icon(
                                      Icons.attach_file_outlined,
                                    ),
                                    label: const Text('Files'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          children: [
                            GradientButton(
                              label: state.isBusy
                                  ? 'Uploading...'
                                  : 'Upload Medical Record',
                              icon: Icons.upload_file_outlined,
                              onPressed: state.isBusy
                                  ? null
                                  : () => _uploadRecord(context),
                            ),
                            if (state.isBusy) ...[
                              const SizedBox(height: 16),
                              const CircularProgressIndicator(),
                            ],
                          ],
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),
          ...records.map(
            (record) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InfoCard(
                title: record.fileName,
                subtitle:
                    '${DateFormat.yMMMd().add_jm().format(record.uploadedAt)}\nRef: ${record.referenceCode}\nSource: ${record.sourceLabel}',
                icon: Icons.insert_drive_file_outlined,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StatusBadge(
                      label: record.verified ? 'Verified' : 'Not Verified',
                      positive: record.verified,
                    ),
                    const SizedBox(height: 8),
                    Text('${record.accessedBy.length} audits'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Audit Trail',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ...state.auditTrail.map(
            (event) => ListTile(
              tileColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 6,
              ),
              isThreeLine: isCompact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(event.action),
              subtitle: Text(
                '${DateFormat.yMMMd().add_jm().format(event.timestamp)}${isCompact ? '\n${event.actorName}' : ''}',
              ),
              trailing: isCompact ? null : Text(event.actorName),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedFilePreview extends StatelessWidget {
  const _SelectedFilePreview({
    required this.fileName,
    required this.bytes,
    required this.isImagePreview,
  });

  final String fileName;
  final Uint8List? bytes;
  final bool isImagePreview;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FAFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selected File', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(fileName),
          if (bytes != null && isImagePreview) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.memory(
                bytes!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.insert_drive_file_outlined),
                SizedBox(width: 8),
                Expanded(child: Text('Preview available for image files only')),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
