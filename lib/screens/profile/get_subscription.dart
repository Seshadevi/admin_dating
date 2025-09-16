import 'package:admin_dating/screens/profile/post_sub.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:admin_dating/constants/dating_colors.dart';
// import 'post_subscription_screen.dart'; // (For navigation to edit, if needed)

class SubscriptionPlansListScreen extends StatefulWidget {
  const SubscriptionPlansListScreen({super.key});

  @override
  State<SubscriptionPlansListScreen> createState() => _SubscriptionPlansListScreenState();
}

class _SubscriptionPlansListScreenState extends State<SubscriptionPlansListScreen> {
  List<dynamic> _plans = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    setState(() => _loading = true);
    try {
      final url = Uri.parse('http://97.74.93.26:6100/admin/plan/get');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _plans = data['data'] ?? [];
        });
      } else {
        _showError('Failed to load plans. Server error.');
      }
    } catch (e) {
      _showError('Failed to load plans. $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _deletePlan(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Plan'),
        content: const Text('Are you sure you want to delete this plan?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final url = Uri.parse('http://97.74.93.26:6100/admin/plan/$id');
        final response = await http.delete(url);
        if (response.statusCode == 200 || response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plan deleted.')));
          _fetchPlans();
        } else {
          _showError('Failed to delete plan.');
        }
      } catch (e) {
        _showError('Error deleting plan: $e');
      }
    }
  }

  void _editPlan(dynamic plan) {
    // TODO: Implement edit. You can navigate to PostSubscriptionScreen for edit and pass the plan.
    // Navigator.push(context, MaterialPageRoute(builder: (c) => PostSubscriptionScreen(plan: plan)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Subscriptions',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.add),
              color: DatingColors.primaryGreen,
              tooltip: 'Add Subscription Plan',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PostSubscriptionScreen()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.more_vert, color: colorScheme.onSurface),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchPlans,
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: _plans.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final plan = _plans[index];
            return Card(
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(
                  plan['planName'] ?? 'No Name',
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                subtitle: Text(
                  plan['description'] ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _editPlan(plan),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deletePlan(plan['id']),
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
