// import 'package:admin_dating/models/signupprocessmodels/choosefoodies_model.dart';
// import 'package:admin_dating/provider/loginprovider.dart';
// import 'package:admin_dating/provider/signupprocessProviders%20copy/causesProvider.dart';
// import 'package:admin_dating/provider/signupprocessProviders%20copy/choosr_foodies_provider.dart';
// import 'package:admin_dating/provider/signupprocessProviders%20copy/defaultmessages.dart';
// import 'package:admin_dating/provider/signupprocessProviders%20copy/drinkingProvider.dart';
// import 'package:admin_dating/provider/signupprocessProviders%20copy/kidsProvider.dart';
// import 'package:admin_dating/provider/signupprocessProviders%20copy/lookingProvider.dart';
// import 'package:admin_dating/provider/signupprocessProviders%20copy/modeProvider.dart';
// import 'package:admin_dating/provider/signupprocessProviders%20copy/qualities.dart';
// import 'package:admin_dating/provider/signupprocessProviders%20copy/religionProvider.dart';
// import 'package:admin_dating/screens/profile/dropdown/defaultmessages.dart';
// import 'package:admin_dating/screens/profile/dropdown/qualitiesselecting.dart';
// import 'package:admin_dating/screens/profile/dropdown/selectcause.dart';
// import 'package:admin_dating/screens/profile/dropdown/selectlookingfor.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// import '../../provider/signupprocessProviders copy/genderProvider.dart';

// class AddProfileScreen extends ConsumerStatefulWidget {
//   const AddProfileScreen({super.key});

//   @override
//   ConsumerState<AddProfileScreen> createState() => _AddProfileScreenState();
// }

// class _AddProfileScreenState extends ConsumerState<AddProfileScreen> {
//   List<File?> _selectedImages = List.filled(6, null);

//   final ImagePicker _picker = ImagePicker();

//   // Controllers for text fields
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   TextEditingController _bioController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();

//   List<String> prompts = [];
//   bool isEditingPrompt = false;
//   int? editingIndex;
//   final TextEditingController promptController = TextEditingController();

//   List<File> _finalSelectedImages = [];
//   // Dropdown values
//   String? _selectedBirth;
//   String? _selectedGender;
//   // String? _selectedBH;
//   String? _selectedMode;
//   String? _selectedDrinking;
//   String? _selectedKids;
//   String? _selectedReligion;
//   String? _selectedAge;
//   String? _selectedInterest;
//   String? _selectedLookingFor;
//   String? _selectedWriteFewWords;
//   bool _showProfile = false;
//   String? _selectedTheirGender;
//   List<int> _selectedInterestIds = [];
//   List<String> _selectedInterestNames = [];
//   List<int> _selectedcauseIds = [];
//   List<String> _selectedcauseNames = [];
//   List<int> _selectedLookingIds = [];
//   List<String> _selectedLookingNames = [];
//   List<int> _selectedqualitiesIds = [];
//   List<int> _selectedkidsIds = [];
//   List<int>? _selectedmodeId;
//   List<int> _selecteddrinkingIds = [];
//   List<String> _selectedqualitiesNames = [];
//   List<int> _selectedmesagesIds = [];
//   List<String> _selectedmesagesNames = [];
//   List<int> _selectedgenderIds = [];
//   List<int> _selectedreligionIds = [];
//   double? selectedLat;
//   double? selectedLng;
//   String? selectedAddress;

// // void _openCausesDialog() {
// //   Navigator.push(
// //     context,                  888888
// //     MaterialPageRoute(
// //       fullscreenDialog: true,
// //       builder: (context) => CausesSelectionWidget(
// //         initiallySelectedIds: _result,
// //         onSelectionDone: (selectedIds) {
// //           setState(() {
// //             _result = selectedIds;
// //           });
// //         },
// //       ),
// //     ),
// //   );
// // }

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() => ref.read(genderProvider.notifier).getGender());
//     Future.microtask(() => ref.read(modesProvider.notifier).getModes());
//     Future.microtask(() => ref.read(interestsProvider.notifier).getInterests());
//     Future.microtask(() => ref.read(causesProvider.notifier).getCauses());
//     Future.microtask(() => ref.read(lookingProvider.notifier).getLookingFor());
//     Future.microtask(() => ref.read(qualitiesProvider.notifier).getQualities());
//     Future.microtask(() => ref.read(drinkingProvider.notifier).getdrinking());
//     Future.microtask(() => ref.read(religionProvider.notifier).getReligions());
//     Future.microtask(() => ref.read(kidsProvider.notifier).getKids());
//     Future.microtask(
//         () => ref.read(defaultmessagesProvider.notifier).getdefaultmessages());
//   }

