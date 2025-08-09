import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/signupprocessProviders%20copy/drinkingProvider.dart';
import 'package:admin_dating/provider/signupprocessProviders%20copy/lookingProvider.dart';
import 'package:admin_dating/provider/signupprocessProviders%20copy/religionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Religionpostscreen extends ConsumerStatefulWidget {
  const Religionpostscreen({super.key});

  @override
  ConsumerState<Religionpostscreen> createState() =>
      _ReligionpostscreenState();
}

class _ReligionpostscreenState
    extends ConsumerState<Religionpostscreen> {
  final TextEditingController _textController = TextEditingController();
  int? _editingId; // null means adding mode

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _editingId = args['id'] as int?;
      _textController.text = args['religion'] ?? '';
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
      // 🔹 Call ADD API (Uncomment this when implementing)
      await ref.read(religionProvider.notifier).addreligion(religions:_textController.text);
      // _textController.text,
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added successfully")),
      );
    } else {
      // 🔹 Call UPDATE API (Uncomment this when implementing)
      await ref.read(religionProvider.notifier).updateREligion(_editingId!, text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Updated successfully")),
      );
    }

    Navigator.pop(context); // Go back to previous screen
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
        title: Text(_editingId == null ? "Add religion" : "Edit religion"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
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
                    labelText: 'Enter value',
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
                    _editingId == null ? "Add Religion" : "Update Religion",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
