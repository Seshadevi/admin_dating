import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/subscriptions/subscriptions_full_plan_provider.dart';
import 'package:admin_dating/constants/dating_colors.dart';

class FullPlanPostScreen extends ConsumerStatefulWidget {
  const FullPlanPostScreen({super.key});

  @override
  ConsumerState<FullPlanPostScreen> createState() => _FullPlanPostScreenState();
}

class _FullPlanPostScreenState extends ConsumerState<FullPlanPostScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _typeId;
  String? _title;
  int? _price;
  int? _durationDays;
  int? _quantity;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fullPlanProvider);
    final notifier = ref.read(fullPlanProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Full Plan'),
        backgroundColor: DatingColors.primaryGreen,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Type ID'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _typeId = int.tryParse(v ?? ''),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (v) => _title = v,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _price = int.tryParse(v ?? ''),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Duration Days'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _durationDays = int.tryParse(v ?? ''),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _quantity = int.tryParse(v ?? ''),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.loading
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final msg = await notifier.postFullPlan(
                        typeId: _typeId!,
                        title: _title!,
                        price: _price!,
                        durationDays: _durationDays!,
                        quantity: _quantity!,
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(msg)));
                      if (state.success && context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DatingColors.primaryGreen,
                  ),
                  child: state.loading
                      ? const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2)
                      : const Text('Create Plan'),
                ),
              ),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(state.error!,
                      style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
