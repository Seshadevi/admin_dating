import 'package:admin_dating/screens/profile/personal_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Controllers for text fields
  final TextEditingController _firstNameController =
      TextEditingController(text: 'Sabrina');
  final TextEditingController _lastNameController =
      TextEditingController(text: 'Aryan');
  final TextEditingController _usernameController =
      TextEditingController(text: '@Sabrina');
  final TextEditingController _emailController =
      TextEditingController(text: '@SabrinaAryan20@gmailcom');
  final TextEditingController _phoneController =
      TextEditingController(text: '+234 ▼ 904 6470');

  // Dropdown values
  String? _selectedBirth;
  String? _selectedGender;
  String? _selectedBH;
  String? _selectedProfession;
  String? _selectedAge;
  String? _selectedInterest;
  String? _selectedLookingFor;
  String? _selectedWriteFewWords;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _showAccessDialog() {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter Mail Id',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _showSuccessDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Successful',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffB2D12E),
      appBar: AppBar(
        backgroundColor: const Color(0xffB2D12E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String result) {
              if (result == 'give_access') {
                _showAccessDialog();
              } else if (result == 'successful') {
                _showSuccessDialog();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'give_access',
                child: Text('Give Access'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // White container with form
          Container(
            margin: const EdgeInsets.only(top: 120),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  top: 150, left: 20, right: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Add Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // First Name
                  const Text('First Name',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Last Name
                  const Text('Last Name',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Username
                  const Text('Username',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Email
                  const Text('Email',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Phone Number
                  const Text('Phone Number',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Birth Dropdown
                  const Text('Birth',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: _selectedBirth,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: '1990', child: Text('1990')),
                      DropdownMenuItem(value: '1991', child: Text('1991')),
                      DropdownMenuItem(value: '1992', child: Text('1992')),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedBirth = value),
                  ),
                  const SizedBox(height: 15),

                  // Gender Dropdown
                  const Text('Gender',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedGender = value),
                  ),
                  const SizedBox(height: 15),

                  // BH Dropdown
                  const Text('BH',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: _selectedBH,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Option 1', child: Text('Option 1')),
                      DropdownMenuItem(
                          value: 'Option 2', child: Text('Option 2')),
                    ],
                    onChanged: (value) => setState(() => _selectedBH = value),
                  ),
                  const SizedBox(height: 15),

                  // Profession Dropdown
                  const Text('Profession',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: _selectedProfession,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Engineer', child: Text('Engineer')),
                      DropdownMenuItem(value: 'Doctor', child: Text('Doctor')),
                      DropdownMenuItem(
                          value: 'Teacher', child: Text('Teacher')),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedProfession = value),
                  ),
                  const SizedBox(height: 15),

                  // Age Dropdown
                  const Text('Age',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: _selectedAge,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: '18-25', child: Text('18-25')),
                      DropdownMenuItem(value: '26-35', child: Text('26-35')),
                      DropdownMenuItem(value: '36-45', child: Text('36-45')),
                    ],
                    onChanged: (value) => setState(() => _selectedAge = value),
                  ),
                  const SizedBox(height: 15),

                  // Interest Dropdown
                  const Text('Interest',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: _selectedInterest,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Sports', child: Text('Sports')),
                      DropdownMenuItem(value: 'Music', child: Text('Music')),
                      DropdownMenuItem(
                          value: 'Reading', child: Text('Reading')),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedInterest = value),
                  ),
                  const SizedBox(height: 15),

                  // Looking For Dropdown
                  const Text('Looking For',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: _selectedLookingFor,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Friendship', child: Text('Friendship')),
                      DropdownMenuItem(
                          value: 'Relationship', child: Text('Relationship')),
                      DropdownMenuItem(
                          value: 'Networking', child: Text('Networking')),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedLookingFor = value),
                  ),
                  const SizedBox(height: 15),

                  // Write Few Words Dropdown
                  const Text('Write Few Words About You(Bio)',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: _selectedWriteFewWords,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Creative', child: Text('Creative')),
                      DropdownMenuItem(
                          value: 'Adventurous', child: Text('Adventurous')),
                      DropdownMenuItem(
                          value: 'Friendly', child: Text('Friendly')),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedWriteFewWords = value),
                  ),
                  const SizedBox(height: 30),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffB2D12E), Color(0xFF2B2B2B)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PersonalProfilePage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile Image - Positioned to overlap
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(Icons.person, size: 70, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
