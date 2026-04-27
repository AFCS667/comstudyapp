import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildVideoPlayer(),
                _buildCourseMeta(),
                _buildTabs(),
                _buildMaterialsContent(),
              ],
            ),
          ),
          Positioned(top: 0, left: 0, right: 0, child: _buildTopNav()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryContainer],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4)),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Continue Learning', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: AppColors.onBackground.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 4),
              const Text('The Academic Atelier', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            ],
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
              IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      width: double.infinity,
      height: 220,
      color: AppColors.onBackground,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBI7Dtlp0qoOZzZqy_kOsIdKMgG9m7xIrN6MtDiRSUyTAahqlYMeZAqWez9kWpwJBg5VDWoG0RffFK_2e9TnQVlCfKxUZJMILT8Xesy-RSst1-Rj5sOFyr5_pts9TrC9QwfQbYXxkt1_IZb_aztnALUjKtKD88bF1ElFN8YET4KPbZCi9IEu4_EOOlcYCJAQByJn2_ZXa_l1vs6dKduzGZsw_mLrqReCi1wj1qwM4-Zz3xX7X3XJIPGnFZZ0v_qFCzgP2ug29MKwvLT',
            fit: BoxFit.cover,
            color: Colors.black.withValues(alpha: 0.4),
            colorBlendMode: BlendMode.darken,
          ),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 48),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.tertiaryFixed, borderRadius: BorderRadius.circular(4)),
                      child: const Text('NOW PLAYING', style: TextStyle(color: AppColors.onTertiaryFixed, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                    const SizedBox(height: 4),
                    const Text('Principles of Curatorial Design', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Text('12:45 / 24:00', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCourseMeta() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text('Mastering the Editorial Aesthetic', style: TextStyle(color: AppColors.onSurface, fontFamily: 'Manrope', fontSize: 24, fontWeight: FontWeight.w800, height: 1.2)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: AppColors.primary, size: 14),
                    SizedBox(width: 4),
                    Text('4.9', style: TextStyle(color: AppColors.onSurface, fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.schedule, color: AppColors.onSurfaceVariant, size: 14),
              SizedBox(width: 6),
              Text('6h 45m', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w500)),
              SizedBox(width: 24),
              Icon(Icons.layers, color: AppColors.onSurfaceVariant, size: 14),
              SizedBox(width: 6),
              Text('24 Lessons', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: AppColors.background.withValues(alpha: 0.85),
      child: Row(
        children: [
          _buildTab('Materials', true),
          const SizedBox(width: 32),
          _buildTab('About', false),
          const SizedBox(width: 32),
          _buildTab('Forum', false),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isSelected ? AppColors.primary : Colors.transparent, width: 4)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMaterialsContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Course Content', style: TextStyle(color: AppColors.onSurface, fontFamily: 'Manrope', fontSize: 18, fontWeight: FontWeight.bold)),
              Text('45% Completed', style: TextStyle(color: AppColors.tertiary, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 8,
              width: double.infinity,
              color: AppColors.surfaceContainerHighest,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.45,
                child: Container(color: AppColors.tertiary),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildCompletedLesson('01', 'Introduction to Curator Mindset', '10:20 mins'),
          const SizedBox(height: 12),
          _buildCompletedLesson('02', 'Visual Hierarchy Foundations', '15:45 mins'),
          const SizedBox(height: 12),
          _buildActiveLesson('03', 'The "No-Line" Rule Deep Dive', '24:00 mins'),
          const SizedBox(height: 12),
          _buildLockedLesson('04', 'Editorial Spacing Patterns', '18:12 mins'),
          
          const SizedBox(height: 32),
          _buildMentorSection(),
        ],
      ),
    );
  }

  Widget _buildCompletedLesson(String num, String title, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.tertiaryFixed, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.check, color: AppColors.onTertiaryFixed, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LESSON $num', style: const TextStyle(color: AppColors.onTertiaryFixedVariant, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 2),
                Text(title, style: const TextStyle(color: AppColors.onSurface, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(time, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _buildActiveLesson(String num, String title, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.2), width: 2),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LESSON $num', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 2),
                Text(title, style: const TextStyle(color: AppColors.onSurface, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(time, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Row(
            children: [
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              const Text('PLAYING', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLockedLesson(String num, String title, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.lock, color: AppColors.onSurfaceVariant, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LESSON $num', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 2),
                Text(title, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(time, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 2),
                          image: const DecorationImage(
                            image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuD30Hpim1Wgai1y4Q-6O7UOdfGdfgUK_XbvuzP_A5VCUKEtOQSD_LFKDfDcdlc-ZKoqe0OgZuGY0B09epFdb_5ME6HL-poJmjTSwJswuejf6h97nIAWgj-RaTxMqwdKSXfidXSbyLvKihchFaLmQVAkecdOvF0raojhWowfdYCq1bsi8Lu88lyXRKxGwQdZTYD-MOUT6nLlzeEmt_Zvje6S91yms6P09oMjr0zvoISvEupezkotR1DHAEDP-MvLTG32kBjBSUT9dlA5'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(color: AppColors.tertiary, shape: BoxShape.circle, border: Border.all(color: AppColors.surfaceContainer, width: 2)),
                          child: const Icon(Icons.verified, color: Colors.white, size: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dr. Julian Vance', style: TextStyle(color: AppColors.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Lead Design Curator', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(color: AppColors.onSurface, borderRadius: BorderRadius.circular(12)),
                child: const Text('Follow', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          const Text('"Design is not about the containers we build, but the space we allow for the content to breathe."', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontStyle: FontStyle.italic, height: 1.5)),
        ],
      ),
    );
  }
}