//   Future<void> _pickImages(int index) async {
//     final XFile? pickedFile =
//         await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImages[index] = File(pickedFile.path);
//       });
//     }
//   }

//   void _showAccessDialog() {
//     final TextEditingController emailController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Enter Mail Id',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.green,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     hintText: 'Enter your email',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(color: Colors.grey),
//                     ),
//                     contentPadding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 const SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     _showSuccessDialog();
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Text(
//                       'Ok',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.check_circle, color: Colors.green, size: 60),
//               const SizedBox(height: 16),
//               const Text('Success!',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               const Text('Your profile has been saved.'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showInterestDialog(BuildContext context, List<Data> items) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         final tempSelectedIds = [..._selectedInterestIds];
//         final tempSelectedNames = [..._selectedInterestNames];

//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return AlertDialog(
//               title: const Text("Select Interests"),
//               content: SizedBox(
//                 width: double.infinity,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: items.length,
//                   itemBuilder: (context, index) {
//                     final interest = items[index];
//                     final isSelected = tempSelectedIds.contains(interest.id);
//                     return CheckboxListTile(
//                       value: isSelected,
//                       title: Text(interest.interests ?? ''),
//                       activeColor: Colors.blue, // ✅ box color when checked
//                       checkColor: Colors.white,
//                       onChanged: (checked) {
//                         setDialogState(() {
//                           if (checked == true) {
//                             if (tempSelectedIds.length < 4) {
//                               tempSelectedIds.add(interest.id!);
//                               tempSelectedNames.add(interest.interests ?? '');
//                             }
//                           } else {
//                             tempSelectedIds.remove(interest.id);
//                             tempSelectedNames.remove(interest.interests);
//                           }
//                         });
//                       },
//                     );
//                   },
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Cancel"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _selectedInterestIds
//                         ..clear()
//                         ..addAll(tempSelectedIds);
//                       _selectedInterestNames
//                         ..clear()
//                         ..addAll(tempSelectedNames);
//                     });
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Done"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   void _onLocationSelected(String address, double lat, double lng) {
//     setState(() {
//       selectedAddress = address;
//       selectedLat = lat;
//       selectedLng = lng;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final genderData = ref.watch(genderProvider);
//     final drinkingData = ref.watch(drinkingProvider);
//     final kidsData = ref.watch(kidsProvider);
//     final religionData = ref.watch(religionProvider);
//     final modeData = ref.watch(modesProvider);
//     final interestData = ref.watch(interestsProvider);
//     final causesData = ref.watch(causesProvider);
//     final lookingFor = ref.watch(lookingProvider);
//     final qualitiesData = ref.watch(qualitiesProvider);
//     final defaultMesages = ref.watch(defaultmessagesProvider);
//     final defaultList = defaultMesages.data ?? [];
//     final lookinglist = lookingFor.data ?? [];
//     final interestsList = interestData.data ?? [];
//     final causessList = causesData.data ?? [];
//     final qualitiesList = qualitiesData.data ?? [];
//     print('causessList........................$causessList');
//     print('interestlist................$interestsList');
//     print('lookingLIst..........$lookinglist');
//     print('defaultList..........$defaultList');

//     return Scaffold(
//       backgroundColor: const Color(0xffB2D12E),
//       appBar: AppBar(
//         backgroundColor: const Color(0xffB2D12E),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Add Profile',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         actions: [
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.more_vert, color: Colors.white),
//             onSelected: (String result) {
//               if (result == 'give_access') {
//                 _showAccessDialog();
//               } else if (result == 'successful') {
//                 _showSuccessDialog();
//               }
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//               const PopupMenuItem<String>(
//                 value: 'give_access',
//                 child: Text('Give Access'),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // White container with form
//           Container(
//             margin: const EdgeInsets.only(top: 1),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(25),
//                 topRight: Radius.circular(25),
//               ),
//             ),
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.only(
//                   top: 20, left: 20, right: 20, bottom: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title

//                   Positioned(
//                     top: 0,
//                     left: 0,
//                     right: 0,
//                     child: Center(
//                       child: Column(
//                         children: [
//                           Wrap(
//                             spacing: 10,
//                             runSpacing: 10,
//                             children: List.generate(6, (index) {
//                               return GestureDetector(
//                                 onTap: () async {
//                                   final pickedFile = await _picker.pickImage(
//                                       source: ImageSource.gallery);
//                                   if (pickedFile != null) {
//                                     setState(() {
//                                       _selectedImages[index] =
//                                           File(pickedFile.path);

//                                       final selected = _selectedImages
//                                           .whereType<File>()
//                                           .toList();

//                                       // ✅ Automatically store if at least 4 images are picked
//                                       if (selected.length >= 4) {
//                                         _finalSelectedImages = selected;
//                                         print(
//                                             "✅ Stored ${_finalSelectedImages.length} images");
//                                       }
//                                     });
//                                   }
//                                 },
//                                 child: Container(
//                                   width: 90,
//                                   height: 90,
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[200],
//                                     border: Border.all(color: Colors.grey),
//                                     borderRadius: BorderRadius.circular(16),
//                                     image: _selectedImages[index] != null
//                                         ? DecorationImage(
//                                             image: FileImage(
//                                                 _selectedImages[index]!),
//                                             fit: BoxFit.cover,
//                                           )
//                                         : null,
//                                   ),
//                                   child: _selectedImages[index] == null
//                                       ? const Icon(Icons.add_a_photo,
//                                           color: Colors.grey)
//                                       : null,
//                                 ),
//                               );
//                             }),
//                           ),
//                           // const SizedBox(height: 10),
//                           const Text(
//                             " select at least 4 images",
//                             style: TextStyle(
//                                 color: Color.fromARGB(255, 26, 29, 26),
//                                 fontSize: 10),
//                           ),

//                           // ✅ Optional: show message when 4 or more images are selected
//                           // if (_selectedImages.whereType<File>().length >= 4)
//                           //   const Text(
//                           //     "✅ Minimum 4 images selected",
//                           //     style: TextStyle(color: Colors.green),
//                           //   ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // const SizedBox(height: 10),

//                   // First Name
//                   const Text('First Name',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 5),
//                   TextField(
//                     controller: _firstNameController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // Last Name
//                   const Text('Last Name',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 5),
//                   TextField(
//                     controller: _lastNameController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // Date of Birth
//                   const Text('Date of Birth',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 5),
//                   GestureDetector(
//                     onTap: () async {
//                       DateTime? pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime(2000),
//                         firstDate: DateTime(1900),
//                         lastDate: DateTime.now(),
//                       );
//                       if (pickedDate != null) {
//                         setState(() {
//                           _selectedBirth =
//                               "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//                         });
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 15),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             _selectedBirth ?? 'Select Date of Birth',
//                             style: const TextStyle(
//                                 fontSize: 14, color: Colors.black87),
//                           ),
//                           const Icon(Icons.calendar_today, color: Colors.grey),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // Email
//                   const Text('Email',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 5),
//                   TextFormField(
//                     controller: _emailController,
//                     keyboardType: TextInputType
//                         .emailAddress, // <-- this enables email keyboard
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       hintText: 'Enter your email', // optional
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Email is required';
//                       }
//                       final emailRegex =
//                           RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//                       if (!emailRegex.hasMatch(value)) {
//                         return 'Enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 10),

