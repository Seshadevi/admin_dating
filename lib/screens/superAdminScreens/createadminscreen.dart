import 'dart:io';
import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/superAdminProviders/admin_get_provider.dart';
import 'package:admin_dating/provider/superAdminProviders/admin_pages_providers.dart';
import 'package:admin_dating/provider/superAdminProviders/roles_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/superAdminModels/roles_get_model.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  // Use only this for the picked image
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Data? _selectedRole;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Map<String, dynamic>? args;
  String? _profilePicUrl;
  int? _editingId; // for update
  Set<int> _selectedPageIds = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final receivedArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (receivedArgs != null && args == null) {
      args = receivedArgs;

      // Save for update use
      _editingId = args!['id'];

      // Prefill text fields
      _nameController.text = args!['username'] ?? '';
      _emailController.text = args!['email'] ?? '';
      _passwordController.text = args!['password'] ?? '';
      _profilePicUrl = args!['profilePic'];

      // Preselect role if given
      if (args!['roleId'] != null) {
        Future.microtask(() {
          final roles = ref.read(rolesProvider).data;
          if (roles != null && roles.isNotEmpty) {
            final role = roles.firstWhere(
              (r) => r.id == args!['roleId'],
              orElse: () => roles.first,
            );
            setState(() => _selectedRole = role);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(rolesProvider.notifier).getroles());
    Future.microtask(
        () => ref.read(adminPagesProviders.notifier).getadminpages());
  }

  // Pick image from gallery/camera
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() => _imageFile = File(pickedFile.path));
                  }
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() => _imageFile = File(pickedFile.path));
                  }
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(adminGetsProvider.notifier);

      final success = _editingId == null
          ? await notifier.createAdmin(
              image: _imageFile!,
              firstName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              roleId: _selectedRole?.id.toString() ?? '',
              pages: _selectedPageIds.toList(),
            )
          : await notifier.updateAdmin(
              id: _editingId!,
              image: _imageFile,
              firstName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              roleId: _selectedRole?.id.toString() ?? '',
            );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(_editingId == null
                  ? "Admin Created Successfully"
                  : "Admin Updated Successfully")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save admin")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminPagesState = ref.watch(adminPagesProviders);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DatingColors.darkGreen,
        title: const Text(
          "Create Admin Account",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: DatingColors.darkGreen,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (_profilePicUrl != null
                          ? NetworkImage(
                              _profilePicUrl!.startsWith("http")
                                  ? _profilePicUrl!
                                  : "http://97.74.93.26:6100/$_profilePicUrl",
                            )
                          : null) as ImageProvider?,
                  child: (_imageFile == null && _profilePicUrl == null)
                      ? const Icon(Icons.add_a_photo,
                          size: 32, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Full Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Consumer(
                builder: (context, ref, _) {
                  final rolesState = ref.watch(rolesProvider);
                  final List<Data> roles = rolesState?.data ?? [];

                  // If roles is empty, no dropdown, no value
                  if (roles.isEmpty) {
                    if (_selectedRole != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _selectedRole = null;
                        });
                      });
                    }
                    return const Text("No roles found");
                  }

                  // If current selectedRole does not reference an actual role object from the list, try to select the matching one by ID
                  if (_selectedRole != null && !roles.contains(_selectedRole)) {
                    final selected = roles.firstWhere(
                        (role) => role.id == _selectedRole!.id,
                        orElse: () => roles.first);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        // Use the in-list object as value, not a new instance
                        _selectedRole = selected;
                      });
                    });
                  }

                  return DropdownButtonFormField<Data>(
                    value:
                        _selectedRole != null && roles.contains(_selectedRole)
                            ? _selectedRole
                            : null,
                    decoration: const InputDecoration(
                      labelText: "Select Role",
                      border: OutlineInputBorder(),
                    ),
                    items: roles
                        .map((role) => DropdownMenuItem<Data>(
                              value: role,
                              child: Text(role.roleName.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                    validator: (value) {
                      if (roles.isNotEmpty && value == null) {
                        return "Please select a role";
                      }
                      return null;
                    },
                  );
                },
              ),

             const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Assign Admin Pages",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),

             
              // ✅ Admin Pages with Checkboxes (Scrollable)
if (adminPagesState.data != null && adminPagesState.data!.isNotEmpty)
  SizedBox(
    height: 200, // set fixed height for scrollable area
    child: Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Column(
          children: adminPagesState.data!.map((page) {
            return CheckboxListTile(
              title: Text(page.pages ?? "Unnamed Page"),
              value: _selectedPageIds.contains(page.id),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedPageIds.add(page.id!);
                  } else {
                    _selectedPageIds.remove(page.id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
    ),
  )
else
  const Text("No admin pages found"),


              const SizedBox(height: 24),

              Consumer(
                builder: (context, ref, _) {
                  final isLoading = ref.watch(loadingProvider);
                  return isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DatingColors.darkGreen,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // 🔹 Access selected pages here
                            print("Selected Page IDs: $_selectedPageIds");
                            _submit();
                          },
                          child: Text(
                            _editingId == null
                                ? "Create Account"
                                : "Update Account",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
