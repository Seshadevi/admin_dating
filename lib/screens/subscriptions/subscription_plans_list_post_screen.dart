import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/subscriptions/subscription_provider.dart';
import 'package:admin_dating/constants/dating_colors.dart';

class PostSubscriptionScreen extends ConsumerStatefulWidget {
  const PostSubscriptionScreen({super.key});

  @override
  ConsumerState<PostSubscriptionScreen> createState() =>
      _PostSubscriptionScreenState();
}

class _PostSubscriptionScreenState extends ConsumerState<PostSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _planNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _planNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitPlan() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(subscriptionProvider.notifier);
    String result = await notifier.postSubscriptionPlan(
      _planNameController.text.trim(),
      _descriptionController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result == "success"
            ? 'Subscription plan added successfully!'
            : result),
      ),
    );

    if (result == "success") {
      _planNameController.clear();
      _descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionProvider);
    final loading = state.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subscription Plan'),
        backgroundColor: DatingColors.primaryGreen,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _planNameController,
                  decoration: InputDecoration(
                    labelText: 'Plan Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      BorderSide(color: DatingColors.primaryGreen, width: 2),
                    ),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Please enter plan name'
                      : null,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      BorderSide(color: DatingColors.primaryGreen, width: 2),
                    ),
                  ),
                  minLines: 2,
                  maxLines: 5,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Please enter description'
                      : null,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : _submitPlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DatingColors.primaryGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(0, 48),
                    ),
                    child: loading
                        ? const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                        : const Text('Add Plan'),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
