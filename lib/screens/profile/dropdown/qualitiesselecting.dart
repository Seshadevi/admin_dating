// import 'package:admin_dating/models/signupprocessmodels/lookingModel.dart';
import 'package:flutter/material.dart';
import 'package:admin_dating/models/signupprocessmodels/qualitiesModel.dart';

class QualitiesSelection extends StatefulWidget {
  final List<Data> all;
  final List<int> initiallySelectedIds;
  final List<String> initiallySelectedNames;

  const QualitiesSelection({
    super.key,
    required this.all,
    this.initiallySelectedIds = const [],
    this.initiallySelectedNames = const [],
   
  });

  @override
  State<QualitiesSelection> createState() => _QualitiesSelectionState();
}

class _QualitiesSelectionState extends State<QualitiesSelection> {
  late List<int> _selectedqualitiesIds;
  late List<String> _selectedQualitiesNames;

  @override
  void initState() {
    super.initState();
    _selectedqualitiesIds = List<int>.from(widget.initiallySelectedIds);
    _selectedQualitiesNames = List<String>.from(widget.initiallySelectedNames);
  }

  void _onItemTapped(Data item) {
    setState(() {
      if (_selectedqualitiesIds.contains(item.id)) {
        _selectedqualitiesIds.remove(item.id);
        _selectedQualitiesNames.remove(item.name);
      } else {
        _selectedqualitiesIds.add(item.id!);
        _selectedQualitiesNames.add(item.name ?? '');
      }
    });
  }

  void _onDone() {
    print("Selected Qualities IDs: $_selectedqualitiesIds");
  print("Selected Qualities Names: $_selectedQualitiesNames");
    Navigator.pop(context, {
      'id': _selectedqualitiesIds,
      'name': _selectedQualitiesNames,
    });
  }
  

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Select qualities For\nselect 4 interests only"),
  //       actions: [
  //         TextButton(
  //           onPressed: _onDone,
  //           child: const Text("Done", style: TextStyle(color: Color.fromARGB(255, 20, 18, 18))),
  //         )
  //       ],
  //     ),
  //     body: ListView.builder(
  //       itemCount: widget.all.length,
  //       itemBuilder: (context, index) {
  //         final item = widget.all[index];
  //         final isSelected = _selectedqualitiesIds.contains(item.id);

  //         return ListTile(
  //           title: Text(item.name ?? ''),
  //           trailing: isSelected
  //               ? const Icon(Icons.check_circle, color: Colors.green)
  //               : const Icon(Icons.circle_outlined),
  //           onTap: () => _onItemTapped(item),
  //         );
  //       },
  //     ),
  //   );
  // }
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
              const Text("Select Qualities\n(Only 4 allowed)",
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
            itemCount: widget.all.length,
            itemBuilder: (context, index) {
              final item = widget.all[index];
              final isSelected = _selectedqualitiesIds.contains(item.id);

              return ListTile(
                title: Text(item.name ?? ''),
                trailing: isSelected
                    ? const Icon(Icons.check_box, color: Colors.green)
                    : const Icon(Icons.check_box_outline_blank),
                onTap: () {
                  if (isSelected || _selectedqualitiesIds.length < 4) {
                    _onItemTapped(item);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You can select only 4 qualities"),
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
