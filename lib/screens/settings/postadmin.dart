import 'package:flutter/material.dart';

class PostAdminScreen extends StatefulWidget {
  const PostAdminScreen({super.key});

  @override
  State<PostAdminScreen> createState() => _PostAdminScreenState();
}

class _PostAdminScreenState extends State<PostAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white ,

      // ✅ AppBar with back button
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 238, 240),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Admin Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      // ✅ Body with proper padding and scroll
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // const Text(
            //   "Posted Admin Data For Signin",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),
            // const SizedBox(height: 20),
            buildTile("Mode",onTap: () {}),
            buildTile("Looking For",onTap: () {}),
            buildTile("Qualities",onTap: () {}),
            buildTile("Interests",onTap: () {}),
            buildTile("CausesAndCommunities",onTap: () {}),
            buildTile("Religion",onTap: () {}),
            buildTile("Kids",onTap: () {}),
            buildTile("Drinking",onTap: () {}),
            buildTile("DefaultMessages",onTap: () {}),
            buildTile("Gender",onTap: () {}),
            buildTile("TermsAndConditions",onTap: () {}),
            buildTile("ChooseFoodies",onTap: () {}),
            buildTile("StarSign",onTap: () {}),
            buildTile("Laguages",onTap: () {}),
            buildTile("Pronouns",onTap: () {}),
            buildTile("Edit",onTap: () {}),
            buildTile("Edit",onTap: () {}),
            buildTile("Edit",onTap: () {}),
            buildTile("Edit",onTap: () {}),
            buildTile("Edit",onTap: () {}),


            
          ],
        ),
      ),
    );
  }

  // ✅ Tile builder method
  Widget buildTile(String title,
      {IconData icon = Icons.arrow_forward_ios, VoidCallback? onTap}) {
    return ListTile(
      title: Text(title),
      trailing: Icon(icon, size: 25, color: Colors.black),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
