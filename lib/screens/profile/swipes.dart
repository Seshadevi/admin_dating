// lib/screens/profile/verification_screen.dart
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

class _VerificationScreenState extends ConsumerState<VerificationScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Fetch on first load
    Future.microtask(
      () => ref.read(verificationIdProvider.notifier).verificationid(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper method to extract all verifications from the nested structure
  List<Verifications> _extractVerifications(List<VerificationId> verificationIds) {
    List<Verifications> allVerifications = [];
    for (var verificationId in verificationIds) {
      if (verificationId.data != null) {
        for (var data in verificationId.data!) {
          if (data.verifications != null) {
            allVerifications.addAll(data.verifications!);
          }
        }
      }
    }
    return allVerifications;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final verificationList = ref.watch(verificationIdProvider);
    
    // Extract all verifications from the nested structure
    final allVerifications = _extractVerifications(verificationList);

    // Filter by status (case-insensitive)
    String _normalizeStatus(String? status) => (status ?? '').trim().toLowerCase();
    
    final processing = allVerifications.where((v) => _normalizeStatus(v.status) == 'processing').toList();
    final verified = allVerifications.where((v) => _normalizeStatus(v.status) == 'verified').toList();
    final rejected = allVerifications.where((v) => _normalizeStatus(v.status) == 'rejected').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    'ID Verifications',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      tooltip: 'Refresh',
                      onPressed: () => ref.read(verificationIdProvider.notifier).verificationid(),
                      icon: const Icon(Icons.refresh_rounded, color: Color(0xFF4A5568)),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(4),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF64748B),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  tabs: [
                    _buildTab('Processing', Icons.hourglass_top_rounded, processing.length, Colors.orange),
                    _buildTab('Verified', Icons.verified_rounded, verified.length, Colors.green),
                    _buildTab('Rejected', Icons.close_rounded, rejected.length, Colors.red),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading verifications...',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.read(verificationIdProvider.notifier).verificationid(),
                      color: const Color(0xFF667EEA),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _VerificationListView(verifications: processing),
                          _VerificationListView(verifications: verified),
                          _VerificationListView(verifications: rejected),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, IconData icon, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerificationListView extends StatelessWidget {
  final List<Verifications> verifications;
  const _VerificationListView({required this.verifications});

  @override
  Widget build(BuildContext context) {
    if (verifications.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(40),
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'No verifications found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Pull to refresh or check back later',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: verifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final verification = verifications[index];
        return _VerificationCard(verification: verification);
      },
    );
  }
}

class _VerificationCard extends StatelessWidget {
  final Verifications verification;
  const _VerificationCard({required this.verification});

  @override
  Widget build(BuildContext context) {
    // Get display image
    final displayImage = verification.images?.image1 ??
        verification.images?.image2 ??
        verification.images?.image3 ??
        ((verification.userImages?.isNotEmpty ?? false) ? verification.userImages!.first : null);

    // Get display name
    final displayName = (verification.firstName?.trim().isNotEmpty ?? false)
        ? verification.firstName!.trim()
        : 'User ${verification.userId ?? ''}';

    // Status styling
    final status = (verification.status ?? '').trim();
    final statusData = _getStatusData(status);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VerificationDetailScreen(verification: verification),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (displayImage == null || displayImage.isEmpty)
                      ? Icon(
                          Icons.person_outline_rounded,
                          size: 32,
                          color: Colors.grey.shade400,
                        )
                      : Image.network(
                          displayImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.broken_image_outlined,
                            size: 32,
                            color: Colors.grey.shade400,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'DOB: ${verification.dob?.isNotEmpty == true ? verification.dob : '—'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ID: ${verification.userId ?? '—'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusData.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statusData.color.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusData.icon,
                      size: 14,
                      color: statusData.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status.isEmpty ? 'Pending' : status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusData.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ({Color color, IconData icon}) _getStatusData(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return (color: Colors.green, icon: Icons.verified_rounded);
      case 'rejected':
        return (color: Colors.red, icon: Icons.close_rounded);
      case 'processing':
        return (color: Colors.orange, icon: Icons.hourglass_top_rounded);
      default:
        return (color: Colors.grey, icon: Icons.schedule_rounded);
    }
  }
}














// import 'package:admin_dating/models/users/id_verification_model.dart';
// import 'package:admin_dating/provider/loader.dart';
// import 'package:admin_dating/provider/users/id_verification_provider.dart';
// import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
// import 'package:admin_dating/screens/profile/verification_detail_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';


// class VerificationScreen extends ConsumerStatefulWidget {
//   const VerificationScreen({super.key});

//   @override
//   ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
// }

// class _VerificationScreenState extends ConsumerState<VerificationScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch on first load
//     Future.microtask(() => ref.read(verificationIdProvider.notifier).verificationid());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLoading = ref.watch(loadingProvider);
//     final users = ref.watch(verificationIdProvider); // List<VerificationId>

//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildTopHeader(context),
//             if (isLoading)
//               const Expanded(child: Center(child: CircularProgressIndicator()))
//             else
//               Expanded(
//                 child: RefreshIndicator(
//                   onRefresh: () => ref.read(verificationIdProvider.notifier).verificationid(),
//                   child: users.isEmpty
//                       ? ListView( // so refresh works even when empty
//                           children: const [
//                             SizedBox(height: 120),
//                             Center(child: Text('No verification requests')),
//                           ],
//                         )
//                       : ListView.separated(
//                           itemCount: users.length,
//                           separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
//                           itemBuilder: (context, index) => _VerificationTile(item: users[index]),
//                         ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTopHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
//       ),
//       child: Row(
//         children: [
//           const Text('ID Verifications',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const Spacer(),
//           IconButton(
//             tooltip: 'Refresh',
//             onPressed: () => ref.read(verificationIdProvider.notifier).verificationid(),
//             icon: const Icon(Icons.refresh),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _VerificationTile extends ConsumerWidget {
//   final VerificationId item;
//   const _VerificationTile({required this.item});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final img = item.userImages;
//     final initials = (item.firstName?.isNotEmpty ?? false)
//         ? item.firstName!.trim()[0].toUpperCase()
//         : '?';

//     return ListTile(
//       leading: CircleAvatar(
//         radius: 22,
//         backgroundColor: Colors.grey.shade300,
//         backgroundImage: (img != null && img.isNotEmpty) ? NetworkImage(img.first) : null,
//         child: (img == null || img.isEmpty)
//             ? Text(initials, style: const TextStyle(fontWeight: FontWeight.bold))
//             : null,
//       ),
//       title: Row(
//         children: [
//           Expanded(
//             child: Text(
//               item.firstName ?? 'Unknown',
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ),
//           if (item.verified == true)
//             const Padding(
//               padding: EdgeInsets.only(left: 6),
//               child: Icon(Icons.verified, color: Colors.blue, size: 18),
//             ),
//         ],
//       ),
//       subtitle: Text('DOB: ${item.dob ?? '-'}'),
//       trailing: const Icon(Icons.chevron_right),
//       onTap: () {
//         // Navigate to your detail screen (uncomment when available)
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (_) => VerificationDetailScreen(item: item),
//           ),
//         );
//       },
//     );
//   }
// }























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
