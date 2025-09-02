import 'package:flutter/material.dart';

import '../../../models/more section/industrymodel.dart';
// import 'package:admin_dating/models/signupprocessmodels/lookingModel.dart';

class Industryscreen extends StatefulWidget {
  final List<Data> allIndustry;
  final List<int> initiallySelectedIds;
  final List<String> initiallySelectedNames;

  const Industryscreen({
    super.key,
    required this.allIndustry,
    this.initiallySelectedIds = const [],
    this.initiallySelectedNames = const [],
  });

  @override
  State<Industryscreen> createState() => _IndustryscreenState();
}

class _IndustryscreenState extends State<Industryscreen> {
  late List<int> _selectedIndustryId;
  late List<String> _selectedIndustryNames;

  @override
  void initState() {
    super.initState();
    _selectedIndustryId = List<int>.from(widget.initiallySelectedIds);
    _selectedIndustryNames = List<String>.from(widget.initiallySelectedNames);
  }

  void _onItemTapped(Data item) {
    setState(() {
      if (_selectedIndustryId.contains(item.id)) {
        _selectedIndustryId.remove(item.id);
        _selectedIndustryNames.remove(item.industry);
      } else {
        _selectedIndustryId.add(item.id!);
        _selectedIndustryNames.add(item.industry ?? '');
      }
    });
  }

  void _onDone() {
    Navigator.pop(context, {
      'id': _selectedIndustryId,
      'industry': _selectedIndustryNames,
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
              const Text("Select industry\n(Only 2 allowed)",
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
            itemCount: widget.allIndustry.length,
            itemBuilder: (context, index) {
              final item = widget.allIndustry[index];
              final isSelected = _selectedIndustryId.contains(item.id);

              return ListTile(
                title: Text(item.industry ?? ''),
                trailing: isSelected
                    ? const Icon(Icons.check_box, color: Colors.green)
                    : const Icon(Icons.check_box_outline_blank),
                onTap: () {
                  if (isSelected || _selectedIndustryId.length < 2) {
                    _onItemTapped(item);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You can select only 1industry for"),
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