//                   // Inside your widget:
//                   const Text(
//                     'Phone Number',
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 5),
//                   TextField(
//                     controller: _phoneController,
//                     keyboardType: TextInputType.phone,
//                     inputFormatters: [
//                       FilteringTextInputFormatter
//                           .digitsOnly, // allow digits only
//                       LengthLimitingTextInputFormatter(
//                           10), // limit to 10 digits
//                     ],
//                     decoration: InputDecoration(
//                       prefixText: '+91 ',
//                       prefixStyle: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       hintText: 'Enter number',
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // Gender Dropdown
//                   const Text(
//                     'Your Gender',
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 5),
//                   DropdownButtonFormField<String>(
//                     value: _selectedGender,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                     ),
//                     items: const [
//                       DropdownMenuItem(value: 'Man', child: Text('Man')),
//                       DropdownMenuItem(value: 'Woman', child: Text('Woman')),
//                       DropdownMenuItem(
//                           value: 'Nonbinary', child: Text('Nonbinary')),
//                     ],
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedGender = value;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   if (_selectedGender != null)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Show on Profile',
//                           style: TextStyle(fontSize: 14, color: Colors.grey),
//                         ),
//                         Switch(
//                           value: _showProfile,
//                           onChanged: (value) {
//                             setState(() {
//                               _showProfile = value;
//                               // You can use `_showProfile` wherever needed (true/false)
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Your Height',
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 5),
//                   TextField(
//                     controller: _heightController,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly, // only numbers
//                     ],
//                     decoration: InputDecoration(
//                       hintText: 'ex:158', // dummy example
//                       suffixText: 'cm',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // BH Dropdown
//                   const Text('Interest Gender',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 5),
//                   DropdownButtonFormField<String>(
//                     value: _selectedTheirGender,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                     ),
//                     items: genderData.data?.map((dataItem) {
//                       return DropdownMenuItem<String>(
//                         value: dataItem.value,
//                         child: Text(dataItem.value ?? ''),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedTheirGender = value;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 10),

