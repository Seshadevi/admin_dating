import 'package:admin_dating/provider/subscriptions/subscription_get_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/subscriptions/subscription_provider.dart';
import 'package:admin_dating/constants/dating_colors.dart';
class PostSubscriptionScreen extends ConsumerStatefulWidget {
  final dynamic plan; // ✅ optional plan for editing

  const PostSubscriptionScreen({super.key, this.plan});

  @override
  ConsumerState<PostSubscriptionScreen> createState() =>
      _PostSubscriptionScreenState();
}

class _PostSubscriptionScreenState extends ConsumerState<PostSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _planNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.plan != null) {
      _planNameController.text = widget.plan['planName'] ?? '';
      _descriptionController.text = widget.plan['description'] ?? '';
    }
  }

  @override
  void dispose() {
    _planNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitPlan() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(subscriptionProvider.notifier);
    final updatenotifier = ref.read(subscriptionListProvider.notifier);
    String result;

    if (widget.plan == null) {
      // ✅ Create new plan
      result = await notifier.postSubscriptionPlan(
        _planNameController.text.trim(),
        _descriptionController.text.trim(),
      );
    } else {
      // ✅ Update existing plan
      result = await updatenotifier.updatePlan(
        planId: widget.plan['id'],
        planName: _planNameController.text.trim(),
        description: _descriptionController.text.trim(),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result == "success"
            ? (widget.plan == null
                ? 'Subscription plan added successfully!'
                : 'Subscription plan updated successfully!')
            : result),
      ),
    );

    if (result == "success") {
        await ref.read(subscriptionListProvider.notifier).fetchPlans();
         Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
 final addState = ref.watch(subscriptionProvider);
final updateState = ref.watch(subscriptionListProvider);

final loading = widget.plan == null 
    ? addState.loading 
    : updateState.loading;


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan == null
            ? 'Add Subscription Plan'
            : 'Edit Subscription Plan'),
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
                    borderSide: BorderSide(
                        color: DatingColors.primaryGreen, width: 2),
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
                    borderSide: BorderSide(
                        color: DatingColors.primaryGreen, width: 2),
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
                      : Text(widget.plan == null ? 'Add Plan' : 'Update Plan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
