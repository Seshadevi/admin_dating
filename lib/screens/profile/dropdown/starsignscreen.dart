import 'package:flutter/material.dart';
import 'package:admin_dating/models/more section/starsign.dart';

class StarsignSelection extends StatefulWidget {
  final List<Data> allstarsign;
  final List<int> initiallySelectedIds;
  final List<String> initiallySelectedNames;

  const StarsignSelection({
    super.key,
    required this.allstarsign,
    this.initiallySelectedIds = const [],
    this.initiallySelectedNames = const [],
  });

  @override
  State<StarsignSelection> createState() => _StarsignSelectionState();
}

class _StarsignSelectionState extends State<StarsignSelection> {
  late List<int> _selectedStarsignIds;
  late List<String> _selectedStarsignNames;

  @override
  void initState() {
    super.initState();
    _selectedStarsignIds = List<int>.from(widget.initiallySelectedIds);
    _selectedStarsignNames = List<String>.from(widget.initiallySelectedNames);
  }

  void _onItemTapped(Data item) {
    setState(() {
      if (_selectedStarsignIds.contains(item.id)) {
        _selectedStarsignIds.remove(item.id);
        _selectedStarsignNames.remove(item.name);
      } else {
        _selectedStarsignIds.add(item.id!);
        _selectedStarsignNames.add(item.name?? '');
      }
    });
  }

  void _onDone() {
    Navigator.pop(context, {
      'id': _selectedStarsignIds,
      'name': _selectedStarsignNames,
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
              const Text("Select Starsign",
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
            itemCount: widget.allstarsign.length,
            itemBuilder: (context, index) {
              final item = widget.allstarsign[index];
              final isSelected = _selectedStarsignIds.contains(item.id);

              return ListTile(
                title: Text(item.name ?? ''),
                trailing: isSelected
                    ? const Icon(Icons.radio_button_checked, color: Colors.green)
                    : const Icon(Icons.radio_button_unchecked),
                onTap: () {
                  if (isSelected || _selectedStarsignIds.length < 1) {
                    _onItemTapped(item);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You can select Starsign"),
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
