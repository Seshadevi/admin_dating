import 'package:admin_dating/provider/subscriptions/feature_plans_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/subscriptions/feature_plan_add_provider.dart';
import '../../provider/superAdminProviders/admin_feature_provider.dart';

class AddFeatureToPlanScreen extends ConsumerStatefulWidget {
  final int planTypeId;
  final String planName;
  const AddFeatureToPlanScreen({Key? key, required this.planTypeId,required this.planName})
      : super(key: key);

  @override
  ConsumerState<AddFeatureToPlanScreen> createState() =>
      _AddFeatureToPlanScreenState();
}

class _AddFeatureToPlanScreenState extends ConsumerState<AddFeatureToPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedFeatureId;

  @override
  void initState() {
    super.initState();
    Future.microtask(
            () => ref.read(adminFeatureProvider.notifier).getAdminFeatures());
  }

Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;

  final notifier = ref.read(featurePlansProviders.notifier);


  try {
    final success = await notifier.addFeatureToPlan(
      featureId: _selectedFeatureId!,
      planTypeId: widget.planTypeId,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Feature linked to plan successfully!"
              : "Failed to link feature. Please try again.",
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
   Navigator.pop(context);
  } catch (e) {
    Navigator.pop(context); 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error occurred: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final addFeatureState = ref.watch(featurePlansProviders);
    final adminFeatureState = ref.watch(adminFeatureProvider);

    final features = adminFeatureState.data ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Feature To PlanType"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text("Plan Name: ${widget.planName}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              if (features.isEmpty)
                const Center(child: Text("No features available."))
              else
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Select Feature',
                    border: OutlineInputBorder(),
                  ),
                  items: features
                      .map(
                        (feature) => DropdownMenuItem<int>(
                      value: feature.id,
                      child: Text(feature.featureName),
                    ),
                  )
                      .toList(),
                  value: _selectedFeatureId,
                  onChanged: (val) => setState(() => _selectedFeatureId = val),
                  validator: (val) =>
                  val == null ? 'Please select a feature' : null,
                ),
              const SizedBox(height: 24),
                ElevatedButton.icon(
              icon: const Icon(Icons.link),
              label: const Text("Add Feature"),
              onPressed: _selectedFeatureId == null ? null : _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
              // if (addFeatureState.message != null)
              //   Padding(
              //     padding: const EdgeInsets.only(top: 18.0),
              //     child: Text(
              //       addFeatureState.message!,
              //       style: const TextStyle(
              //           color: Colors.green, fontWeight: FontWeight.bold),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // if (addFeatureState.error != null)
              //   Padding(
              //     padding: const EdgeInsets.only(top: 18.0),
              //     child: Text(
              //       addFeatureState.error!,
              //       style: const TextStyle(
              //           color: Colors.red, fontWeight: FontWeight.bold),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
