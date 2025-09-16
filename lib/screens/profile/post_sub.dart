import 'package:flutter/material.dart';
import 'package:admin_dating/constants/dating_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostSubscriptionScreen extends StatefulWidget {
  const PostSubscriptionScreen({super.key});

  @override
  State<PostSubscriptionScreen> createState() => _PostSubscriptionScreenState();
}

class _PostSubscriptionScreenState extends State<PostSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _planNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _planNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitPlan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final url = Uri.parse('http://97.74.93.26:6100/admin/plan/post');
    final body = json.encode({
      'planName': _planNameController.text.trim(),
      'description': _descriptionController.text.trim(),
    });
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subscription plan added successfully!')),
        );
        _planNameController.clear();
        _descriptionController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Failed to add subscription.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: DatingColors.primaryGreen, width: 2),
                  ),
                ),
                validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Please enter plan name' : null,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: DatingColors.primaryGreen, width: 2),
                  ),
                ),
                minLines: 2,
                maxLines: 5,
                validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Please enter description' : null,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submitPlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DatingColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(0, 48),
                  ),
                  child: _loading
                      ? const SizedBox(
                      width: 28, height: 28, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Add Plan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
