import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/superAdminProviders/admin_feature_provider.dart';
import 'package:admin_dating/provider/superAdminProviders/roles_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddAdminFeatures extends ConsumerStatefulWidget {
  const AddAdminFeatures({super.key});

  @override
  ConsumerState<AddAdminFeatures> createState() => _AddAdminFeaturesState();
}

class _AddAdminFeaturesState extends ConsumerState<AddAdminFeatures> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _featureController = TextEditingController();

  int? _roleId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _roleId = args['id'];
      _featureController.text = args['featureName'] ?? '';
    }
  }

  @override
  void dispose() {
    _featureController.dispose();
    super.dispose();
  }

  Future<void> _saveRole() async {
    if (_formKey.currentState!.validate()) {
      final featureName = _featureController.text.trim();

      bool success;
      if (_roleId != null) {
        success = await ref.read(rolesProvider.notifier).updateRole(
              id: _roleId!,
              roleName: featureName,
            );
      } else {
        success =
            await ref.read(adminFeatureProvider.notifier).addAdminFeatures(
                  featureName: featureName,
                );
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(_roleId != null
                  ? "Features updated successfully"
                  : "Features added successfully")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Operation failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _roleId != null;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: DatingColors.darkGreen,
        title: Text(
          isEditing ? "Edit Feature" : "Add Feature",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon(Icons.settings,
                    //     size: 60, color: DatingColors.darkGreen),
                    // const SizedBox(height: 16),
                    Text(
                      isEditing
                          ? "Update this feature"
                          : "Create a new feature",
                      style: const TextStyle( color: Colors.black,
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                   Align(
                    alignment: Alignment.topLeft,
                    child: Text('Feature Name',style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w500),)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _featureController,
                      decoration: InputDecoration(
                       // labelText: "Feature Name",labelStyle: TextStyle(color: Colors.black),
                        hintText: "Enter feature name",
                        prefixIcon:
                            Icon(Icons.star_border, color: Colors.grey[700]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a feature name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DatingColors.darkGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _saveRole,
                        child: Text(
                          isEditing ? "Update Feature" : "Add Feature",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