//                   // Profession Dropdown
//                   const Text('Mode',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 5),
//                   DropdownButtonFormField<String>(
//                     value: _selectedMode,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                     ),
//                     items: modeData.data?.map((dataItem) {
//                       return DropdownMenuItem<String>(
//                         value: dataItem.value,
//                         child: Text(dataItem.value ?? ''),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() => _selectedMode = value);
//                     },
//                   ),

//                   const SizedBox(height: 10),
//                   const Text('Select interests',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: () => _showInterestDialog(context, interestsList),
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 14),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         _selectedInterestNames.isEmpty
//                             ? "Tap to select interests"
//                             : _selectedInterestNames.join(', '),
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ),
//                   ),
//                   if (_selectedInterestIds.length < 4)
//                     const Padding(
//                       padding: EdgeInsets.only(top: 6),
//                       child: Text(
//                         "",
//                         style: TextStyle(
//                             color: Color.fromARGB(255, 135, 116, 115),
//                             fontSize: 2),
//                       ),
//                     ),

//                   const SizedBox(height: 10),
//                   const Text('Select causes',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: () async {
//                       final result = await showModalBottomSheet<
//                               Map<String, dynamic>>(
//                           context: context,
//                           isScrollControlled: true,
//                           backgroundColor: Colors
//                               .transparent, // Important for rounded corner card
//                           builder: (context) {
//                             return Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 20.0, vertical: 40),
//                                 child: Material(
//                                   borderRadius: BorderRadius.circular(25),
//                                   color: const Color(
//                                       0xFFF3EDF7), // Background like the image
//                                   child: SizedBox(
//                                     height: MediaQuery.of(context).size.height *
//                                         0.85,
//                                     width: MediaQuery.of(context).size.width *
//                                         0.85,
//                                     child: CausesSelectionScreen(
//                                       allInterests: causessList,
//                                       initiallySelectedIds: _selectedcauseIds,
//                                       initiallySelectedNames:
//                                           _selectedcauseNames,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           });

//                       if (result != null) {
//                         setState(() {
//                           _selectedcauseIds =
//                               List<int>.from(result['id'] ?? []);
//                           _selectedcauseNames =
//                               List<String>.from(result['causesAndCommunities']);
//                         });
//                       }
//                       print('selcetedcuased$_selectedcauseNames');

//                       // if (result != null) {
//                       //   setState(() {
//                       //     _result = result;
//                       //     _selectedcauseNames = causessList
//                       //         .where((e) => result.contains(e.id))
//                       //         .map((e) => e.causesAndCommunities ?? '')
//                       //         .toList();
//                       //   });
//                       // }
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 14),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         _selectedcauseIds.isEmpty
//                             ? "Tap to select causes"
//                             : _selectedcauseNames.join(', '),
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ),
//                   ),
//                   if (_selectedcauseIds.length < 4)
//                     Padding(
//                       padding: EdgeInsets.only(top: 6),
//                       child: Text(
//                         "",
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 135, 116, 115),
//                           fontSize: 2,
//                         ),
//                       ),
//                     ),

//                   // const SizedBox(height: 10),
//                   // --- LOOKING FOR SECTION ---
//                   const SizedBox(height: 10),
//                   const Text('Select looking for',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: () async {
//                       final result = await showModalBottomSheet<
//                               Map<String, dynamic>>(
//                           context: context,
//                           isScrollControlled: true,
//                           backgroundColor: Colors
//                               .transparent, // Important for rounded corner card
//                           builder: (context) {
//                             return Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 20.0, vertical: 40),
//                                 child: Material(
//                                   borderRadius: BorderRadius.circular(25),
//                                   color: const Color(
//                                       0xFFF3EDF7), // Background like the image
//                                   child: SizedBox(
//                                     height: MediaQuery.of(context).size.height *
//                                         0.9,
//                                     width: MediaQuery.of(context).size.width *
//                                         0.85,
//                                     child: LookingForSelection(
//                                       alllooking: lookinglist,
//                                       initiallySelectedIds: _selectedLookingIds,
//                                       initiallySelectedNames:
//                                           _selectedLookingNames,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           });

//                       if (result != null) {
//                         setState(() {
//                           _selectedLookingIds =
//                               List<int>.from(result['id'] ?? []);
//                           _selectedLookingNames =
//                               List<String>.from(result['value'] ?? []);
//                         });
//                       }
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 14),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         _selectedLookingIds.isEmpty
//                             ? "Tap to select looking for"
//                             : _selectedLookingNames.join(', '),
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ),
//                   ),
//                   if (_selectedLookingIds.length < 2)
//                     const Padding(
//                       padding: EdgeInsets.only(top: 6),
//                       child: Text(
//                         "",
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 135, 116, 115),
//                           fontSize: 2,
//                         ),
//                       ),
//                     ),

