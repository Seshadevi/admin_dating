import 'package:flutter/material.dart';
import 'package:admin_dating/models/more section/languages.dart';

class Lannguagescreen extends StatefulWidget {
  final List<Data> allLanguage;
  final List<int> initiallySelectedIds;
  final List<String> initiallySelectedNames;

  const Lannguagescreen({
    super.key,
    required this.allLanguage,
    this.initiallySelectedIds = const [],
    this.initiallySelectedNames = const [],
  });

  @override
  State<Lannguagescreen> createState() => _LannguagescreenState();
}

class _LannguagescreenState extends State<Lannguagescreen> {
  late List<int> _selectedLanguageIds;
  late List<String> _selectedLanguagesNames;

  @override
  void initState() {
    super.initState();
    _selectedLanguageIds = List<int>.from(widget.initiallySelectedIds);
    _selectedLanguagesNames = List<String>.from(widget.initiallySelectedNames);
  }

  void _onItemTapped(Data item) {
    setState(() {
      if (_selectedLanguageIds.contains(item.id)) {
        _selectedLanguageIds.remove(item.id);
        _selectedLanguagesNames.remove(item.name);
      } else {
        _selectedLanguageIds.add(item.id!);
        _selectedLanguagesNames.add(item.name ?? '');
      }
    });
  }

  void _onDone() {
    Navigator.pop(context, {
      'id': _selectedLanguageIds,
      'name': _selectedLanguagesNames,
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
              const Text("Select 4 languages",
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
            itemCount: widget.allLanguage.length,
            itemBuilder: (context, index) {
              final item = widget.allLanguage[index];
              final isSelected = _selectedLanguageIds.contains(item.id);

              return ListTile(
                title: Text(item.name ?? ''),
                trailing: isSelected
                    ? const Icon(Icons.check_box, color: Colors.green)
                    : const Icon(Icons.check_box_outline_blank),
                onTap: () {
                  if (isSelected || _selectedLanguageIds.length < 4) {
                    _onItemTapped(item);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You can select only 4 languages"),
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
