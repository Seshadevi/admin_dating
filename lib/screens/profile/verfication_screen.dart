import 'package:admin_dating/constants/dating_colors.dart';
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

class _VerificationScreenState extends ConsumerState<VerificationScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() => ref.read(verificationIdProvider.notifier).verificationid());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  String _normalizeStatus(String? status) => (status ?? '').trim().toLowerCase();

  // Tab widget showing icon above text and count badge below
  Widget _buildTab(String label, IconData icon, int count, Color color) {
    return Tab(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 2), // <-- reduced from 4
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 10, // <-- smaller font
            ),
          ),
          // const SizedBox(height: 1), // <-- reduced from 2
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), // <-- less vertical padding
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 6, // <-- smaller font
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final List<VerificationId> verificationIds = ref.watch(verificationIdProvider);
    final allVerifications = _extractVerifications(verificationIds);

    final processing = allVerifications.where((v) => _normalizeStatus(v.status) == 'processing').toList();
    final verified = allVerifications.where((v) => _normalizeStatus(v.status) == 'verified').toList();
    final rejected = allVerifications.where((v) => _normalizeStatus(v.status) == 'rejected').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 2), blurRadius: 8)],
              ),
              child: Row(
                children: [
                  const Text('ID Verifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(12)),
                    child: IconButton(
                      tooltip: 'Refresh',
                      onPressed: () => ref.read(verificationIdProvider.notifier).verificationid(),
                      icon: const Icon(Icons.refresh_rounded, color: Color(0xFF4A5568)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 80,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), offset: const Offset(0, 4), blurRadius: 12)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color.fromARGB(255, 231, 233, 224),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(6),
                  tabs: [
                    _buildTab('Processing', Icons.hourglass_top_rounded, processing.length, Colors.orange),
                    _buildTab('Verified', Icons.verified_rounded, verified.length, Colors.black),
                    _buildTab('Rejected', Icons.close_rounded, rejected.length, Colors.red),
                  ],
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF647B8B),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA))),
                    SizedBox(height: 16),
                    Text('Loading verifications...', style: TextStyle(color: Color(0xFF647B8B), fontSize: 16)),
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
          const SizedBox(height: 120),
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Center(
            child: Text('No verification requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF647B8B))),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text('Pull to refresh or check again later', style: TextStyle(fontSize: 14, color: Color(0xFF94A6B8))),
          ),
        ],
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: verifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => _VerificationCard(verification: verifications[index]),
    );
  }
}

class _VerificationCard extends StatelessWidget {
  final Verifications verification;
  const _VerificationCard({required this.verification});
  @override
  Widget build(BuildContext context) {
    final displayImage = verification.images?.image1 ?? verification.images?.image2 ?? verification.images?.image3 ?? (verification.userImages?.isNotEmpty == true ? verification.userImages!.first : null);
    final displayName = (verification.firstName?.isNotEmpty == true) ? verification.firstName!.trim() : ('User ${verification.userId ?? ""}');
    final status = (verification.status ?? '').toLowerCase().trim();

    Color statusColor;
    IconData statusIcon;
    switch (status) {
      case 'verified':
        statusColor = DatingColors.darkGreen;
        statusIcon = Icons.verified_rounded;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.close_rounded;
        break;
      case 'processing':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_top_rounded;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => VerificationDetailScreen(verification: verification)));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), color: Colors.grey.shade100),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (displayImage == null || displayImage.isEmpty)
                      ? Icon(Icons.person_outline_rounded, size: 32, color: Colors.grey.shade400)
                      : Image.network(displayImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.broken_image_outlined, size: 32, color: Colors.grey.shade400)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 4),
                  Text('DOB: ${verification.dob?.isNotEmpty == true ? verification.dob : "—"}', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text('ID: ${verification.userId ?? "—"}', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: statusColor.withOpacity(0.3), width: 1)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(statusIcon, size: 14, color: statusColor),
                  const SizedBox(width: 4),
                  Text(status.isEmpty ? 'Pending' : status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
