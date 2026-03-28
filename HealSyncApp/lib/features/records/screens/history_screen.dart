import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_shell.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/record_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
    required this.patientId,
    required this.title,
  });

  final String patientId;
  final String title;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final RecordService _recordService = RecordService();
  late Future<List<RecordHistoryItem>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = _recordService.getRecords(widget.patientId);
  }

  @override
  void dispose() {
    _recordService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppShell(
      title: widget.title,
      child: FutureBuilder<List<RecordHistoryItem>>(
        future: _recordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  snapshot.error.toString().replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final records = snapshot.data ?? const [];
          if (records.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.noMedicalHistoryFound),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: records.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RecordPreview(record: record),
                      const SizedBox(height: 14),
                      Text(
                        record.condition,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.prescriptionLabel(record.prescription)),
                      const SizedBox(height: 8),
                      Text(
                        l10n.dateLabel(_formatDate(record.date)),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(String value) {
    if (value.isEmpty) {
      return '-';
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value;
    }
    return DateFormat.yMMMd().format(parsed);
  }
}

class _RecordPreview extends StatelessWidget {
  const _RecordPreview({required this.record});

  final RecordHistoryItem record;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!record.hasFile) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.notes_outlined),
        title: Text(l10n.noFileAttached),
      );
    }

    if (record.isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.network(
          record.fileUrl,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const _FileFallback(),
        ),
      );
    }

    if (record.isPdf) {
      return _FileFallback(
        icon: Icons.picture_as_pdf_outlined,
        label: l10n.pdfFileAttached,
      );
    }

    return _FileFallback(
      label: record.fileName.isEmpty ? l10n.fileAttached : record.fileName,
    );
  }
}

class _FileFallback extends StatelessWidget {
  const _FileFallback({
    this.icon = Icons.insert_drive_file_outlined,
    this.label = 'File attached',
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FAFF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
