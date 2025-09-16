import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/subscriptions/feature_plan_add_provider.dart';

class AddFeatureToPlanScreen extends ConsumerStatefulWidget {
  final int planTypeId;
  const AddFeatureToPlanScreen({Key? key, required this.planTypeId}) : super(key: key);

  @override
  ConsumerState<AddFeatureToPlanScreen> createState() => _AddFeatureToPlanScreenState();
}

class _AddFeatureToPlanScreenState extends ConsumerState<AddFeatureToPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _featureIdController = TextEditingController();

  @override
  void dispose() {
    _featureIdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(featurePlanAddProvider.notifier);
    await notifier.addFeatureToPlan(
      featureId: int.parse(_featureIdController.text),
      planTypeId: widget.planTypeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(featurePlanAddProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Feature To PlanType"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("PlanType ID: ${widget.planTypeId}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _featureIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Feature ID",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Enter a feature ID" : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: state.loading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                      : const Icon(Icons.link),
                  label: Text(state.loading ? "Linking..." : "Add Feature"),
                  onPressed: state.loading ? null : _submit,
                ),
              ),
              if (state.message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text(
                    state.message!,
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text(
                    state.error!,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
