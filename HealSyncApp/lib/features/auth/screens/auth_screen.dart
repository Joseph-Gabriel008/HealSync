import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/app_models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/logo_lockup.dart';
import '../../../l10n/app_localizations.dart';
import '../../../main.dart';
import '../../../services/app_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _nameController = TextEditingController(text: 'Aarav Sharma');
  final _emailController = TextEditingController(text: 'aarav@healsync.app');
  final _passwordController = TextEditingController(text: 'demo123');
  UserRole _selectedRole = UserRole.patient;
  bool _isSignup = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7FFFB), Color(0xFFECF8FF), Color(0xFFFDFEFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -60,
              child: _Aura(
                size: 300,
                colors: [
                  AppTheme.green.withValues(alpha: 0.18),
                  AppTheme.blue.withValues(alpha: 0.10),
                ],
              ),
            ),
            Positioned(
              bottom: -90,
              left: -40,
              child: _Aura(
                size: 240,
                colors: [
                  AppTheme.blue.withValues(alpha: 0.14),
                  AppTheme.green.withValues(alpha: 0.08),
                ],
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 980),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 760;
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: isWide
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: _AuthHero(l10n: l10n),
                                      ),
                                      const SizedBox(width: 28),
                                      Expanded(
                                        child: _AuthForm(
                                          nameController: _nameController,
                                          emailController: _emailController,
                                          passwordController:
                                              _passwordController,
                                          isSignup: _isSignup,
                                          selectedRole: _selectedRole,
                                          state: state,
                                          onToggleMode: () => setState(
                                            () => _isSignup = !_isSignup,
                                          ),
                                          onRoleChanged: (role) => setState(
                                            () => _selectedRole = role,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : _AuthForm(
                                    nameController: _nameController,
                                    emailController: _emailController,
                                    passwordController: _passwordController,
                                    isSignup: _isSignup,
                                    selectedRole: _selectedRole,
                                    state: state,
                                    showHero: true,
                                    onToggleMode: () =>
                                        setState(() => _isSignup = !_isSignup),
                                    onRoleChanged: (role) =>
                                        setState(() => _selectedRole = role),
                                  ),
                          ),
                        );
                      },
                    ),
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

class _AuthHero extends StatelessWidget {
  const _AuthHero({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGlow,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HealSyncLogo(size: 140),
          const SizedBox(height: 26),
          Text(
            l10n.careHeroHeadline,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 18),
          Text(l10n.careHeroBody),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _FeatureChip(label: l10n.realtimeRecords),
              _FeatureChip(label: l10n.verifiedReports),
              _FeatureChip(label: l10n.secureConsultations),
            ],
          ),
        ],
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.isSignup,
    required this.selectedRole,
    required this.state,
    required this.onToggleMode,
    required this.onRoleChanged,
    this.showHero = false,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isSignup;
  final UserRole selectedRole;
  final AppState state;
  final VoidCallback onToggleMode;
  final ValueChanged<UserRole> onRoleChanged;
  final bool showHero;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeController = HealSyncLocaleScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHero) ...[
          const Center(child: HealSyncLogo(size: 104)),
          const SizedBox(height: 24),
        ],
        Align(
          alignment: Alignment.centerRight,
          child: _LanguageDropdown(
            currentLocale: localeController.value,
            onChanged: localeController.updateLocale,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          isSignup ? l10n.createCareWorkspace : l10n.welcomeBack,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          isSignup
              ? l10n.signupSubtitle
              : l10n.loginSubtitle,
        ),
        const SizedBox(height: 24),
        if (state.authError != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEEB),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(state.authError!),
          ),
          const SizedBox(height: 16),
        ],
        if (isSignup) ...[
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: l10n.fullName),
          ),
          const SizedBox(height: 16),
        ],
        TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: l10n.email),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: l10n.password),
        ),
        const SizedBox(height: 16),
        SegmentedButton<UserRole>(
          showSelectedIcon: false,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.softBlue;
              }
              return Colors.white;
            }),
          ),
          segments: UserRole.values
              .map(
                (role) => ButtonSegment<UserRole>(
                  value: role,
                  label: Text(
                    role == UserRole.patient ? l10n.patient : l10n.doctor,
                  ),
                  icon: Icon(
                    role == UserRole.patient
                        ? Icons.favorite_outline
                        : Icons.medical_services_outlined,
                  ),
                ),
              )
              .toList(),
          selected: {selectedRole},
          onSelectionChanged: (selection) => onRoleChanged(selection.first),
        ),
        const SizedBox(height: 24),
        GradientButton(
          label: isSignup ? l10n.createAccount : l10n.loginAction,
          icon: Icons.arrow_forward,
          expanded: true,
          onPressed: state.isBusy
              ? null
              : () => state.login(
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  password: passwordController.text,
                  role: selectedRole,
                  isSignup: isSignup,
                ),
        ),
        const SizedBox(height: 14),
        Center(
          child: TextButton(
            onPressed: () {
              state.clearAuthError();
              state.clearAuthSuccess();
              onToggleMode();
            },
            child: Text(
              isSignup
                  ? l10n.alreadyHaveAccount
                  : l10n.needAccount,
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.ink,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  const _LanguageDropdown({
    required this.currentLocale,
    required this.onChanged,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = <_LanguageItem>[
      _LanguageItem(const Locale('en'), l10n.english),
      _LanguageItem(const Locale('hi'), l10n.hindi),
      _LanguageItem(const Locale('ta'), l10n.tamil),
      _LanguageItem(const Locale('te'), l10n.telugu),
      _LanguageItem(const Locale('ml'), l10n.malayalam),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.softBlue),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
            value: currentLocale,
            borderRadius: BorderRadius.circular(20),
            icon: const Icon(Icons.translate_rounded),
            items: items
                .map(
                  (item) => DropdownMenuItem<Locale>(
                    value: item.locale,
                    child: Text('${l10n.language}: ${item.label}'),
                  ),
                )
                .toList(),
            onChanged: (locale) {
              if (locale != null) {
                onChanged(locale);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _LanguageItem {
  const _LanguageItem(this.locale, this.label);

  final Locale locale;
  final String label;
}

class _Aura extends StatelessWidget {
  const _Aura({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}
