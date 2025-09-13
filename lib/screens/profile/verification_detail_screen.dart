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













// verification_detail_screen.dart
import 'package:intl/intl.dart';
import 'package:admin_dating/provider/users/id_verification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_dating/models/users/id_verification_model.dart';

class VerificationDetailScreen extends ConsumerStatefulWidget {
  final VerificationId item;
  const VerificationDetailScreen({super.key, required this.item});

  @override
  ConsumerState<VerificationDetailScreen> createState() =>
      _VerificationDetailScreenState();
}

class _VerificationDetailScreenState
    extends ConsumerState<VerificationDetailScreen> {
  bool _aadhaarOk = false; // matches name + DOB
  bool _selfieOk = false;  // selfie matches PAN photo

  String _formatDob(String? dob) {
    if (dob == null || dob.trim().isEmpty) return '—';
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(dob));
    } catch (_) {
      return dob;
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final images = item.images;
    final dobText = _formatDob(item.dob);

    final canEvaluateAadhaar = (item.firstName?.isNotEmpty ?? false) &&
        (item.dob?.isNotEmpty ?? false);

    final canComplete = _aadhaarOk && _selfieOk;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.firstName ?? 'Verification'),
            Text('DOB: $dobText',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        actions: [
          if (item.verified == true)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.verified, color: Colors.blue),
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Aadhaar block
                _imageBlock('Aadhaar', images?.image1),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Aadhaar name & DOB match'),
                  subtitle: Text(
                    'Expected • Name: ${item.firstName ?? '—'} | DOB: $dobText',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  value: _aadhaarOk,
                  onChanged: canEvaluateAadhaar
                      ? (v) => setState(() => _aadhaarOk = v ?? false)
                      : null,
                  secondary: const Icon(Icons.badge_outlined),
                ),
                if (!canEvaluateAadhaar)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: Text(
                      'Cannot auto-evaluate: missing name or DOB in profile. Verify visually, then tick above.',
                      style:
                          TextStyle(fontSize: 12, color: Colors.orange[700]),
                    ),
                  ),
                const SizedBox(height: 16),

                // Selfie + PAN blocks (order: Selfie then PAN)
                _imageBlock('Selfie', images?.image2),
                const SizedBox(height: 12),
                _imageBlock('PAN', images?.image3),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Selfie matches PAN photo (face check)'),
                  subtitle: Text(
                    'Compare Selfie with PAN portrait area.',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  value: _selfieOk,
                  onChanged: (v) => setState(() => _selfieOk = v ?? false),
                  secondary: const Icon(Icons.verified_user_outlined),
                ),
              ],
            ),
          ),

          // Actions
          SafeArea(
            top: false,
            minimum: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text('Reject'),
                    onPressed: () => _submit(context, false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.verified),
                    label: const Text('Complete Verify'),
                    onPressed: canComplete ? () => _submit(context, true) : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageBlock(String label, String? url) {
    final hasUrl = url != null && url.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        AspectRatio(
          aspectRatio: 4 / 3,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.grey.shade100,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: hasUrl
                  ? GestureDetector(
                      onTap: () => _openFullImage(url!),
                      child: InteractiveViewer(
                        child: Image.network(url!, fit: BoxFit.cover),
                      ),
                    )
                  : const Center(child: Text('No image')),
            ),
          ),
        ),
      ],
    );
  }

  void _openFullImage(String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5,
          child: Image.network(url, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context, bool verify) async {
    final userId = widget.item.userId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing userId')),
      );
      return;
    }

    final ok = await ref
        .read(verificationIdProvider.notifier)
        .updateVerification(userId: userId, verified: verify);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(verify ? 'Verified ✅' : 'Marked as not verified')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update failed. Please try again.')),
      );
    }
  }
}
