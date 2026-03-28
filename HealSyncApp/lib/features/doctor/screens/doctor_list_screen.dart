import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/models/app_models.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/doctor_service.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final DoctorService _doctorService = DoctorService();
  final TextEditingController _searchController = TextEditingController();

  List<DoctorDirectoryItem> _doctors = const [];
  bool _loading = true;
  String _selectedCategory = 'all';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    unawaited(_loadDoctors());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _doctorService.dispose();
    super.dispose();
  }

  Future<void> _loadDoctors() async {
    setState(() {
      _loading = true;
    });

    try {
      final doctors = await _doctorService.getDoctors(
        category: _apiCategory(_selectedCategory),
        search: _searchController.text,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _doctors = doctors;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      unawaited(_loadDoctors());
    });
  }

  String? _apiCategory(String key) {
    switch (key) {
      case 'cardiology':
        return 'Cardiology';
      case 'dermatology':
        return 'Dermatology';
      case 'general':
        return 'General';
      case 'pediatrics':
        return 'Pediatrics';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = <_LocalizedCategory>[
      _LocalizedCategory('all', l10n.all),
      _LocalizedCategory('cardiology', l10n.cardiology),
      _LocalizedCategory('dermatology', l10n.dermatology),
      _LocalizedCategory('general', l10n.general),
      _LocalizedCategory('pediatrics', l10n.pediatrics),
    ];

    return AppShell(
      title: l10n.doctorLabel,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: l10n.searchByDoctorName,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          unawaited(_loadDoctors());
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final category = categories[index];
                final selected = category.key == _selectedCategory;
                return ChoiceChip(
                  label: Text(category.label),
                  selected: selected,
                  onSelected: (_) {
                    if (_selectedCategory == category.key) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = category.key;
                    });
                    unawaited(_loadDoctors());
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemCount: categories.length,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _doctors.isEmpty
                ? Center(
                    child: Text(l10n.noDoctorsFound),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _doctors.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final doctor = _doctors[index];
                      return _DoctorCard(doctor: doctor);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.doctor});

  final DoctorDirectoryItem doctor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              child: Text(
                doctor.name.isEmpty ? 'D' : doctor.name.substring(0, 1),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(doctor.specialization),
                  const SizedBox(height: 6),
                  Text(l10n.experienceValue(doctor.experience)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(doctor.rating.toStringAsFixed(1)),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF7FF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(doctor.category),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocalizedCategory {
  const _LocalizedCategory(this.key, this.label);

  final String key;
  final String label;
}
