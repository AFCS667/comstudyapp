import 'package:flutter/material.dart';
import 'package:comstudyapp/screen/new_question_screen.dart';
import '../theme/app_colors.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
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
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NewQuestionScreen()),
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 75,
      padding: const EdgeInsets.only(top: 30, left: 24, right: 24),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.onBackground.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.secondary, width: 2),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCifc7Fiq16F0AynEjCOACblDy8xO3RjS526bZKJ4jvxXM2fKhH994Bfe_AcKxFA581O-agf-g2x04FZn_iCHxkgZ3lfDfyKcwcEKxLFwW4ISZYtKFjxP2C7k7OjiP5wvX4qpsl_S-b7CGJ596Jiac_VJjpKD9OpatbyBoih-8hIDCEu_vMwSHjL4mBslLfF0f5xnhm44FU3_HWsxQuQ9kI_TGz-InxnUDLWWEqI2BMvTOyS9T6B1DiTBQ95t34dGtzJsThlmH5ZF_1',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'The Academic Atelier',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const Icon(Icons.search, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(24),
            bottomLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Community Forum',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Manrope',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Explore, share, and learn with fellow atelier members.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildChip('All Discussions', isSelected: true),
          const SizedBox(width: 8),
          _buildChip('Recent', isSelected: false),
          const SizedBox(width: 8),
          _buildChip('Most Popular', isSelected: false),
          const SizedBox(width: 8),
          _buildChip('Unanswered', isSelected: false),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.surfaceContainerLow : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? null
            : Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.15),
              ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? AppColors.primaryContainer
              : AppColors.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildQuestionCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildQuestionCard(
            avatarUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDy_6CnPXnXkQwyGiZkiq_6rwQDk8kbzbLiUM-LDAu8LmJZPGIcdNqRaZZWo9AvvY29HSW8z6845-4LkHb4kfasUg22H2TZEJthgu66s1im5_M29_OO8N4vizpzoujdCZ24rF-53NEWhsSieFAgMJK55HoqGc0an6NJHGEXBesO1YumDTx4QUCEDRyiie8Fw2l_IqO37D-wnbF1HNXG_kG4ZBKPrlGempXq6AYlUdfmY3nrO1N1B7RCq-MsWJ8n1J04ajahYYFKbftL',
            title: 'How to implement complex Glassmorphism in Flutter?',
            meta: '2 hours ago • by Julian Craft',
            excerpt:
                "I'm trying to achieve that frosted glass look with multiple overlapping layers without losing performance on mid-range devices...",
            tags: ['#Flutter', '#UI Design'],
            replies: 12,
            likes: 45,
          ),
          const SizedBox(height: 16),
          _buildHighlightCard(
            avatarUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAA7cKjklnvXs2Nq9ooIJA8sTFnUI2UjX8bragY1-ZvH2TIRQsGZgFmT-JGso6fDEcBvtuMmWUHQj5GJjXZMdFAaLJS0SKQpXm03JeCz87PJ8UIPsgOgqDgE7Ur6Kn3RQ7MfZYz0Yav-RFSfTwBohBHiH6pahLGb--x74JXALUO-flrj3frIMkEVz__jelFZstSkuv4FWT-vp4TZ2jXgAq0JjSIBdob1HNkWunF2jjK_YtIRhO4TNwtbkTYKg3rgEXcPMlkOdeN6D4U',
            title: 'Upcoming Community Meetup: The Future of AI in Education',
            meta: '5 hours ago • by Sarah Chen',
            excerpt:
                "We're hosting a virtual roundtable to discuss how LLMs are reshaping the atelier learning experience. Don't miss out!",
          ),
          const SizedBox(height: 16),
          _buildQuestionCard(
            avatarUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAVJmYSiRvY3iuPbGi3tNLsLUkU1mWD_JS2wNHm_XfVKsI_M8aWH2P3xgYSVB2Xy9Hek7oWwN5DzPMvUWjswo6DdM4wUSt-Noojrk5id2vawMurA6d4PPJEjRJoenYeWQhAbd-tBpW8d0rEREcT19BOlsdLkbtQEsxS88qk-7Z3swvvF9m1ZthYBOsSVlDmqI0ww2VEfwk7LW_PK_VB82DmcoDnVqJ_4IKB5X5Z_L4qSUgu6cQn7GD0rjDAsU8ZXVqsllp8XwMzdGus',
            title: 'Best practices for Dart asynchronous patterns?',
            meta: 'Yesterday • by Marcus Roe',
            excerpt:
                "When dealing with nested streams and futures, what's your preferred architecture? Bloc, Provider, or signals?",
            tags: ['#Dart', '#Architecture'],
            replies: 8,
            likes: 29,
          ),
        ],
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
            color: AppColors.onSurface.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meta,
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            excerpt,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: tags
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
          const SizedBox(height: 12),
          const Divider(color: AppColors.surfaceContainerLow),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.forum,
                    size: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$replies',
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.favorite,
                    size: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$likes',
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Text(
                'View Thread',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard({
    required String avatarUrl,
    required String title,
    required String meta,
    required String excerpt,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.highlight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.highlight.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meta,
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            excerpt,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'MEETUP',
                  style: TextStyle(
                    color: AppColors.tertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Join Meetup',
                  style: TextStyle(
                    color: AppColors.onTertiaryFixed,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveDiscussion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ACTIVE DISCUSSION',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryFixed,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'EL',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Elena L.',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Text(
                  '10m ago',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'The typography choice really anchors the whole UI. Manrope for headlines was a stroke of genius!',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: AppColors.surfaceContainerHigh,
                      width: 2,
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
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
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.tertiaryFixed,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'TA',
                              style: TextStyle(
                                color: AppColors.tertiary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Tom Atelier',
                            style: TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            '5m ago',
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Agreed! It balances that professional authority with modern readability perfectly.',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
