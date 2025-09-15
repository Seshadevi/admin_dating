import 'package:flutter/material.dart';
import 'package:admin_dating/constants/dating_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cat_report.dart';

class ReportCategoriesScreen extends StatefulWidget {
  const ReportCategoriesScreen({super.key});
  @override
  State<ReportCategoriesScreen> createState() => _ReportCategoriesScreenState();
}

class _ReportCategoriesScreenState extends State<ReportCategoriesScreen> {
  List<dynamic> _categories = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() => _loading = true);
    try {
      final url = Uri.parse('http://97.74.93.26:6100/categorys');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _categories = data['data'] ?? [];
        });
      } else {
        _showError('Failed to load categories. Server error.');
      }
    } catch (e) {
      _showError('Failed to load categories. $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _deleteCategory(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final url = Uri.parse('http://97.74.93.26:6100/categorys/$id');
        final response = await http.delete(url);
        if (response.statusCode == 200 || response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category deleted.')));
          _fetchCategories();
        } else {
          _showError('Failed to delete category.');
        }
      } catch (e) {
        _showError('Error deleting category: $e');
      }
    }
  }

  void _editCategory(dynamic category) {
    // Navigate to your AddReportCategoryScreen with data for editing
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReportCategoryScreen(
          // refresh after save
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
    title: const Text(
    'Report Categories',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    backgroundColor: DatingColors.primaryGreen,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white),
    actions: [
    IconButton(
    icon: const Icon(Icons.add_circle_outline),
    color: Colors.white,
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddReportCategoryScreen()),
    );
    },
    tooltip: 'Add Report Category',
    ),
    ],
    ),

    body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchCategories,
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final category = _categories[index];
            return Card(
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(
                  category['category'] ?? 'Unknown',
                  style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _editCategory(category),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCategory(category['id']),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
