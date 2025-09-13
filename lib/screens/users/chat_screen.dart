// screens/chat_admin_screen.dart
import 'dart:async';
import 'package:admin_dating/models/users/chat_model.dart';
import 'package:admin_dating/provider/users/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


class AdminChatScreen extends ConsumerStatefulWidget {
  final String accessToken; // 👈 passed from Matches screen
  final int peerUserId;     // user admin chats with
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
  Timer? _typingDebounce;

  late final AdminChatParams _params;

  @override
  void initState() {
    super.initState();
    _params = AdminChatParams(
      accessToken: widget.accessToken,
      peerUserId: widget.peerUserId,
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
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.avatar)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.peerName, style: const TextStyle(fontSize: 16)),
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
                    color: presence?.online == true ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final it = items[i];
                if (it.isHeader) {
                  return _DateHeader(label: it.header!);
                }
                final msg = it.message!;
                // We don't know admin's own id; so we’ll align by “who is the peer”
                final isMe = msg.receiverId == widget.peerUserId
                    ? true
                    : (msg.senderId != widget.peerUserId);
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFD1F7C4) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(msg.message),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('hh:mm a').format(msg.timestamp.toLocal()),
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (isTyping)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('typing…',
                  style: TextStyle(color: Colors.green[700], fontSize: 12)),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message…",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (_) {
                      _typingDebounce?.cancel();
                      ref.read(adminChatProvider(_params).notifier).sendTyping();
                      _typingDebounce = Timer(const Duration(milliseconds: 1200), () {});
                    },
                    onSubmitted: (_) => _send(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _send),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(adminChatProvider(_params).notifier).sendMessage(text);
    _controller.clear();
    _scrollToBottom();
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
        child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
