import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/superAdminProviders/roles_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RolesScreen extends ConsumerStatefulWidget {
  const RolesScreen({super.key});

  @override
  ConsumerState<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends ConsumerState<RolesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roleController = TextEditingController();

  int? _roleId; // for edit case

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _roleId = args['id'];
      _roleController.text = args['roleName'] ?? '';
    }
  }

  @override
  void dispose() {
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _saveRole() async {
    if (_formKey.currentState!.validate()) {
      final roleName = _roleController.text.trim();

      bool success;
      if (_roleId != null) {
        // EDIT
        success = await ref.read(rolesProvider.notifier).updateRole(
          id: _roleId!,
          roleName: roleName,
        );
      } else {
        // ADD
        success = await ref.read(rolesProvider.notifier).addRole(
          roleName: roleName,
        );
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_roleId != null
              ? "Role updated successfully"
              : "Role added successfully")),
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
        backgroundColor: DatingColors.darkGreen,
        title: Text(
          isEditing ? "Edit Role" : "Add Role",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DatingColors.darkGreen,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveRole,
                child: Text(
                  isEditing ? "Update Role" : "Add Role",
                  style: const TextStyle(
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