// // --- QUALITIES SECTION ---
//                   const SizedBox(height: 10),
//                   const Text('Select qualities for',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: () async {
//                       final result =
//                           await showModalBottomSheet<Map<String, dynamic>>(
//                         context: context,
//                         isScrollControlled: true,
//                         backgroundColor: Colors
//                             .transparent, // Important for rounded corner card
//                         builder: (context) {
//                           return Center(
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 20.0, vertical: 40),
//                               child: Material(
//                                 borderRadius: BorderRadius.circular(25),
//                                 color: const Color(
//                                     0xFFF3EDF7), // Background like the image
//                                 child: SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.9,
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.85,
//                                   child: QualitiesSelection(
//                                     all: qualitiesList,
//                                     initiallySelectedIds: _selectedqualitiesIds,
//                                     initiallySelectedNames:
//                                         _selectedqualitiesNames,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                       print('qualities:$_selectedqualitiesIds ');

//                       if (result != null) {
//                         setState(() {
//                           _selectedqualitiesIds =
//                               List<int>.from(result['id'] ?? []);
//                           _selectedqualitiesNames =
//                               List<String>.from(result['name'] ?? []);
//                         });
//                       }
//                       print('qualities: $_selectedqualitiesIds');
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 14),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         _selectedqualitiesIds.isEmpty
//                             ? "Tap to select qualities for"
//                             : _selectedqualitiesNames.join(', '),
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ),
//                   ),
//                   if (_selectedqualitiesIds.length < 4)
//                     const Padding(
//                       padding: EdgeInsets.only(top: 6),
//                       child: Text(
//                         "",
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 135, 116, 115),
//                           fontSize: 2,
//                         ),
//                       ),
//                     ),

//                   SizedBox(
//                     height: 10,
//                   ),

//                   const Text('Select DefaultMessages',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),

//                   const SizedBox(height: 8),

//                   GestureDetector(
//                     onTap: () async {
//                       final result = await showModalBottomSheet<
//                               Map<String, dynamic>>(
//                           context: context,
//                           isScrollControlled: true,
//                           backgroundColor: Colors
//                               .transparent, // Important for rounded corner card
//                           builder: (context) {
//                             return Center(
//                               child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20.0, vertical: 40),
//                                   child: Material(
//                                     borderRadius: BorderRadius.circular(25),
//                                     color: const Color(
//                                         0xFFF3EDF7), // Background like the image
//                                     child: SizedBox(
//                                       height:
//                                           MediaQuery.of(context).size.height *
//                                               0.85,
//                                       width: MediaQuery.of(context).size.width *
//                                           0.85,
//                                       child: DefaultMessage(
//                                         initiallySelectedIds:
//                                             _selectedmesagesIds,
//                                         allMesages: defaultList,
//                                         initiallySelectedNames:
//                                             _selectedmesagesNames,
//                                       ),
//                                     ),
//                                   )),
//                             );
//                           });
//                       if (result != null) {
//                         setState(() {
//                           _selectedmesagesIds =
//                               List<int>.from(result['id'] ?? []);
//                           _selectedmesagesNames =
//                               List<String>.from(result['mesages']);
//                         });
//                       }
//                       print('selcetedmesages $_selectedmesagesNames');

//                       // if (result != null) {
//                       //   setState(() {
//                       //     _result = result;
//                       //     _selectedcauseNames = causessList
//                       //         .where((e) => result.contains(e.id))
//                       //         .map((e) => e.causesAndCommunities ?? '')
//                       //         .toList();
//                       //   });
//                       // }
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 14),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         _selectedmesagesIds.isEmpty
//                             ? "Tap to select mesages"
//                             : _selectedmesagesNames.join(', '),
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ),
//                   ),
//                   if (_selectedmesagesIds.length < 4)
//                     Padding(
//                       padding: EdgeInsets.only(top: 6),
//                       child: Text(
//                         "",
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 135, 116, 115),
//                           fontSize: 2,
//                         ),
//                       ),
//                     ),

//                   const SizedBox(height: 10),
//                   const Text('select Kids',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 5),
//                   DropdownButtonFormField<String>(
//                     value: _selectedKids,
//                     isExpanded: true,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 14),

