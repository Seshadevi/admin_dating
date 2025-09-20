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
      backgroundColor: Colors.white,

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
            buildTile("Mode", onTap: () {
              Navigator.pushNamed(context, '/modesget');
            }),
            buildTile("Looking For", onTap: () {
              Navigator.pushNamed(context, '/lookingforgetscreen');
            }),
            buildTile("Qualities", onTap: () {
              Navigator.pushNamed(context, '/qualitiesget');
            }),
            // buildTile("Interests", onTap: () {
            //   Navigator.pushNamed(context, '/interestget');
            // }),
            buildTile("CausesAndCommunities", onTap: () {
              Navigator.pushNamed(context, '/causesget');
            }),
            buildTile("Religion", onTap: () {
              Navigator.pushNamed(context, '/religionget');
            }),
            buildTile("Kids", onTap: () {
              Navigator.pushNamed(context, '/kidsget');
            }),
            buildTile("Drinking", onTap: () {
              Navigator.pushNamed(context, '/drinkingget');
            }),
            buildTile("DefaultMessages", onTap: () {
              Navigator.pushNamed(context, '/defaultmessagesget');
            }),
            buildTile("Gender", onTap: () {
              Navigator.pushNamed(context, '/genderget');
            }),
            buildTile("TermsAndConditions", onTap: () {
              Navigator.pushNamed(context, '/termsget');
            }),
            buildTile("ChooseFoodies", onTap: () {
              Navigator.pushNamed(context, '/interestget');
            }),
            buildTile("StarSign", onTap: () {
              Navigator.pushNamed(context, '/starsignget');
            }),
            buildTile("Languages", onTap: () {
              Navigator.pushNamed(context, '/languagesget');
            }),
            buildTile("Experience", onTap: () {
              Navigator.pushNamed(context, '/experienceget');
            }),
            buildTile("relationship", onTap: () {
              Navigator.pushNamed(context, '/relationshipget');
            }),
            buildTile("Industry", onTap: () {
              Navigator.pushNamed(context, '/industryget');
            }),
            // buildTile("", onTap: () {}),
            // buildTile("", onTap: () {}),
            // buildTile("", onTap: () {}),
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
