import 'package:flutter/material.dart';

import '../../../core/widgets/app_shell.dart';

class OfflineEmergencyTipsScreen extends StatelessWidget {
  const OfflineEmergencyTipsScreen({super.key});

  static const List<_EmergencyTip> _tips = [
    _EmergencyTip(
      'Chest pain',
      'Stop activity, sit upright, loosen tight clothing, and seek urgent medical help immediately.',
    ),
    _EmergencyTip(
      'Breathing trouble',
      'Help the person sit up, move them to fresh air, and call emergency support if breathing is severe.',
    ),
    _EmergencyTip(
      'High fever',
      'Encourage fluids, keep clothing light, and sponge with lukewarm water. Seek care if fever stays high.',
    ),
    _EmergencyTip(
      'Low sugar signs',
      'If conscious, give a sweet drink or glucose source right away and recheck after a few minutes.',
    ),
    _EmergencyTip(
      'Bleeding cut',
      'Apply firm direct pressure with a clean cloth and keep the injured part raised if possible.',
    ),
    _EmergencyTip(
      'Burn injury',
      'Cool the area under running water for 20 minutes. Do not apply ice or toothpaste.',
    ),
    _EmergencyTip(
      'Fainting',
      'Lay the person flat, raise their legs slightly, and make sure air can circulate.',
    ),
    _EmergencyTip(
      'Seizure',
      'Clear nearby objects, turn them on one side after jerking stops, and do not put anything in the mouth.',
    ),
    _EmergencyTip(
      'Nosebleed',
      'Lean forward, pinch the soft part of the nose for 10 minutes, and avoid lying down.',
    ),
    _EmergencyTip(
      'Sprain or swelling',
      'Use rest, ice, compression, and elevation during the first day.',
    ),
    _EmergencyTip(
      'Dehydration',
      'Give small repeated sips of water or oral rehydration solution and avoid heavy meals.',
    ),
    _EmergencyTip(
      'Head injury',
      'Watch for vomiting, confusion, drowsiness, or worsening headache and seek urgent care if present.',
    ),
    _EmergencyTip(
      'Asthma attack',
      'Use the prescribed inhaler if available and seek urgent care if speaking becomes difficult.',
    ),
    _EmergencyTip(
      'Pressure spike symptoms',
      'Sit quietly, avoid exertion, take regular medicines if prescribed, and seek urgent help for chest pain or weakness.',
    ),
    _EmergencyTip(
      'Allergic reaction',
      'Stop the trigger, use prescribed allergy medicine, and seek emergency care for swelling or breathing issues.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Offline Emergency Tips',
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _tips.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final tip = _tips[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${tip.title}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(tip.description),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmergencyTip {
  const _EmergencyTip(this.title, this.description);

  final String title;
  final String description;
}
