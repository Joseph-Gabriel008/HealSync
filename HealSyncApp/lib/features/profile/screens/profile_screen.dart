import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/app_models.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../services/app_state.dart';
import '../../../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const List<String> _doctorSpecialties = [
    'Neurologist',
    'Cardiologist',
    'Dermatologist',
    'Pediatrician',
    'Orthopedic',
    'General Physician',
    'Psychiatrist',
    'Other',
  ];

  final ProfileService _profileService = ProfileService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _otherSpecializationController =
      TextEditingController();

  UserProfile? _profile;
  bool _loading = true;
  bool _saving = false;
  bool _editing = false;
  String _selectedGender = '';
  String _selectedSpecialization = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _otherSpecializationController.dispose();
    _profileService.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final currentUser = context.read<AppState>().currentUser;
    if (currentUser == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final profile = await _profileService.getProfile(currentUser.id);
      if (!mounted) {
        return;
      }
      _applyProfile(profile);
      setState(() {
        _profile = profile;
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

  void _applyProfile(UserProfile profile) {
    _nameController.text = profile.name;
    _phoneController.text = profile.phone;
    _ageController.text = profile.age?.toString() ?? '';
    _selectedGender = profile.gender;
    final specialization = profile.specialization.trim();
    if (specialization.isEmpty) {
      _selectedSpecialization = '';
      _otherSpecializationController.clear();
      return;
    }
    if (_doctorSpecialties.contains(specialization)) {
      _selectedSpecialization = specialization;
      _otherSpecializationController.clear();
      return;
    }
    _selectedSpecialization = 'Other';
    _otherSpecializationController.text = specialization;
  }

  Future<void> _saveProfile() async {
    final profile = _profile;
    if (profile == null) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final specialization = profile.isDoctor
        ? (_selectedSpecialization == 'Other'
              ? _otherSpecializationController.text.trim()
              : _selectedSpecialization.trim())
        : profile.specialization;

    try {
      final updated = await _profileService.updateProfile(
        userId: profile.id,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        age: int.tryParse(_ageController.text.trim()),
        gender: _selectedGender,
        medicalHistory: profile.medicalHistory,
        specialization: specialization,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _profile = updated;
        _editing = false;
        _saving = false;
      });
      _applyProfile(updated);
      await context.read<AppState>().refreshCurrentUserFromProfile(updated);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;

    return AppShell(
      title: 'My Profile',
      actions: [
        IconButton(
          onPressed: _loading ? null : _loadProfile,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : profile == null
          ? const Center(child: Text('Profile details are not available.'))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 42,
                          child: Text(
                            profile.name.isEmpty
                                ? 'U'
                                : profile.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profile.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          profile.email,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _ProfileField(
                          label: 'Name',
                          child: _editing
                              ? TextField(controller: _nameController)
                              : _ValueTile(value: profile.name),
                        ),
                        _ProfileField(
                          label: 'Email',
                          child: _ValueTile(value: profile.email),
                        ),
                        _ProfileField(
                          label: 'Phone',
                          child: _editing
                              ? TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                )
                              : _ValueTile(value: profile.phone),
                        ),
                        _ProfileField(
                          label: 'Age',
                          child: _editing
                              ? TextField(
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                )
                              : _ValueTile(
                                  value: profile.age?.toString() ?? '-',
                                ),
                        ),
                        _ProfileField(
                          label: 'Gender',
                          child: _editing
                              ? DropdownButtonFormField<String>(
                                  initialValue: _selectedGender.isEmpty
                                      ? null
                                      : _selectedGender,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Female',
                                      child: Text('Female'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Male',
                                      child: Text('Male'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Other',
                                      child: Text('Other'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value ?? '';
                                    });
                                  },
                                )
                              : _ValueTile(
                                  value: profile.gender.isEmpty
                                      ? '-'
                                      : profile.gender,
                                ),
                        ),
                        if (profile.isDoctor)
                          _ProfileField(
                            label: 'Specialization',
                            child: _editing
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DropdownButtonFormField<String>(
                                        initialValue:
                                            _selectedSpecialization.isEmpty
                                            ? null
                                            : _selectedSpecialization,
                                        items: _doctorSpecialties
                                            .map(
                                              (specialty) => DropdownMenuItem(
                                                value: specialty,
                                                child: Text(specialty),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedSpecialization =
                                                value ?? '';
                                            if (_selectedSpecialization !=
                                                'Other') {
                                              _otherSpecializationController
                                                  .clear();
                                            }
                                          });
                                        },
                                      ),
                                      if (_selectedSpecialization ==
                                          'Other') ...[
                                        const SizedBox(height: 12),
                                        TextField(
                                          controller:
                                              _otherSpecializationController,
                                          decoration: const InputDecoration(
                                            hintText:
                                                'Enter doctor specialization',
                                          ),
                                        ),
                                      ],
                                    ],
                                  )
                                : _ValueTile(
                                    value: profile.specialization.isEmpty
                                        ? '-'
                                        : profile.specialization,
                                  ),
                          ),
                        _ProfileField(
                          label: 'Role',
                          child: _ValueTile(value: profile.role.label),
                        ),
                        _ProfileField(
                          label: 'Member ID',
                          child: _ValueTile(value: profile.memberId),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_editing)
                  GradientButton(
                    label: _saving ? 'Saving...' : 'Save Profile',
                    icon: Icons.save_outlined,
                    expanded: true,
                    onPressed: _saving ? null : _saveProfile,
                  )
                else
                  GradientButton(
                    label: 'Edit Profile',
                    icon: Icons.edit_outlined,
                    expanded: true,
                    onPressed: () {
                      setState(() {
                        _editing = true;
                      });
                    },
                  ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    await context.read<AppState>().logout();
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Logout'),
                ),
              ],
            ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _ValueTile extends StatelessWidget {
  const _ValueTile({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FAFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(value.isEmpty ? '-' : value),
    );
  }
}
