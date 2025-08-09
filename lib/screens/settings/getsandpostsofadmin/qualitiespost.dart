import 'package:admin_dating/provider/signupprocessProviders%20copy/qualities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_dating/constants/dating_colors.dart';

class Qualitiespostscreen extends ConsumerStatefulWidget {
  const Qualitiespostscreen({super.key});

  @override
  ConsumerState<Qualitiespostscreen> createState() => _QualitiespostscreenState();
}

class _QualitiespostscreenState extends ConsumerState<Qualitiespostscreen> {
  final TextEditingController _textController = TextEditingController();
  int? _editingId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _editingId = args['id'] as int?;
      _textController.text = args['name'] ?? '';
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final text = _textController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a value.")),
      );
      return;
    }

    if (_editingId == null) {
      await ref.read(qualitiesProvider.notifier).addqualities(qulities: text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added successfully")),
      );
    } else {
      // TODO: Add update API
      await ref.read(qualitiesProvider.notifier).updateQualities(_editingId!, text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Updated successfully")),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [DatingColors.darkGreen, DatingColors.brown],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_editingId == null ? "Add Qualities" : "Edit Qualities"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: DatingColors.darkGreen,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    labelText: 'Enter quality',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: DatingColors.primaryText,
                      fontSize: 16,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    color: DatingColors.primaryText,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [DatingColors.darkGreen, DatingColors.brown],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handleSubmit,
                  child: Text(
                    _editingId == null ? "Add Qualities" : "Update Qualities",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
