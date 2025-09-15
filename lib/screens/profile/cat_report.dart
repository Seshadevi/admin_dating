import 'package:flutter/material.dart';
import 'package:admin_dating/constants/dating_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddReportCategoryScreen extends StatefulWidget {
  const AddReportCategoryScreen({super.key});

  @override
  State<AddReportCategoryScreen> createState() => _AddReportCategoryScreenState();
}

class _AddReportCategoryScreenState extends State<AddReportCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final categoryName = _categoryController.text.trim();

      final url = Uri.parse('http://97.74.93.26:6100/categorys');
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({'category': [categoryName]});

      try {
        final response = await http.post(url, headers: headers, body: body);
        final responseJson = json.decode(response.body);

        if (response.statusCode == 201 && responseJson['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Category "$categoryName" added successfully!')),
          );
          _categoryController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${responseJson['messages']?[0] ?? "Unknown error"}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Report Category'),
        backgroundColor: DatingColors.primaryGreen,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category Name',
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  hintText: 'Enter category name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: DatingColors.primaryGreen, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DatingColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(150, 48),
                  ),
                  child: const Text('Add Category'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