//                       // Add "Clear" as suffix inside the field
//                       suffixIcon: (_selectedKids != null)
//                           ? GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _selectedKids = null;
//                                 });
//                               },
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 8.0),
//                                 child: Text(
//                                   'Clear',
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : null,
//                     ),
//                     items: kidsData.data?.map((dataItem) {
//                       return DropdownMenuItem<String>(
//                         value: dataItem.kids,
//                         child: Text(dataItem.kids ?? ''),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedKids = value;
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 10),
//                   const Text('Do you Drink',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 5),
//                   DropdownButtonFormField<String>(
//                     value: _selectedDrinking,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       suffixIcon: (_selectedDrinking != null)
//                           ? GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _selectedDrinking = null;
//                                 });
//                               },
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 8.0),
//                                 child: Text(
//                                   'Clear',
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : null,
//                     ),
//                     items: drinkingData.data?.map((dataItem) {
//                       return DropdownMenuItem<String>(
//                         value: dataItem.preference,
//                         child: Text(dataItem.preference ?? ''),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() => _selectedDrinking = value);
//                     },
//                   ),

//                   const SizedBox(height: 10),
//                   const Text('select Religion',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 5),
//                   DropdownButtonFormField<String>(
//                     value: _selectedReligion,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       suffixIcon: (_selectedReligion != null)
//                           ? GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _selectedReligion = null;
//                                 });
//                               },
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 8.0),
//                                 child: Text(
//                                   'Clear',
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : null,
//                     ),
//                     items: religionData.data?.map((dataItem) {
//                       return DropdownMenuItem<String>(
//                         value: dataItem.religion,
//                         child: Text(dataItem.religion ?? ''),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() => _selectedReligion = value);
//                     },
//                   ),

//                   const SizedBox(height: 10),
//                   const SizedBox(height: 10),
//                   Text("Location",
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 6),
//                   GooglePlaceAutoCompleteTextField(
//                     textEditingController: _locationController,
//                     googleAPIKey:
//                         "AIzaSyB_7QtF9EUbVs_5mVFxZWS-NdzYwV9dbU0", // replace with your key
//                     inputDecoration: InputDecoration(
//                       hintText: "Search location",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8)),
//                       prefixIcon: const Icon(Icons.location_on),
//                     ),
//                     debounceTime: 800,
//                     countries: const ["in"], // restrict to India
//                     isLatLngRequired: true,
//                     getPlaceDetailWithLatLng: (prediction) {
//                       setState(() {
//                         selectedLat = double.tryParse(prediction.lat ?? "0");
//                         selectedLng = double.tryParse(prediction.lng ?? "0");
//                       });

//                       _onLocationSelected(
//                         _locationController.text,
//                         selectedLat ?? 0,
//                         selectedLng ?? 0,
//                       );
//                     },
//                     itemClick: (prediction) {
//                       _locationController.text = prediction.description ?? "";
//                       _locationController.selection =
//                           TextSelection.fromPosition(
//                         TextPosition(offset: _locationController.text.length),
//                       );
//                     },
//                     seperatedBuilder: const Divider(),
//                   ),

//                   // Age Dropdown
//                   // const Text('Age',
//                   //     style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   // const SizedBox(height: 5),
//                   // DropdownButtonFormField<String>(
//                   //   value: _selectedAge,
//                   //   decoration: InputDecoration(
//                   //     border: OutlineInputBorder(
//                   //       borderRadius: BorderRadius.circular(8),
//                   //       borderSide: const BorderSide(color: Colors.grey),
//                   //     ),
//                   //     contentPadding: const EdgeInsets.symmetric(
//                   //         horizontal: 12, vertical: 8),
//                   //   ),
//                   //   items: const [
//                   //     DropdownMenuItem(value: '18-25', child: Text('18-25')),
//                   //     DropdownMenuItem(value: '26-35', child: Text('26-35')),
//                   //     DropdownMenuItem(value: '36-45', child: Text('36-45')),
//                   //   ],
//                   //   onChanged: (value) => setState(() => _selectedAge = value),
//                   // ),
//                   // const SizedBox(height: 15),

//                   // // Interest Dropdown
//                   // const Text('Interest',
//                   //     style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   // const SizedBox(height: 5),
//                   // DropdownButtonFormField<String>(
//                   //   value: _selectedInterest,
//                   //   decoration: InputDecoration(
//                   //     border: OutlineInputBorder(
//                   //       borderRadius: BorderRadius.circular(8),
//                   //       borderSide: const BorderSide(color: Colors.grey),
//                   //     ),
//                   //     contentPadding: const EdgeInsets.symmetric(
//                   //         horizontal: 12, vertical: 8),
//                   //   ),
//                   //   items: const [
//                   //     DropdownMenuItem(value: 'Sports', child: Text('Sports')),
//                   //     DropdownMenuItem(value: 'Music', child: Text('Music')),
//                   //     DropdownMenuItem(
//                   //         value: 'Reading', child: Text('Reading')),
//                   //   ],
//                   //   onChanged: (value) =>
//                   //       setState(() => _selectedInterest = value),
//                   // ),
//                   // const SizedBox(height: 15),

