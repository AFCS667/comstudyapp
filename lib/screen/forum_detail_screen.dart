import 'package:comstudyapp/main.dart';
import 'package:comstudyapp/models/forum_model.dart';
import 'package:comstudyapp/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ForumDetailScreen extends StatefulWidget {
  final ForumPost post;
  const ForumDetailScreen({super.key, required this.post});

  @override
  State<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  final TextEditingController _replyController = TextEditingController();
  bool _isLoadingReplies = true;

  @override
  void initState() {
    super.initState();
    _loadReplies();
  }

  Future<void> _loadReplies() async {
    try {
      final data = await supabase
          .from('replies')
          .select()
          .eq('post_id', widget.post.id)
          .order('created_at', ascending: true);

      setState(() {
        widget.post.repliesList.clear();

        for (var replyJson in (data as List)) {
          widget.post.repliesList.add(ForumReply.fromJson(replyJson));
        }

        widget.post.replies = widget.post.repliesList.length;
        _isLoadingReplies = false;
      });
    } catch (e) {
      setState(() => _isLoadingReplies = false);
      debugPrint('Error loading replies dari Supabase: $e');
    }
  }

  Future<void> _sendReply() async {
    if (_replyController.text.trim().isEmpty) return;

    final String messageText = _replyController.text.trim();
    _replyController.clear();
    FocusScope.of(context).unfocus();

    try {
      final user = supabase.auth.currentUser;
      final String displayName =
          user?.userMetadata?['username'] ?? user?.email?.split('@').first;

      if (widget.post.id.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post ID is missing. Cannot send reply.'),
          ),
        );
        return;
      }

      final currTime = DateTime.now().toLocal();
      final String currTimeStr = '${currTime.hour.toString().padLeft(2, '0')}:${currTime.minute.toString().padLeft(2, '0')}';
      await supabase.from('replies').insert({
        'post_id': widget.post.id,
        'avatar_url':
            'https://api.dicebear.com/7.x/avataaars/svg?seed=${Uri.encodeComponent(displayName)}',
        'sender_name': displayName,
        'message': messageText,
        'time': currTimeStr,
      });

      setState(() {
        widget.post.replies = widget.post.replies + 1;
      });

      try {
        await supabase
            .from('posts')
            .update({'replies': widget.post.replies + 1})
            .eq('id', widget.post.id);
      } catch (updateError) {
        debugPrint('Error updating reply count: $updateError');
      }

      _loadReplies();
    } catch (e) {
      debugPrint("Exception saving reply: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send reply. Please try again.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryContainer,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),

              onPressed: () => Navigator.of(context).pop(true),
            ),
          ),
        ),
        title: const Text(
          'Discussion Thread',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMainPost(),
                  const SizedBox(height: 32),
                  const Text(
                    'REPLIES',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _isLoadingReplies
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : widget.post.repliesList.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              'No replies yet. Be the first to comment!',
                              style: TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.post.repliesList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final reply = widget.post.repliesList[index];
                            return _buildReplyItem(reply: reply);
                          },
                        ),
                ],
              ),
            ),
          ),
          _buildWriteReplyBar(),
        ],
      ),
    );
  }

  Widget _buildMainPost() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.post.avatarUrl.startsWith('http')
                    ? NetworkImage(widget.post.avatarUrl)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.meta,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            widget.post.title,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          MarkdownBody(
            data: widget.post.excerpt,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.post.tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyItem({required ForumReply reply}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: reply.avatarUrl.startsWith('http')
                    ? NetworkImage(reply.avatarUrl)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                reply.senderName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                reply.time,
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            reply.message,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWriteReplyBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _replyController,
              decoration: InputDecoration(
                hintText: 'Write a reply...',
                filled: true,
                fillColor: AppColors.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              style: const TextStyle(fontSize: 14, color: AppColors.onSurface),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primary),
            onPressed: _sendReply,
          ),
        ],
      ),
    );
  }
}
