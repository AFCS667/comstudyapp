import 'package:comstudyapp/main.dart';
import 'package:comstudyapp/models/forum_model.dart';
import 'package:comstudyapp/screen/forum_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:comstudyapp/screen/new_question_screen.dart';
import '../theme/app_colors.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<ForumPost> _forumPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadForumPosts();
  }

  Future<void> _loadForumPosts() async {
    try {
      final data = await supabase.from('posts').select('*, replies(id)').order('created_at', ascending: false);

      setState(() {
        _forumPosts = (data as List).map((postJson){
          final List repliesData = postJson['replies'] ?? [];
          final int totalRepliesCount = repliesData.length;
          postJson['replies'] = totalRepliesCount;
          return ForumPost.fromJson(postJson);
        }).toList();

        _isLoading = false;

      });

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error fetching posts: $e');
    }
  }

  Future<void> _navigateToNewQuestion() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewQuestionScreen()),
    );
    if (result == true) {
      setState(() {
        _isLoading = true;
      });
      _loadForumPosts();
    }
  }

  Future<void> _navigateToDetail(ForumPost post) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ForumDetailScreen(post: post)),
    );
      _loadForumPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 80, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeroSection(),
                      const SizedBox(height: 16),
                      _buildFilterChips(),
                      const SizedBox(height: 16),
                      _buildQuestionCards(),
                      const SizedBox(height: 32),
                      _buildActiveDiscussion(),
                    ],
                  ),
                ),
          Positioned(top: 0, left: 0, right: 0, child: _buildTopNav()),
          Positioned(
            bottom: 110,
            right: 24,
            child: GestureDetector(
              onTap: _navigateToNewQuestion,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.tertiaryContainer, AppColors.tertiary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.tertiary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 16, left: 24, right: 24),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.85),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Atelier Space',
            style: TextStyle(
              color: AppColors.primaryContainer,
              fontFamily: 'Manrope',
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search, color: AppColors.onSurfaceVariant, size: 20),
          )
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'COMMUNITY',
            style: TextStyle(
              color: AppColors.secondary,
              fontFamily: 'Manrope',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Connect & Learn',
            style: TextStyle(
              color: AppColors.onSurface,
              fontFamily: 'Manrope',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All Threads', 'Popular', 'My Questions', 'Saved'];
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              filters[index],
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                fontFamily: 'Manrope',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionCards() {
    if (_forumPosts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text(
            'No threads available. Be the first to ask!',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _forumPosts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final post = _forumPosts[index];
          return InkWell(
            onTap: () => _navigateToDetail(post),
            borderRadius: BorderRadius.circular(24),
            child: _buildQuestionCard(
              avatarUrl: post.avatarUrl,
              title: post.title,
              meta: post.meta,
              excerpt: post.excerpt,
              tags: post.tags,
              replies: post.replies,
              likes: post.likes,
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionCard({
    required String avatarUrl,
    required String title,
    required String meta,
    required String excerpt,
    required List<String> tags,
    required int replies,
    required int likes,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: avatarUrl.startsWith('http') ? NetworkImage(avatarUrl) : null,
                child: !avatarUrl.startsWith('http') ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  meta,
                  style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontFamily: 'Manrope',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            excerpt,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Wrap(
                spacing: 6,
                children: tags
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
              ),
              const Spacer(),
              Icon(Icons.chat_bubble_outline, size: 16, color: AppColors.onSurfaceVariant.withValues(alpha: 0.8)),
              const SizedBox(width: 4),
              Text('$replies', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Icon(Icons.favorite_border, size: 16, color: AppColors.onSurfaceVariant.withValues(alpha: 0.8)),
              const SizedBox(width: 4),
              Text('$likes', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveDiscussion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ACTIVE DISCUSSION',
            style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What are the best IEEE rules for using CPU abbreviations in research?',
                  style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold, fontSize: 14, height: 1.3),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.tertiaryFixed),
                            alignment: Alignment.center,
                            child: const Text(
                              'TA',
                              style: TextStyle(color: AppColors.tertiary, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Tom Atelier', style: TextStyle(color: AppColors.onSurface, fontSize: 12, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          const Text('5m ago', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 9)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Agreed! It balances that professional authority with modern readability perfectly.',
                        style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}