//                   // // Looking For Dropdown
//                   // const Text('Looking For',
//                   //     style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   // const SizedBox(height: 5),
//                   // DropdownButtonFormField<String>(
//                   //   value: _selectedLookingFor,
//                   //   decoration: InputDecoration(
//                   //     border: OutlineInputBorder(
//                   //       borderRadius: BorderRadius.circular(8),
//                   //       borderSide: const BorderSide(color: Colors.grey),
//                   //     ),
//                   //     contentPadding: const EdgeInsets.symmetric(
//                   //         horizontal: 12, vertical: 8),
//                   //   ),
//                   //   items: const [
//                   //     DropdownMenuItem(
//                   //         value: 'Friendship', child: Text('Friendship')),
//                   //     DropdownMenuItem(
//                   //         value: 'Relationship', child: Text('Relationship')),
//                   //     DropdownMenuItem(
//                   //         value: 'Networking', child: Text('Networking')),
//                   //   ],
//                   //   onChanged: (value) =>
//                   //       setState(() => _selectedLookingFor = value),
//                   // ),
//                   // const SizedBox(height: 15),

//                   // Write Few Words About You (Bio)
//                   const Text("Prompts", style: TextStyle(fontSize: 16)),
//                   const SizedBox(height: 10),

//                   // Show existing prompts
//                   for (int i = 0; i < prompts.length; i++)
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             prompts[i],
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () {
//                             setState(() {
//                               promptController.text = prompts[i];
//                               isEditingPrompt = true;
//                               editingIndex = i;
//                             });
//                           },
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete, color: Colors.red),
//                           onPressed: () {
//                             setState(() {
//                               prompts.removeAt(i);
//                               if (editingIndex == i) {
//                                 isEditingPrompt = false;
//                                 editingIndex = null;
//                                 promptController.clear();
//                               } else if (editingIndex != null &&
//                                   i < editingIndex!) {
//                                 editingIndex = editingIndex! - 1;
//                               }
//                             });
//                           },
//                         ),
//                       ],
//                     ),

//                   // const SizedBox(height: 10),

//                   // Add button if less than 2 prompts and not editing
//                   if (prompts.length < 2 && !isEditingPrompt)
//                     TextButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           isEditingPrompt = true;
//                           editingIndex = null;
//                           promptController.clear();
//                         });
//                       },
//                       icon: const Icon(Icons.add),
//                       label: const Text("Add Prompt"),
//                     ),

//                   // Input field and Save button
//                   if (isEditingPrompt)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextField(
//                           controller: promptController,
//                           decoration:
//                               const InputDecoration(labelText: "Enter prompts"),
//                         ),
//                         // const SizedBox(height: 8),
//                         ElevatedButton(
//                           onPressed: () {
//                             final text = promptController.text.trim();
//                             if (text.isEmpty) return;

//                             setState(() {
//                               if (editingIndex != null) {
//                                 prompts[editingIndex!] = text;
//                               } else {
//                                 prompts.add(text);
//                               }
//                               isEditingPrompt = false;
//                               editingIndex = null;
//                               promptController.clear();
//                             });
//                           },
//                           child: const Text("Save"),
//                         ),
//                       ],
//                     ),
//                   const SizedBox(height: 5),
//                   const Text('Write Few Words About You (Bio)',
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   const SizedBox(height: 5),
//                   TextField(
//                     controller: _bioController,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                       hintText: 'Tell us about yourself...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Save Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xffB2D12E), Color(0xFF2B2B2B)],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           // _showSuccessDialog();

//                           if (_selectedKids != null) {
//                             final matchingItems = kidsData.data?.where(
//                               (item) => item.kids == _selectedKids,
//                             );
//                             if (matchingItems != null &&
//                                 matchingItems.isNotEmpty) {
//                               final selectedItem = matchingItems.first;
//                               if (selectedItem.id != null) {
//                                 _selectedkidsIds = [selectedItem.id!];
//                               }
//                             }
//                           }

//                           if (_selectedDrinking != null) {
//                             final matchingItems = drinkingData.data?.where(
//                               (item) => item.preference == _selectedDrinking,
//                             );
//                             if (matchingItems != null &&
//                                 matchingItems.isNotEmpty) {
//                               final selectedItem = matchingItems.first;
//                               if (selectedItem.id != null) {
//                                 _selecteddrinkingIds = [selectedItem.id!];
//                               }
//                             }
//                           }

