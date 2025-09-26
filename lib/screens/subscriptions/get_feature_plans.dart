import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/models/supscription/feature_plans_model.dart';
import 'package:admin_dating/provider/subscriptions/feature_plans_providers.dart';
import 'package:admin_dating/screens/subscriptions/subscription_plans_list_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'AddFeatureToPlanScreen.dart';

class GetFeaturePlans extends ConsumerStatefulWidget {
  const GetFeaturePlans({Key? key}) : super(key: key);

  @override
  ConsumerState<GetFeaturePlans> createState() => _GetFeaturePlansState();
}

class _GetFeaturePlansState extends ConsumerState<GetFeaturePlans> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(featurePlansProviders.notifier).getFeaturesPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(featurePlansProviders);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: DatingColors.darkGreen,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          'Feature Plans',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
       
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(featurePlansProviders.notifier).getFeaturesPlans();
        },
        child: state.data == null || state.data!.isEmpty
            ? const Center(child: Text("No Plans Found"))
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: state.data!.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final Data plan = state.data![index];
                  return Card(
                    color: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Plan Name
                          Text(
                            plan.planName ?? 'No Name',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // 🔹 Plan Description
                          Text(
                            plan.description ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 🔹 Features List
                          if (plan.features != null &&
                              plan.features!.isNotEmpty) ...[
                            Text(
                              "Features:",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ...plan.features!.map(
                              (f) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check,
                                        size: 18, color: Colors.green),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        f.featureName ?? '',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontSize: 14,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          size: 20, color: Colors.red),
                                      tooltip: 'Delete Feature',
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text("Delete Feature"),
                                            content: Text(
                                                "Are you sure you want to delete '${f.featureName}'?"),
                                            actions: [
                                              TextButton(
                                                child: const Text("Cancel"),
                                                onPressed: () =>
                                                    Navigator.pop(ctx, false),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                child: const Text("Delete"),
                                                onPressed: () =>
                                                    Navigator.pop(ctx, true),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          final success = await ref
                                              .read(featurePlansProviders
                                                  .notifier)
                                              .deleteFeaturePlans(
                                                featureId: f.id ?? 0,
                                                planTypeId:
                                                    plan.planTypeId ?? 0,
                                              );
                                          //await ref.read(featurePlansProviders.notifier).getFeaturesPlans();
                                          if (success) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Deleted Feature: ${f.featureName ?? ''}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor:
                                                    DatingColors.darkGreen,
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Failed to delete Feature"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Add Button
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                    color: DatingColors.darkGreen,
                                    borderRadius: BorderRadius.circular(12)),
                                child: TextButton(
                                  child: Text(
                                    'Add Feature',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // icon: const Icon(Icons.add, color: Colors.green),
                                  // tooltip: 'Add Feature to Plan',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddFeatureToPlanScreen(
                                                planTypeId:
                                                    plan.planTypeId ?? 0,
                                                planName: plan.planName ?? ''),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
