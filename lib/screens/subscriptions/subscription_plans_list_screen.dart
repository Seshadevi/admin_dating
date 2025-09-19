import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/screens/subscriptions/subscription_plans_list_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/subscriptions/subscription_get_provider.dart';
import 'AddFeatureToPlanScreen.dart';

class SubscriptionPlansListScreen extends ConsumerStatefulWidget {
  const SubscriptionPlansListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SubscriptionPlansListScreen> createState() =>
      _SubscriptionPlansListScreenState();
}

class _SubscriptionPlansListScreenState
    extends ConsumerState<SubscriptionPlansListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionListProvider.notifier).fetchPlans();
    });
  }

  Future<void> _confirmDelete(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Plan'),
        content: const Text('Are you sure you want to delete this plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final result =
      await ref.read(subscriptionListProvider.notifier).deletePlan(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result == "success" ? "Plan deleted." : result)));
    }
  }

  void _editPlan(dynamic plan) {
    // Add edit logic or navigation here
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: DatingColors.darkGreen,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Subscription Plans',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              tooltip: 'Add Subscription Plan',
              onPressed: () {
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PostSubscriptionScreen()),
                    // Or push to your add plan screen if available
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(child: Text(state.error!))
          : RefreshIndicator(
        onRefresh: () async {
          await ref.read(subscriptionListProvider.notifier).fetchPlans();
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: state.plans.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final plan = state.plans[index];
            final planTypeId = plan['id'] ?? 0;
            return Card(
              color: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(
                  plan['planName'] ?? plan['title'] ?? 'No Name',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  plan['description'] ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                    theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon:
                      const Icon(Icons.add_box, color: Colors.indigo),
                      tooltip: "Add Features",
                      onPressed: () {
                        print('Navigating with planTypeId: $planTypeId');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddFeatureToPlanScreen(planTypeId: planTypeId),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _editPlan(plan),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(plan['id']),
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
