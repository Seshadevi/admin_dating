// // verification_detail_screen.dart
// import 'package:admin_dating/provider/users/id_verification_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:admin_dating/models/users/id_verification_model.dart';


// class VerificationDetailScreen extends ConsumerWidget {
//   final VerificationId item;
//   const VerificationDetailScreen({super.key, required this.item});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final images = item.images;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(item.firstName ?? 'Verification'),
//         actions: [
//           if (item.verified == true)
//             const Padding(
//               padding: EdgeInsets.only(right: 12),
//               child: Icon(Icons.verified, color: Colors.blue),
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 8),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 _imageBlock('Selfie', images?.image1),
//                 const SizedBox(height: 12),
//                 _imageBlock('Aadhar', images?.image2),
//                 const SizedBox(height: 12),
//                 _imageBlock('PAN', images?.image3),
//               ],
//             ),
//           ),
//           SafeArea(
//             top: false,
//             minimum: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     icon: const Icon(Icons.close),
//                     label: const Text('Reject'),
//                     onPressed: () => _submit(context, ref, false),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.verified),
//                     label: const Text('Complete Verify'),
//                     onPressed: () => _submit(context, ref, true),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _imageBlock(String label, String? url) {
//     final hasUrl = url != null && url.trim().isNotEmpty;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//         const SizedBox(height: 6),
//         AspectRatio(
//           aspectRatio: 4 / 3,
//           child: DecoratedBox(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey.shade300),
//               color: Colors.grey.shade100,
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: hasUrl
//                   ? InteractiveViewer(
//                       child: Image.network(url!, fit: BoxFit.cover),
//                     )
//                   : const Center(child: Text('No image')),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _submit(
//       BuildContext context, WidgetRef ref, bool verify) async {
//     final userId = item.userId;
//     if (userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Missing userId')),
//       );
//       return;
//     }

//     final ok = await ref
//         .read(verificationIdProvider.notifier)
//         .updateVerification(userId: userId, verified: verify);

//     if (ok) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(verify ? 'Verified ✅' : 'Marked as not verified')),
//       );
//       Navigator.pop(context); // go back to list
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Update failed. Please try again.')),
//       );
//     }
//   }
// }













// // verification_detail_screen.dart
// import 'package:intl/intl.dart';
// import 'package:admin_dating/provider/users/id_verification_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:admin_dating/models/users/id_verification_model.dart';

// class VerificationDetailScreen extends ConsumerStatefulWidget {
//   final VerificationId item;
//   const VerificationDetailScreen({super.key, required this.item});

//   @override
//   ConsumerState<VerificationDetailScreen> createState() =>
//       _VerificationDetailScreenState();
// }

// class _VerificationDetailScreenState
//     extends ConsumerState<VerificationDetailScreen> {
//   bool _aadhaarOk = false; // matches name + DOB
//   bool _selfieOk = false;  // selfie matches PAN photo

//   String _formatDob(String? dob) {
//     if (dob == null || dob.trim().isEmpty) return '—';
//     try {
//       return DateFormat('dd MMM yyyy').format(DateTime.parse(dob));
//     } catch (_) {
//       return dob;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final item = widget.item;
//     final images = item.images;
//     final dobText = _formatDob(item.dob);

//     final canEvaluateAadhaar = (item.firstName?.isNotEmpty ?? false) &&
//         (item.dob?.isNotEmpty ?? false);

//     final canComplete = _aadhaarOk && _selfieOk;

//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(item.firstName ?? 'Verification'),
//             Text('DOB: $dobText',
//                 style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//           ],
//         ),
//         actions: [
//           if (item.verified == true)
//             const Padding(
//               padding: EdgeInsets.only(right: 12),
//               child: Icon(Icons.verified, color: Colors.blue),
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 8),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 // Aadhaar block
//                 _imageBlock('Aadhaar', images?.image1),
//                 const SizedBox(height: 8),
//                 CheckboxListTile(
//                   contentPadding: EdgeInsets.zero,
//                   title: const Text('Aadhaar name & DOB match'),
//                   subtitle: Text(
//                     'Expected • Name: ${item.firstName ?? '—'} | DOB: $dobText',
//                     style: TextStyle(color: Colors.grey[700]),
//                   ),
//                   value: _aadhaarOk,
//                   onChanged: canEvaluateAadhaar
//                       ? (v) => setState(() => _aadhaarOk = v ?? false)
//                       : null,
//                   secondary: const Icon(Icons.badge_outlined),
//                 ),
//                 if (!canEvaluateAadhaar)
//                   Padding(
//                     padding: const EdgeInsets.only(left: 8, bottom: 8),
//                     child: Text(
//                       'Cannot auto-evaluate: missing name or DOB in profile. Verify visually, then tick above.',
//                       style:
//                           TextStyle(fontSize: 12, color: Colors.orange[700]),
//                     ),
//                   ),
//                 const SizedBox(height: 16),

