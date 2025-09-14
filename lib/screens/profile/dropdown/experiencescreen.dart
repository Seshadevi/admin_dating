import 'package:flutter/material.dart';
import 'package:admin_dating/models/more section/experiencemodel.dart';

class ExperienceSelection extends StatefulWidget {
  final List<Data> allexperience;
  final List<int> initiallySelectedIds;
  final List<String> initiallySelectedNames;

  const ExperienceSelection({
    super.key,
    required this.allexperience,
    this.initiallySelectedIds = const [],
    this.initiallySelectedNames = const [],
  });

  @override
  State<ExperienceSelection> createState() => _ExperienceSelectionState();
}

class _ExperienceSelectionState extends State<ExperienceSelection> {
  late List<int> _selectedExperienceIds;
  late List<String> _selectedExperienceNames;

  @override
  void initState() {
    super.initState();
    _selectedExperienceIds = List<int>.from(widget.initiallySelectedIds);
    _selectedExperienceNames = List<String>.from(widget.initiallySelectedNames);
  }

  void _onItemTapped(Data item) {
    setState(() {
      if (_selectedExperienceIds.contains(item.id)) {
        _selectedExperienceIds.remove(item.id);
        _selectedExperienceNames.remove(item.experience);
      } else {
        _selectedExperienceIds.add(item.id!);
        _selectedExperienceNames.add(item.experience ?? '');
      }
    });
  }

  void _onDone() {
    Navigator.pop(context, {
      'id': _selectedExperienceIds,
      'experience': _selectedExperienceNames,
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
              const Text("Select experience)",
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
            itemCount: widget.allexperience.length,
            itemBuilder: (context, index) {
              final item = widget.allexperience[index];
              final isSelected = _selectedExperienceIds.contains(item.id);

              return ListTile(
                title: Text(item.experience ?? ''),
                trailing: isSelected
                    ? const Icon(Icons.radio_button_checked, color: Colors.green)
                    : const Icon(Icons.radio_button_unchecked),
                onTap: () {
                  if (isSelected || _selectedExperienceIds.length < 1) {
                    _onItemTapped(item);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You can select only 1 experience"),
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
