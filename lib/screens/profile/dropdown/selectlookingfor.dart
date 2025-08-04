import 'package:flutter/material.dart';
import 'package:admin_dating/models/signupprocessmodels/lookingModel.dart';

class LookingForSelection extends StatefulWidget {
  final List<Data> alllooking;
  final List<int> initiallySelectedIds;
  final List<String> initiallySelectedNames;

  const LookingForSelection({
    super.key,
    required this.alllooking,
    this.initiallySelectedIds = const [],
    this.initiallySelectedNames = const [],
  });

  @override
  State<LookingForSelection> createState() => _LookingForSelectionState();
}

class _LookingForSelectionState extends State<LookingForSelection> {
  late List<int> _selectedLookingIds;
  late List<String> _selectedLookingNames;

  @override
  void initState() {
    super.initState();
    _selectedLookingIds = List<int>.from(widget.initiallySelectedIds);
    _selectedLookingNames = List<String>.from(widget.initiallySelectedNames);
  }

  void _onItemTapped(Data item) {
    setState(() {
      if (_selectedLookingIds.contains(item.id)) {
        _selectedLookingIds.remove(item.id);
        _selectedLookingNames.remove(item.value);
      } else {
        _selectedLookingIds.add(item.id!);
        _selectedLookingNames.add(item.value ?? '');
      }
    });
  }

  void _onDone() {
    Navigator.pop(context, {
      'id': _selectedLookingIds,
      'value': _selectedLookingNames,
    });
  }

 @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Select lookingfor\n(Only 2 allowed)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: _onDone,
                child: const Text("Done"),
              )
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: widget.alllooking.length,
            itemBuilder: (context, index) {
              final item = widget.alllooking[index];
              final isSelected = _selectedLookingIds.contains(item.id);

              return ListTile(
                title: Text(item.value ?? ''),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.circle_outlined),
                onTap: () {
                  if (isSelected || _selectedLookingIds.length < 2) {
                    _onItemTapped(item);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You can select only 2 looking for"),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}
}
