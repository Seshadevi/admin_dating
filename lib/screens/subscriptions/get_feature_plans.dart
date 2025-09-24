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
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 12),
        //     child: IconButton(
        //       icon: const Icon(Icons.add),
        //       color: Colors.white,
        //       tooltip: 'Add Feature Plans',
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) =>  AddFeatureToPlanScreen(planTypeId: state.data!.first.planTypeId ?? 0),
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ],
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
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
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
                                ...plan.features!.map((f) => Row(
                                      children: [
                                        const Icon(Icons.check,
                                            size: 16, color: Colors.green),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            f.featureName ?? '',
                                            style:
                                                theme.textTheme.bodyMedium,
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                             

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Add Button
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.green),
                                    tooltip: 'Add Feature to Plan',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddFeatureToPlanScreen(
                                              planTypeId: plan.planTypeId ?? 0),
                                        ),
                                      );
                                    },
                                  ),
                                  // Edit Button
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    tooltip: 'Edit Plan',
                                    onPressed: () {
                                      // Navigate to your edit screen (create if not exists)
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddFeatureToPlanScreen(
                                            planTypeId: plan.planTypeId ?? 0,
                                            
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // Delete Button
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    tooltip: 'Delete Feature Plan',
                                    onPressed: () async {
                                      // await ref
                                      //     .read(featurePlansProviders.notifier)
                                      //     .deleteFeaturePlan(plan.id ?? 0);
                                      await ref.read(featurePlansProviders.notifier).getFeaturesPlans();
                                    },
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