//                 // Selfie + PAN blocks (order: Selfie then PAN)
//                 _imageBlock('Selfie', images?.image2),
//                 const SizedBox(height: 12),
//                 _imageBlock('PAN', images?.image3),
//                 const SizedBox(height: 8),
//                 CheckboxListTile(
//                   contentPadding: EdgeInsets.zero,
//                   title: const Text('Selfie matches PAN photo (face check)'),
//                   subtitle: Text(
//                     'Compare Selfie with PAN portrait area.',
//                     style: TextStyle(color: Colors.grey[700]),
//                   ),
//                   value: _selfieOk,
//                   onChanged: (v) => setState(() => _selfieOk = v ?? false),
//                   secondary: const Icon(Icons.verified_user_outlined),
//                 ),
//               ],
//             ),
//           ),

//           // Actions
//           SafeArea(
//             top: false,
//             minimum: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     icon: const Icon(Icons.close),
//                     label: const Text('Reject'),
//                     onPressed: () => _submit(context, false),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.verified),
//                     label: const Text('Complete Verify'),
//                     onPressed: canComplete ? () => _submit(context, true) : null,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _imageBlock(String label, String? url) {
//     final hasUrl = url != null && url.trim().isNotEmpty;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//         const SizedBox(height: 6),
//         AspectRatio(
//           aspectRatio: 4 / 3,
//           child: DecoratedBox(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey.shade300),
//               color: Colors.grey.shade100,
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: hasUrl
//                   ? GestureDetector(
//                       onTap: () => _openFullImage(url!),
//                       child: InteractiveViewer(
//                         child: Image.network(url!, fit: BoxFit.cover),
//                       ),
//                     )
//                   : const Center(child: Text('No image')),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _openFullImage(String url) {
//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         insetPadding: const EdgeInsets.all(12),
//         child: InteractiveViewer(
//           minScale: 0.5,
//           maxScale: 5,
//           child: Image.network(url, fit: BoxFit.contain),
//         ),
//       ),
//     );
//   }

//   Future<void> _submit(BuildContext context, bool verify) async {
//     final userId = widget.item.userId;
//     if (userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Missing userId')),
//       );
//       return;
//     }

//     final ok = await ref
//         .read(verificationIdProvider.notifier)
//         .updateVerification(userId: userId, verified: verify);

//     if (ok) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content:
//                 Text(verify ? 'Verified ✅' : 'Marked as not verified')),
//       );
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Update failed. Please try again.')),
//       );
//     }
//   }
// }




import 'package:intl/intl.dart';
import 'package:admin_dating/provider/users/id_verification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_dating/models/users/id_verification_model.dart';

class VerificationDetailScreen extends ConsumerStatefulWidget {
  final Verifications verification; // Fixed to use Verifications instead of VerificationId
  const VerificationDetailScreen({super.key, required this.verification});

  @override
  ConsumerState<VerificationDetailScreen> createState() =>
      _VerificationDetailScreenState();
}

