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
  late List<int> _selectedRelationshipIds;
  late List<String> _selectedRelationshipNames;

  @override
  void initState() {
    super.initState();
    _selectedRelationshipIds = List<int>.from(widget.initiallySelectedIds);
    _selectedRelationshipNames = List<String>.from(widget.initiallySelectedNames);
  }

  void _onItemTapped(Data item) {
    setState(() {
      if (_selectedRelationshipIds.contains(item.id)) {
        // If already selected, deselect it
        _selectedRelationshipIds.remove(item.id);
        _selectedRelationshipNames.remove(item.relation);
      } else {
        // If not selected, replace any existing selection with the new one
        _selectedRelationshipIds.clear();
        _selectedRelationshipNames.clear();
        _selectedRelationshipIds.add(item.id!);
        _selectedRelationshipNames.add(item.relation ?? '');
      }
    });
  }

  void _onDone() {
    Navigator.pop(context, {
      'id': _selectedRelationshipIds,
      'relation': _selectedRelationshipNames,
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
                const Text(
                  "Select relationship\n(Only 1 allowed)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _onDone,
                  child: const Text("Done"),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: widget.allrelationship.length,
              itemBuilder: (context, index) {
                final item = widget.allrelationship[index];
                final isSelected = _selectedRelationshipIds.contains(item.id);

                return ListTile(
                  title: Text(item.relation ?? ''),
                  trailing: isSelected
                      ? const Icon(Icons.radio_button_checked, color: Colors.green)
                      : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                  onTap: () => _onItemTapped(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}