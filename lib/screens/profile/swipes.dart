import 'package:admin_dating/models/users/id_verification_model.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/users/id_verification_provider.dart';
import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'package:admin_dating/screens/profile/verification_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch on first load
    Future.microtask(() => ref.read(verificationIdProvider.notifier).verificationid());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final users = ref.watch(verificationIdProvider); // List<VerificationId>

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(context),
            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref.read(verificationIdProvider.notifier).verificationid(),
                  child: users.isEmpty
                      ? ListView( // so refresh works even when empty
                          children: const [
                            SizedBox(height: 120),
                            Center(child: Text('No verification requests')),
                          ],
                        )
                      : ListView.separated(
                          itemCount: users.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
                          itemBuilder: (context, index) => _VerificationTile(item: users[index]),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          const Text('ID Verifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => ref.read(verificationIdProvider.notifier).verificationid(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class _VerificationTile extends ConsumerWidget {
  final VerificationId item;
  const _VerificationTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final img = item.userImages;
    final initials = (item.firstName?.isNotEmpty ?? false)
        ? item.firstName!.trim()[0].toUpperCase()
        : '?';

    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.grey.shade300,
        backgroundImage: (img != null && img.isNotEmpty) ? NetworkImage(img.first) : null,
        child: (img == null || img.isEmpty)
            ? Text(initials, style: const TextStyle(fontWeight: FontWeight.bold))
            : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.firstName ?? 'Unknown',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          if (item.verified == true)
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.verified, color: Colors.blue, size: 18),
            ),
        ],
      ),
      subtitle: Text('DOB: ${item.dob ?? '-'}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigate to your detail screen (uncomment when available)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VerificationDetailScreen(item: item),
          ),
        );
      },
    );
  }
}























// class VerificationScreen extends ConsumerStatefulWidget {
//   const VerificationScreen({super.key});

//   @override
//   ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
// }

// class _VerificationScreenState extends ConsumerState<VerificationScreen> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildTopHeader(),
//             verification_users(),
            
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTopHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       color: const Color(0xFFB5C983),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text('verification', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//           const SizedBox(),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       color: const Color(0xFFB5C983),
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: "Search by ID...",
//                 contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           _filterBox("All"),
//           const SizedBox(width: 6),
//           _filterBox("Both: Y"),
//           const SizedBox(width: 6),
//           const Icon(Icons.add_circle, color: Colors.white),
//         ],
//       ),
//     );
//   }

//   Widget _filterBox(String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(label, style: const TextStyle(color: Colors.black)),
//     );
//   }

//   Widget _buildList() {
//     return ListView.builder(
//       itemCount: 6,
//       itemBuilder: (context, index) {
//         return _buildSwipeCard();
//       },
//     );
//   }

//   Widget _buildSwipeCard() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.green.shade200),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const CircleAvatar(
//             radius: 22,
//             backgroundImage: AssetImage('assets/user.png'), // Replace with actual image
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("User Id: Bk-Wz1006", style: TextStyle(fontWeight: FontWeight.bold)),
//                 const Text("Brerna (Author)", style: TextStyle(color: Colors.orange)),
//                 const Text("Seen", style: TextStyle(fontWeight: FontWeight.w600)),
//                 Row(
//                   children: const [
//                     CircleAvatar(radius: 10, backgroundImage: AssetImage('assets/user.png')),
//                     SizedBox(width: 6),
//                     Text("Daniel", style: TextStyle(color: Colors.pink)),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Color(0xFFD6E3B6),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: const Text("Type: Like", style: TextStyle(fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 8),
//           Column(
//             children: const [
//               Icon(Icons.list_alt, color: Colors.blue),
//               SizedBox(height: 8),
//               Icon(Icons.edit, color: Colors.green),
//               SizedBox(height: 8),
//               Icon(Icons.cancel, color: Colors.red),
//             ],
//           ),
//           const SizedBox(width: 8),
//           Column(
//             children: const [
//               Text("15 Feb", style: TextStyle(color: Colors.black54)),
//               Text("11: Am", style: TextStyle(color: Colors.black54)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPagination() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _paginationBox("1", isSelected: true),
//           _paginationBox("2"),
//           _paginationBox("3"),
//           const Text("..."),
//           _paginationBox("99"),
//           const Icon(Icons.arrow_forward_ios, size: 16),
//         ],
//       ),
//     );
//   }

//   Widget _paginationBox(String number, {bool isSelected = false}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: isSelected ? const Color(0xFFB5C983) : Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(number, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
//     );
//   }
// }
