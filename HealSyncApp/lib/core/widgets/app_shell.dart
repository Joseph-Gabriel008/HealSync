import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../theme/app_theme.dart';
import 'logo_lockup.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.title,
    required this.child,
    this.actions = const [],
    this.showLanguageSelector = true,
  });

  final String title;
  final Widget child;
  final List<Widget> actions;
  final bool showLanguageSelector;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 420;
    final appBarActions = <Widget>[
      if (showLanguageSelector) const _AppLanguageDropdown(),
      ...actions,
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            HealSyncLogo(size: isCompact ? 30 : 34, compact: true),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: isCompact ? 18 : null, height: 1.1),
              ),
            ),
          ],
        ),
        actions: appBarActions,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6FFFC), Color(0xFFEAF7FF), Color(0xFFF7FCFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -60,
              child: _GlowOrb(
                size: 250,
                colors: [
                  AppTheme.green.withValues(alpha: 0.22),
                  AppTheme.blue.withValues(alpha: 0.12),
                ],
              ),
            ),
            Positioned(
              top: 110,
              left: -70,
              child: _GlowOrb(
                size: 180,
                colors: [
                  AppTheme.blue.withValues(alpha: 0.12),
                  AppTheme.green.withValues(alpha: 0.08),
                ],
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 8,
                    margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    decoration: BoxDecoration(
                      gradient: AppTheme.heroGradient,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppLanguageDropdown extends StatelessWidget {
  const _AppLanguageDropdown();

  @override
  Widget build(BuildContext context) {
    final controller = HealSyncLocaleScope.of(context);
    final l10n = AppLocalizations.of(context)!;
    final items = <_LanguageItem>[
      _LanguageItem(const Locale('en'), l10n.english),
      _LanguageItem(const Locale('hi'), l10n.hindi),
      _LanguageItem(const Locale('ta'), l10n.tamil),
      _LanguageItem(const Locale('te'), l10n.telugu),
      _LanguageItem(const Locale('ml'), l10n.malayalam),
    ];

    return PopupMenuButton<Locale>(
      tooltip: l10n.language,
      icon: const Icon(Icons.translate_rounded),
      onSelected: controller.updateLocale,
      itemBuilder: (context) {
        return items
            .map(
              (item) => PopupMenuItem<Locale>(
                value: item.locale,
                child: Row(
                  children: [
                    if (controller.value == item.locale)
                      const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(Icons.check, size: 18),
                      )
                    else
                      const SizedBox(width: 26),
                    Flexible(child: Text(item.label)),
                  ],
                ),
              ),
            )
            .toList();
      },
    );
  }
}

class _LanguageItem {
  const _LanguageItem(this.locale, this.label);

  final Locale locale;
  final String label;
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.colors});

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
