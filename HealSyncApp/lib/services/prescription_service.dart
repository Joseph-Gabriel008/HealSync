import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

class PrescriptionPdfData {
  const PrescriptionPdfData({
    required this.prescriptionId,
    required this.patientName,
    required this.doctorName,
    required this.date,
    required this.condition,
    required this.prescription,
    required this.notes,
  });

  final String prescriptionId;
  final String patientName;
  final String doctorName;
  final DateTime date;
  final String condition;
  final String prescription;
  final String notes;
}

class SavedPrescriptionFile {
  const SavedPrescriptionFile({
    required this.prescriptionId,
    required this.filePath,
    required this.fileName,
    required this.savedAt,
  });

  final String prescriptionId;
  final String filePath;
  final String fileName;
  final DateTime savedAt;

  factory SavedPrescriptionFile.fromJson(Map<String, dynamic> json) {
    return SavedPrescriptionFile(
      prescriptionId: (json['prescriptionId'] ?? '').toString(),
      filePath: (json['filePath'] ?? '').toString(),
      fileName: (json['fileName'] ?? '').toString(),
      savedAt: DateTime.tryParse((json['savedAt'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prescriptionId': prescriptionId,
      'filePath': filePath,
      'fileName': fileName,
      'savedAt': savedAt.toIso8601String(),
    };
  }
}

class PrescriptionService {
  static const _storageKey = 'healsync.saved_prescriptions';

  Future<Uint8List> generatePrescriptionPDF(PrescriptionPdfData data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            'HealSync',
            style: pw.TextStyle(
              fontSize: 26,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue700,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Medical Prescription',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 20),
          _sectionTitle('Consultation Details'),
          _detailRow('Doctor', data.doctorName),
          _detailRow('Patient', data.patientName),
          _detailRow('Date', _formatDate(data.date)),
          _detailRow('Condition', data.condition.isEmpty ? 'General Consultation' : data.condition),
          pw.SizedBox(height: 18),
          _sectionTitle('Medicines'),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Text(data.prescription),
          ),
          pw.SizedBox(height: 18),
          _sectionTitle('Notes'),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Text(data.notes.isEmpty ? 'No additional notes.' : data.notes),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  Future<String> savePDFLocally({
    required String prescriptionId,
    required Uint8List bytes,
  }) async {
    final directory = await _prescriptionsDirectory();
    await directory.create(recursive: true);

    final fileName =
        'prescription-$prescriptionId-${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${directory.path}${Platform.pathSeparator}$fileName');
    await file.writeAsBytes(bytes, flush: true);

    final saved = SavedPrescriptionFile(
      prescriptionId: prescriptionId,
      filePath: file.path,
      fileName: fileName,
      savedAt: DateTime.now(),
    );
    await _persistSavedFile(saved);
    return file.path;
  }

  Future<List<SavedPrescriptionFile>> getSavedPrescriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const [];
    }

    final files = decoded
        .whereType<Map>()
        .map((item) => SavedPrescriptionFile.fromJson(Map<String, dynamic>.from(item)))
        .where((item) => File(item.filePath).existsSync())
        .toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return files;
  }

  Future<void> _persistSavedFile(SavedPrescriptionFile file) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getSavedPrescriptions();
    final filtered =
        existing.where((entry) => entry.prescriptionId != file.prescriptionId).toList();
    filtered.add(file);
    await prefs.setString(
      _storageKey,
      jsonEncode(filtered.map((entry) => entry.toJson()).toList()),
    );
  }

  Future<Directory> _prescriptionsDirectory() async {
    final baseDir = Platform.isAndroid
        ? (await getExternalStorageDirectory()) ?? await getApplicationDocumentsDirectory()
        : await getApplicationDocumentsDirectory();
    return Directory(
      '${baseDir.path}${Platform.pathSeparator}HealSync${Platform.pathSeparator}prescriptions',
    );
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blueGrey800,
        ),
      ),
    );
  }

  pw.Widget _detailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 86,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
