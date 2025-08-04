// i
import 'package:admin_dating/models/signupprocessmodels/defaultMessagesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DefaultMessage extends ConsumerStatefulWidget {
  final List<Data> allMesages;
  final List<int> initiallySelectedIds;
  final List<String> initiallySelectedNames;

  const DefaultMessage({
    super.key,
    required this.allMesages,
     this.initiallySelectedIds= const [],
     this.initiallySelectedNames= const [],
  });

  @override
  ConsumerState<DefaultMessage> createState() =>
      _DefaultMessageState();
}

class _DefaultMessageState
    extends ConsumerState<DefaultMessage> {
  late List<int> _selectedmesagesIds;
  late List<String> _selectedmesagesNames;

  @override
  void initState() {
    super.initState();
    _selectedmesagesIds = List<int>.from(widget.initiallySelectedIds);
    _selectedmesagesNames =List<String>.from(widget.initiallySelectedNames);
  }

  // void _toggleSelection(bool? checked, Data interest) {
  //   setState(() {
  //     if (checked == true) {
  //       if (_selectedmesagesIds.length < 4) {
  //         _selectedmesagesIds.add(interest.id!);
  //         _selectedmesagesNames.add(interest.causesAndCommunities ?? '');
  //       }
  //     } else {
  //       _selectedmesagesIds.remove(interest.id);
  //       _selectedmesagesNames.remove(interest.causesAndCommunities ?? '');
  //     }
  //   });
  // }
  void _onItemTapped(Data item) {
    setState(() {
      if (_selectedmesagesIds.contains(item.id)) {
        _selectedmesagesIds.remove(item.id);
        _selectedmesagesNames.remove(item.message);
      } else {
       _selectedmesagesIds.add(item.id!);
       _selectedmesagesNames.add(item.message?? '');
      }
    });
  }
  void _onDone() {
    Navigator.pop(context, {
      'id': _selectedmesagesIds,
      'mesages': _selectedmesagesNames,
    });
  }

  // @override
  //  Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Select measages For\nselect 4 measages only"),
  //       actions: [
  //         TextButton(
  //           onPressed: _onDone,
  //           child: const Text("Done", style: TextStyle(color: Color.fromARGB(255, 20, 18, 18))),
  //         )
  //       ],
  //     ),
  //     body: ListView.builder(
  //       itemCount: widget.allMesages.length,
  //       itemBuilder: (context, index) {
  //         final item = widget.allMesages[index];
  //         final isSelected = _selectedmesagesIds.contains(item.id);

  //         return ListTile(
  //           title: Text(item.message ?? ''),
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
              const Text("Select defaultmessages\n(Only 3 allowed)",
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
            itemCount: widget.allMesages.length,
            itemBuilder: (context, index) {
              final item = widget.allMesages[index];
              final isSelected = _selectedmesagesIds.contains(item.id);

              return ListTile(
                title: Text(item.message ?? ''),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.circle_outlined),
                onTap: () {
                  if (isSelected || _selectedmesagesIds.length < 3) {
                    _onItemTapped(item);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You can select only 3 messages"),
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
