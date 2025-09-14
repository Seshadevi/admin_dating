import 'package:admin_dating/provider/superAdminProviders/roles_provider.dart';
import 'package:flutter/material.dart';
import 'package:admin_dating/constants/dating_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RolesScreen extends ConsumerStatefulWidget {
  const RolesScreen({super.key});

  @override
  ConsumerState<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends ConsumerState<RolesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roleController = TextEditingController();

  @override
  void dispose() {
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _addRole() async {

    if (_formKey.currentState!.validate()) {
      final roleName = _roleController.text.trim();

       final success = await ref.read(rolesProvider.notifier).addRole(     
      roleName: _roleController.text.trim(),     
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Role '$roleName' added successfully")),
      
      );
      Navigator.pop(context) ;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create role")),
      );
    }
     
      _roleController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DatingColors.darkGreen,
        title: const Text(
          "Add Roles",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Role Input Field
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(
                  labelText: "Enter Role",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a role name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Add Role Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DatingColors.darkGreen,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _addRole,
                child: const Text(
                  "Add Role",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