class _VerificationDetailScreenState
    extends ConsumerState<VerificationDetailScreen> {
  bool _aadhaarVerified = false;
  bool _selfieVerified = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Initialize based on current verification status
    final isCurrentlyVerified = (widget.verification.status?.toLowerCase() == 'verified');
    _aadhaarVerified = isCurrentlyVerified;
    _selfieVerified = isCurrentlyVerified;
  }

  String _formatDob(String? dob) {
    if (dob == null || dob.trim().isEmpty) return '—';
    try {
      final date = DateTime.parse(dob);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return dob;
    }
  }

  @override
  Widget build(BuildContext context) {
    final verification = widget.verification;
    final images = verification.images;
    final dobText = _formatDob(verification.dob);
    final displayName = verification.firstName?.isNotEmpty == true 
        ? verification.firstName! 
        : 'User ${verification.userId ?? ''}';

    final canEvaluateAadhaar = (verification.firstName?.isNotEmpty ?? false) &&
        (verification.dob?.isNotEmpty ?? false);

    final canComplete = _aadhaarVerified && _selfieVerified;
    final statusLower = (verification.status ?? '').toLowerCase();
    final currentStatus = _getStatusData(verification.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF1A1A1A)),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Text(
              'DOB: $dobText',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: currentStatus.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: currentStatus.color.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(currentStatus.icon, size: 16, color: currentStatus.color),
                const SizedBox(width: 4),
                Text(
                  verification.status?.isNotEmpty == true ? verification.status! : 'Pending',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: currentStatus.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(Icons.person_outline, 'Name', displayName),
                          _InfoRow(Icons.calendar_today_outlined, 'Date of Birth', dobText),
                          _InfoRow(Icons.badge_outlined, 'User ID', '${verification.userId ?? '—'}'),
                          _InfoRow(Icons.verified_user_outlined, 'Verified', 
                              verification.verified == true ? 'Yes' : 'No'),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Documents Section
                  const Text(
                    'Verification Documents',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Aadhaar Document
                  _DocumentCard(
                    title: 'Aadhaar Card',
                    imageUrl: images?.image1,
                    icon: Icons.credit_card_rounded,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  
                  // Aadhaar Verification Checkbox
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: const Text(
                        'Aadhaar Details Match',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        canEvaluateAadhaar 
                            ? 'Name and DOB match with user profile'
                            : 'Manually verify details (missing profile data)',
                        style: TextStyle(
                          color: canEvaluateAadhaar ? Colors.grey[700] : Colors.orange[700],
                          fontSize: 12,
                        ),
                      ),
                      value: _aadhaarVerified,
                      onChanged: canEvaluateAadhaar
                          ? (value) => setState(() => _aadhaarVerified = value ?? false)
                          : (value) => setState(() => _aadhaarVerified = value ?? false), // Allow manual override
                      activeColor: const Color(0xFF667EEA),
                      secondary: Icon(
                        Icons.assignment_turned_in_outlined,
                        color: _aadhaarVerified ? const Color(0xFF667EEA) : Colors.grey,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Selfie Document
                  _DocumentCard(
                    title: 'Selfie Photo',
                    imageUrl: images?.image2,
                    icon: Icons.face_rounded,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  
                  // PAN Document
                  _DocumentCard(
                    title: 'PAN Card',
                    imageUrl: images?.image3,
                    icon: Icons.badge_outlined,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  
                  // Face Match Verification
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: const Text(
                        'Face Verification Passed',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        'Selfie matches with PAN card photo',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _selfieVerified,
                      onChanged: (value) => setState(() => _selfieVerified = value ?? false),
                      activeColor: const Color(0xFF667EEA),
                      secondary: Icon(
                        Icons.face_retouching_natural_outlined,
                        color: _selfieVerified ? const Color(0xFF667EEA) : Colors.grey,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Action Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isProcessing ? null : () => _handleAction(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _isProcessing 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.close_rounded, color: Colors.red),
                      label: Text(
                        'Reject',
                        style: TextStyle(
                          color: _isProcessing ? Colors.grey : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (_isProcessing || !canComplete) ? null : () => _handleAction(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canComplete ? const Color(0xFF667EEA) : Colors.grey.shade300,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: canComplete ? 2 : 0,
                      ),
                      icon: _isProcessing 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.verified_rounded),
                      label: const Text(
                        'Approve',
                        style: TextStyle(fontWeight: FontWeight.w600),
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

  Future<void> _handleAction(bool approved) async {
    final userId = widget.verification.userId;
    if (userId == null) {
      _showSnackBar('Error: Missing user ID', isError: true);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final success = await ref
          .read(verificationIdProvider.notifier)
          .updateVerification(userId: userId, verified: approved);

      if (success) {
        _showSnackBar(
          approved ? 'User verified successfully! ✅' : 'User verification rejected',
          isError: false,
        );
        Navigator.pop(context);
      } else {
        _showSnackBar('Failed to update verification. Please try again.', isError: true);
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  ({Color color, IconData icon}) _getStatusData(String? status) {
    switch ((status ?? '').toLowerCase()) {
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final IconData icon;
  final Color color;

  const _DocumentCard({
    required this.title,
    required this.imageUrl,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                if (hasImage)
                  IconButton(
                    onPressed: () => _openFullScreenImage(context, imageUrl!),
                    icon: const Icon(Icons.fullscreen_rounded),
                    tooltip: 'View full size',
                  ),
              ],
            ),
          ),
          
          // Image
          Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: hasImage
                  ? GestureDetector(
                      onTap: () => _openFullScreenImage(context, imageUrl!),
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: color,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Loading image...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Failed to load image',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No image available',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 5.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Failed to load image',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}