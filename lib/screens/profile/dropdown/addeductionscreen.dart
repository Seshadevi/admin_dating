
// import 'package:admin_dating/models/signupprocessmodels/defaultMessagesModel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class WorkSection extends StatefulWidget {
//   const WorkSection({super.key});

//   @override
//   State<WorkSection> createState() => _WorkSectionState();
// }

// class _WorkSectionState extends State<WorkSection> {
//   final TextEditingController workController = TextEditingController();
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController companyController = TextEditingController();

//   bool showForm = false;
//   String? workSummary; // e.g. "developer at infosys"

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Work',
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         const SizedBox(height: 5),
//         TextField(
//           controller: workController,
//           readOnly: true,
//           decoration: InputDecoration(
//             hintText: workSummary ?? "Enter your work",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Colors.grey),
//             // ),
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           ),
//           onTap: () {
//             setState(() {
//               showForm = !showForm; // toggle show/hide
//             });
//           },
//         ),
//         const SizedBox(height: 10),

//         // Form for title & company
//         if (showForm) ...[
//           TextField(
//             controller: titleController,
//             decoration: const InputDecoration(
//               hintText: "Enter your title (e.g., Developer)",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 8),
//           TextField(
//             controller: companyController,
//             decoration: const InputDecoration(
//               hintText: "Enter company name (e.g., Infosys)",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 workSummary =
//                     "${titleController.text} at ${companyController.text}";
//                 workController.text = workSummary!;
//                 showForm = false; // close form after saving
//               });

//               // Later: send to API
//               final workData = {
//                 "title": titleController.text,
//                 "company": companyController.text,
//                 "user_id": 161, // example
//               };

//               print("Work data to send API: $workData");
//             },
//             child: Text(workSummary == null ? "Add" : "Update"),
//           ),
//         ],
//       ],
//     );
//   }
// }
