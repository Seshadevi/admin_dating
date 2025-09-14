import 'package:admin_dating/models/signupprocessmodels/choosefoodies_model.dart';
// import 'package:admin_dating/models/signupprocessmodels/choosefoodies_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'your_interest_model.dart'; // Replace with your actual model import

class InterestsScreen extends ConsumerStatefulWidget {
  final List<Data> allInterestsScreen;
  final List<int> initiallySelectedIds;
  final List<String> initiallySelectedNames;

  const InterestsScreen({
    super.key,
    required this.allInterestsScreen,
     this.initiallySelectedIds= const [],
     this.initiallySelectedNames= const [],
  });

  @override
  ConsumerState<InterestsScreen> createState() =>
      _InterestsScreenState();
}

class _InterestsScreenState
    extends ConsumerState<InterestsScreen> {
  late List<int> _selectedInterestIds;
  late List<String> _selectedInterestNames;

  @override
  void initState() {
    super.initState();
    _selectedInterestIds = List<int>.from(widget.initiallySelectedIds);
    _selectedInterestNames =List<String>.from(widget.initiallySelectedNames);
  }

  // void _toggleSelection(bool? checked, Data interest) {
  //   setState(() {
  //     if (checked == true) {
  //       if (_selectedInterestIds.length < 4) {
  //         _selectedInterestIds.add(interest.id!);
  //         _selectedInterestNames.add(interest.causesAndCommunities ?? '');
  //       }
  //     } else {
  //       _selectedInterestIds.remove(interest.id);
  //       _selectedInterestNames.remove(interest.causesAndCommunities ?? '');
  //     }
  //   });
  // }
  void _onItemTapped(Data item) {
    setState(() {
      if (_selectedInterestIds.contains(item.id)) {
        _selectedInterestIds.remove(item.id);
        _selectedInterestNames.remove(item.interests);
      } else {
       _selectedInterestIds.add(item.id!);
       _selectedInterestNames.add(item.interests ?? '');
      }
    });
  }
  void _onDone() {
    Navigator.pop(context, {
      'id': _selectedInterestIds,
      'interests': _selectedInterestNames,
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
              const Text("Select interestsScreen\n(Only 4 allowed)",
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
            itemCount: widget.allInterestsScreen.length,
            itemBuilder: (context, index) {
              final item = widget.allInterestsScreen[index];
              final isSelected = _selectedInterestIds.contains(item.id);

              return ListTile(
                title: Text(item.interests ?? ''),
                trailing: isSelected
                    ? const Icon(Icons.check_box, color: Colors.green)
                    : const Icon(Icons.check_box_outline_blank),
                onTap: () {
                  if (isSelected || _selectedInterestIds.length < 4) {
                    _onItemTapped(item);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You can select only 4 interestsScreen"),
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
