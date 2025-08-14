import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/provider/signupprocessProviders%20copy/lookingProvider.dart';
import 'package:admin_dating/provider/signupprocessProviders%20copy/modeProvider.dart'; // <-- mode provider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Lookingforpostscreen extends ConsumerStatefulWidget {
  const Lookingforpostscreen({super.key});

  @override
  ConsumerState<Lookingforpostscreen> createState() =>
      _LookingforpostscreenState();
}

class _LookingforpostscreenState extends ConsumerState<Lookingforpostscreen> {
  final TextEditingController _textController = TextEditingController();
  int? _editingId;
  int? _selectedModeId; // <-- mode selection

  @override
  void initState() {
    super.initState();
    // Fetch modes when screen opens
    Future.microtask(() {
      ref.read(modesProvider.notifier).getModes();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _editingId = args['id'] as int?;
      _textController.text = args['value'] ?? '';
      _selectedModeId = args['modeid'] as int?;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final text = _textController.text.trim();

    if (text.isEmpty || _selectedModeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter value and select mode.")),
      );
      return;
    }

    if (_editingId == null) {
      // ADD API
      await ref
          .read(lookingProvider.notifier)
          .addLooking(value: text, modeId: _selectedModeId!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added successfully")),
      );
    } else {
      // UPDATE API
      await ref
          .read(lookingProvider.notifier)
          .updateLookingfor(_editingId!, text, _selectedModeId!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Updated successfully")),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final modeState = ref.watch(modesProvider);
    final modeList = modeState.data ?? [];

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
        title:
            Text(_editingId == null ? "Add Looking For" : "Edit Looking For"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Value input
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              const SizedBox(height: 20),

              // Mode dropdown
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                child: DropdownButtonFormField<int>(
                  value: _selectedModeId,
                  items: modeList.map((mode) {
                    return DropdownMenuItem<int>(
                      value: mode.id,
                      child: Text(mode.value ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedModeId = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Select Mode",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Spacer(),

              // Submit button
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
                    _editingId == null ? "Add LookingFor" : "Update LookingFor",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