//                           if (_selectedMode != null) {
//                             final matchingItems = modeData.data?.where(
//                               (item) => item.value == _selectedMode,
//                             );
//                             if (matchingItems != null &&
//                                 matchingItems.isNotEmpty) {
//                               final selectedItem = matchingItems.first;
//                               if (selectedItem.id != null) {
//                                 _selectedmodeId = [selectedItem.id!];
//                               }
//                             }
//                           }

//                           if (_selectedReligion != null) {
//                             final matchingItems = religionData.data?.where(
//                               (item) => item.religion == _selectedReligion,
//                             );
//                             if (matchingItems != null &&
//                                 matchingItems.isNotEmpty) {
//                               final selectedItem = matchingItems.first;
//                               if (selectedItem.id != null) {
//                                 _selectedreligionIds = [selectedItem.id!];
//                               }
//                             }
//                           }

//                           if (_selectedTheirGender != null) {
//                             final matchingItems = genderData.data?.where(
//                               (item) => item.value == _selectedTheirGender,
//                             );
//                             if (matchingItems != null &&
//                                 matchingItems.isNotEmpty) {
//                               final selectedItem = matchingItems.first;
//                               if (selectedItem.id != null) {
//                                 _selectedgenderIds = [selectedItem.id!];
//                               }
//                             }
//                           }
//                           print('seleted data$_selectedgenderIds');

//                           try {
//                             await ref
//                                 .read(loginProvider.notifier)
//                                 .signupuserApi(

//                                     // :_lastNameController ,
//                                     email: _emailController.text,
//                                     mobile: _phoneController.text,
//                                     userName: _firstNameController.text,
//                                     dateOfBirth: _selectedBirth,
//                                     selectedGender: _selectedGender,
//                                     showGenderOnProfile: _showProfile,
//                                     modeid: _selectedmodeId,
//                                     drinkingId: _selecteddrinkingIds,
//                                     selectedkidsIds: _selectedkidsIds,
//                                     selectedreligionIds: _selectedreligionIds,
//                                     selectedGenderIds: _selectedgenderIds,
//                                     selectedInterestIds: _selectedInterestIds,
//                                     selectedcauses: _selectedcauseIds,
//                                     selectedLookingfor: _selectedLookingIds,
//                                     selectedqualities: _selectedqualitiesIds,
//                                     finalheadline: _bioController.text,
//                                     seletedprompts: prompts,
//                                     choosedimages: _selectedImages,
//                                     selectedHeight:
//                                         int.tryParse(_heightController.text),
//                                     defaultmessages: _selectedmesagesIds);

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text(
//                                       'upload profile data successfully!')),
//                             );
//                           } catch (e) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                   content: Text(
//                                       'Failed to upload profile data: $e')),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text(
//                           'Save',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Profile Image - Positioned to overlap
//           //      Positioned(
//           //   top: 0,
//           //   left: 0,
//           //   right: 0,
//           //   child: Center(
//           //     child: Column(
//           //       children: [
//           //         Wrap(
//           //           spacing: 10,
//           //           runSpacing: 10,
//           //           children: List.generate(6, (index) {
//           //             return GestureDetector(
//           //               onTap: _pickImages,
//           //               child: Container(
//           //                 width: 90,
//           //                 height: 90,
//           //                 decoration: BoxDecoration(
//           //                   color: Colors.grey[200],
//           //                   border: Border.all(color: Colors.grey),
//           //                   image: _selectedImages[index] != null
//           //                       ? DecorationImage(
//           //                           image: FileImage(_selectedImages[index]!),
//           //                           fit: BoxFit.cover,
//           //                         )
//           //                       : null,
//           //                 ),
//           //                 child: _selectedImages[index] == null
//           //                     ? const Icon(Icons.add_a_photo, color: Colors.grey)
//           //                     : null,
//           //               ),
//           //             );
//           //           }),
//           //         ),

//           //         const SizedBox(height: 16),

//           //         ElevatedButton(
//           //           onPressed: () {
//           //             final selected = _selectedImages!.whereType<File>().toList();
//           //             if (selected.length < 4) {
//           //               ScaffoldMessenger.of(context).showSnackBar(
//           //                 const SnackBar(content: Text("Select at least 4 images")),
//           //               );
//           //             } else {
//           //               // Store or send these images
//           //               print("Selected ${selected.length} images");
//           //             }
//           //           },
//           //           child: const Text("Continue"),
//           //         )
//           //       ],
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _usernameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
// }
