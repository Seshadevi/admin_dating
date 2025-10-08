// screens/chat_admin_screen.dart
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:admin_dating/models/users/chat_model.dart';
import 'package:admin_dating/provider/users/chat_provider.dart';
import 'package:admin_dating/constants/dating_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class AdminChatScreen extends ConsumerStatefulWidget {
  final String accessToken;
  final int peerUserId;
  final String peerName;
  final String avatar;

  const AdminChatScreen({
    super.key,
    required this.accessToken,
    required this.peerUserId,
    required this.peerName,
    required this.avatar,
  });

  @override
  ConsumerState<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends ConsumerState<AdminChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  Timer? _typingDebounce;
  bool _isTyping = false;
  bool _showEmojiPicker = false;
  bool _isSendingImage = false;

  late final AdminChatParams _params;

  @override
  void initState() {
    super.initState();
    _params = AdminChatParams(
      accessToken: widget.accessToken,
      peerUserId: widget.peerUserId,
    );
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTyping = _controller.text.trim().isNotEmpty;
    });
    
    _typingDebounce?.cancel();
    ref.read(adminChatProvider(_params).notifier).sendTyping();
    _typingDebounce = Timer(const Duration(milliseconds: 1200), () {});
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && _showEmojiPicker) {
      setState(() {
        _showEmojiPicker = false;
      });
    }
  }

  // Convert image file to base64 data URL
  Future<String> _convertImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      
      final extension = imageFile.path.split('.').last.toLowerCase();
      String mimeType;
      switch (extension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        case 'webp':
          mimeType = 'image/webp';
          break;
        case 'gif':
          mimeType = 'image/gif';
          break;
        default:
          mimeType = 'image/jpeg';
      }
      
      return 'data:$mimeType;base64,$base64String';
    } catch (e) {
      throw Exception('Failed to convert image: $e');
    }
  }

  // Send image message via socket
  Future<void> _sendImageMessage(String base64DataUrl, {String? caption}) async {
    try {
      setState(() {
        _isSendingImage = true;
      });

      // Send via socket - you'll need to add this method to your provider
      ref.read(adminChatProvider(_params).notifier).sendImageMessage(
        media: [base64DataUrl],
        message: caption,
      );

      if (caption != null && caption.isNotEmpty) {
        _controller.clear();
        setState(() {
          _isTyping = false;
        });
      }

      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSendingImage = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (image != null) {
        final base64DataUrl = await _convertImageToBase64(File(image.path));
        await _sendImageMessage(base64DataUrl);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.pink,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _AttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(adminChatProvider(_params));
    final isTyping = ref.watch(adminTypingProvider(widget.peerUserId));
    final presence = ref.watch(adminPresenceProvider(widget.peerUserId));

    final items = _withDateHeaders(messages);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: DatingColors.darkGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
          padding: const EdgeInsets.only(left: 8),
          constraints: const BoxConstraints(minWidth: 30),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.avatar),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.peerName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    presence == null
                        ? ''
                        : presence.online
                            ? 'Online'
                            : (presence.lastSeen != null
                                ? 'last seen ${DateFormat('dd MMM, hh:mm a').format(presence.lastSeen!)}'
                                : 'Offline'),
                    style: TextStyle(
                      fontSize: 12,
                      color: presence?.online == true 
                          ? Colors.greenAccent 
                          : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              print('Video call tapped');
            },
            icon: const Icon(Icons.videocam, color: Colors.white, size: 28),
          ),
          IconButton(
            onPressed: () {
              print('Voice call tapped');
            },
            icon: const Icon(Icons.call, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/chat_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white.withOpacity(0.3),
                ),
                // Container(
                //   color: const Color(0xFFF5F5F5),
                //   child:
                   ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final it = items[i];
                      if (it.isHeader) {
                        return _DateHeader(label: it.header!);
                      }
                      final msg = it.message!;
                      final isMe = msg.receiverId == widget.peerUserId
                          ? true
                          : (msg.senderId != widget.peerUserId);
                      
                      return Padding(
                        padding: EdgeInsets.only(
                          left: isMe ? 80.0 : 10.0,
                          right: isMe ? 10.0 : 80.0,
                          top: 4.0,
                          bottom: 4.0,
                        ),
                        child: Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                              minWidth: 60,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? DatingColors.darkGreen.withOpacity(0.85)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isMe ? 16 : 4),
                                bottomRight: Radius.circular(isMe ? 4 : 16),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: isMe 
                                  ? CrossAxisAlignment.end 
                                  : CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Display images if message has media
                                if (msg.hasImages)
                                  ...msg.mediaItems.map((mediaItem) {
                                    if (mediaItem.isBase64) {
                                      try {
                                        final base64Str = mediaItem.url.split(',').last;
                                        final bytes = base64Decode(base64Str);

                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.memory(
                                              bytes,
                                              fit: BoxFit.cover,
                                              height: 200,
                                              width: double.infinity,
                                              errorBuilder: (context, error, stackTrace) => 
                                                Container(
                                                  height: 200,
                                                  color: Colors.grey[300],
                                                  child: const Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.broken_image, size: 50),
                                                      Text('Failed to load image'),
                                                    ],
                                                  ),
                                                ),
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        return Container(
                                          height: 200,
                                          color: Colors.grey[300],
                                          child: const Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.error, size: 50),
                                              Text('Invalid image format'),
                                            ],
                                          ),
                                        );
                                      }
                                    } else if (mediaItem.isNetworkUrl) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            mediaItem.url,
                                            fit: BoxFit.cover,
                                            height: 200,
                                            width: double.infinity,
                                            errorBuilder: (context, error, stackTrace) => 
                                              Container(
                                                height: 200,
                                                color: Colors.grey[300],
                                                child: const Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.broken_image, size: 50),
                                                    Text('Failed to load image'),
                                                  ],
                                                ),
                                              ),
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Container(
                                                height: 200,
                                                color: Colors.grey[200],
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                            (loadingProgress.expectedTotalBytes ?? 1)
                                                        : null,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }).toList(),
                                
                                // Display text message if exists
                                if (msg.message != null && msg.message!.isNotEmpty)
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: msg.message,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isMe 
                                                ? Colors.white 
                                                : Colors.black87,
                                            height: 1.3,
                                          ),
                                        ),
                                        const TextSpan(text: '  '),
                                        TextSpan(
                                          text: DateFormat('hh:mm a').format(msg.timestamp.toLocal()),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: isMe 
                                                ? Colors.white70 
                                                : Colors.black45,
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                
                                // Show only timestamp if no text message (image only)
                                if ((msg.message == null || msg.message!.isEmpty) && 
                                    msg.media != null && msg.media!.isNotEmpty)
                                  Text(
                                    DateFormat('hh:mm a').format(msg.timestamp.toLocal()),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isMe 
                                          ? Colors.white70 
                                          : Colors.black45,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                // ),
                
                // Image sending loading overlay
                if (_isSendingImage)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text('Sending image...'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Typing indicator
          if (isTyping)
            Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 16, right: 80),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.4,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'typing…',
                        style: TextStyle(
                          color: Colors.black54, 
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Input Area
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: SafeArea(
              child: Row(
                children: [
                  // Emoji button
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showEmojiPicker = !_showEmojiPicker;
                      });
                      
                      if (_showEmojiPicker) {
                        _focusNode.unfocus();
                      } else {
                        _focusNode.requestFocus();
                      }
                    },
                    icon: Icon(
                      _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  
                  // Text input
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: "Type a message",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, 
                                  vertical: 12,
                                ),
                              ),
                              maxLines: 5,
                              minLines: 1,
                              onSubmitted: (_) => _sendMessage(),
                              onTap: () {
                                if (_showEmojiPicker) {
                                  setState(() {
                                    _showEmojiPicker = false;
                                  });
                                }
                              },
                            ),
                          ),
                          
                          // Attachment button (only show when not typing)
                          if (!_isTyping)
                            IconButton(
                              onPressed: _showAttachmentOptions,
                              icon: Icon(
                                Icons.attach_file,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Send/Mic button
                  Container(
                    decoration: BoxDecoration(
                      color: DatingColors.darkGreen,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _isTyping ? _sendMessage : _recordVoice,
                      icon: Icon(
                        _isTyping ? Icons.send : Icons.mic,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Emoji Picker
          if (_showEmojiPicker)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  _controller.text += emoji.emoji;
                  setState(() {
                    _isTyping = _controller.text.trim().isNotEmpty;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(adminChatProvider(_params).notifier).sendMessage(text);
    _controller.clear();
    setState(() {
      _isTyping = false;
    });
    _scrollToBottom();
  }

  void _recordVoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hold to record voice message'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<_Item> _withDateHeaders(List<AdminChatMessage> msgs) {
    final out = <_Item>[];
    DateTime? lastDay;
    for (final m in msgs..sort((a, b) => a.timestamp.compareTo(b.timestamp))) {
      final d = DateTime(m.timestamp.year, m.timestamp.month, m.timestamp.day);
      if (lastDay == null || d.difference(lastDay).inDays != 0) {
        out.add(_Item.header(_labelFor(d)));
        lastDay = d;
      }
      out.add(_Item.message(m));
    }
    return out;
  }

  String _labelFor(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yday = today.subtract(const Duration(days: 1));
    final day = DateTime(d.year, d.month, d.day);
    if (day == today) return 'Today';
    if (day == yday) return 'Yesterday';
    return DateFormat('dd MMM yyyy').format(d);
  }
}

class _DateHeader extends StatelessWidget {
  final String label;
  const _DateHeader({required this.label, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            label, 
            style: const TextStyle(
              color: Colors.black54, 
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Item {
  final bool isHeader;
  final String? header;
  final AdminChatMessage? message;
  _Item.header(this.header) : isHeader = true, message = null;
  _Item.message(this.message) : isHeader = false, header = null;
}