import 'package:flutter/material.dart';
import 'package:admin_dating/models/more section/relationshipmodel.dart';

class Relationshipscreen extends StatefulWidget {
  final List<Data> allrelationship;
  final List<int> initiallySelectedIds;
  final List<String> initiallySelectedNames;

  const Relationshipscreen({
    super.key,
    required this.allrelationship,
    this.initiallySelectedIds = const [],
    this.initiallySelectedNames = const [],
  });

  @override
  State<Relationshipscreen> createState() => _RelationshipscreenState();
}

class _RelationshipscreenState extends State<Relationshipscreen> {
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
        _selectedLookingNames.remove(item.relation);
      } else {
        _selectedLookingIds.add(item.id!);
        _selectedLookingNames.add(item.relation ?? '');
      }
    });
  }

  void _onDone() {
    Navigator.pop(context, {
      'id': _selectedLookingIds,
      'relation': _selectedLookingNames,
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
              const Text("Select relation\n(Only 2 allowed)",
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
            itemCount: widget.allrelationship.length,
            itemBuilder: (context, index) {
              final item = widget.allrelationship[index];
              final isSelected = _selectedLookingIds.contains(item.id);

              return ListTile(
                title: Text(item.relation ?? ''),
                trailing: isSelected
                    ? const Icon(Icons.check_box, color: Colors.green)
                    : const Icon(Icons.check_box_outline_blank),
                onTap: () {
                  if (isSelected || _selectedLookingIds.length < 2) {
                    _onItemTapped(item);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You can select only 2 relation"),
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
