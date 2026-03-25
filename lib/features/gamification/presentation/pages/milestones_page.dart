import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_colors.dart';
import '../providers/gamification_providers.dart';
import '../widgets/milestone_card.dart';

class MilestonesPage extends ConsumerStatefulWidget {
  const MilestonesPage({super.key});

  @override
  ConsumerState<MilestonesPage> createState() => _MilestonesPageState();
}

class _MilestonesPageState extends ConsumerState<MilestonesPage> {
  bool _showCompleted = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeMilestonesProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final milestonesState = ref.watch(activeMilestonesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Objectifs'),
        centerTitle: true,
      ),
      body: milestonesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => const Center(child: Text('Désolé, une erreur est survenue.')),
        data: (activeMilestones) {
          // In a real app with a proper DB query, we would get both.
          // For the M7 implementation plan, we will just use the active list
          // and filter out any that might be marked completed if that happens.
          final ongoing = activeMilestones.where((m) => !m.isCompleted).toList();
          final completed = activeMilestones.where((m) => m.isCompleted).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'En cours (${ongoing.length})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...ongoing.map((m) => MilestoneCard(milestone: m)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Complétés',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => setState(() => _showCompleted = !_showCompleted),
                    child: Text(_showCompleted ? 'Masquer' : 'Afficher'),
                  ),
                ],
              ),
              if (_showCompleted) ...[
                const SizedBox(height: 16),
                if (completed.isEmpty)
                  const Center(
                    child: Text(
                      "Aucun objectif complété pour le moment. À vous de jouer !",
                      style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                    ),
                  )
                else
                  ...completed.map((m) => MilestoneCard(milestone: m)),
              ],
            ],
          );
        },
      ),
    );
  }
}
