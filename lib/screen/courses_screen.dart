import 'package:flutter/material.dart';
import 'package:comstudyapp/screen/course_detail.dart';
import '../theme/app_colors.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
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
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildYourCourses(),
                const SizedBox(height: 32),
                _buildBrowseAll(),
              ],
            ),
          ),
          Positioned(top: 0, left: 0, right: 0, child: _buildTopNav()),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 30, left: 24, right: 24),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24)),
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
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuC2F_7STGrmM1g3gHorAaPLmhkfcLq_zHAK045pmz5HDfVPLQSM71l7cgIaeUvBspd9VbU7o-67LYOCO8SIWqfUn0jcg95DeHB-KkSYahVjmXJOLDgGvpMSTuu9jUrgwoTTkyoEcOctUMXomnef8Y09ZEhvcgGikwdax_wtxHZyeYPAFVanXMAkIRfzQ3v-g7KyGH44csDHIc7fZJ002zw8IWJMxeWM3DNOq8GOkCc4vDnVmjY66GG4BjYBVNGcz7McsoI7_Klio29S',
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
                  fontFamily: 'Manrope',
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE3E2E6),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.onBackground.withValues(alpha: 0.6)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search courses...',
                style: TextStyle(
                  color: AppColors.onBackground.withValues(alpha: 0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYourCourses() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Courses',
            style: TextStyle(
              color: AppColors.primary,
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildCourseProgressCard(
            title: 'Advanced UI Patterns',
            module: 'Module 4: Cognitive Ergonomics',
            progress: 0.72,
            lessons: '12/16 Lessons',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDUT-4CSGsgztCenfy-dM87kMxd8zsRlZS_Q-2IQLmmGj6hDelkoKdmM75CfSE8jD-o2m8I1BMy7DjSKTKG8gfUGMA2C9oU5Wj-ixS_qpYIdecoDNA0sBjwT_o0L89vbBrmRrX6ZoRrvJ6o13_oL1h5Wgqb_ilJvNpwChCDBR9hSMEmq19U_rDuCbi-cnHf72_FytCvhw7q1T2Bwv8COl0-LPDGe8yIARZ-v0pWscX1tYsMPFZdPRcbcPT19wd3KTmXigM0jqk7Svv6',
          ),
          const SizedBox(height: 16),
          _buildCourseProgressCard(
            title: 'Mastering the Editorial Aesthetic',
            module: 'Module 2: Visual Hierarchy',
            progress: 0.45,
            lessons: '8/24 Lessons',
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBI7Dtlp0qoOZzZqy_kOsIdKMgG9m7xIrN6MtDiRSUyTAahqlYMeZAqWez9kWpwJBg5VDWoG0RffFK_2e9TnQVlCfKxUZJMILT8Xesy-RSst1-Rj5sOFyr5_pts9TrC9QwfQbYXxkt1_IZb_aztnALUjKtKD88bF1ElFN8YET4KPbZCi9IEu4_EOOlcYCJAQByJn2_ZXa_l1vs6dKduzGZsw_mLrqReCi1wj1qwM4-Zz3xX7X3XJIPGnFZZ0v_qFCzgP2ug29MKwvLT',
          ),
        ],
      ),
    );
  }

  Widget _buildCourseProgressCard({
    required String title,
    required String module,
    required double progress,
    required String lessons,
    required String imageUrl,
  }) {
    final percentText = '${(progress * 100).round()}%';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CourseDetailScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(imageUrl, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    module,
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            height: 6,
                            color: AppColors.surfaceContainerHighest,
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.tertiary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$percentText · $lessons',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseAll() {
    final courses = [
      {
        'title': 'Introduction to Curator Mindset',
        'mentor': 'Dr. Julian Vance',
        'rating': '4.9',
        'lessons': '24',
        'color': AppColors.primaryContainer,
      },
      {
        'title': 'Typography & Spatial Design',
        'mentor': 'Sarah Chen',
        'rating': '4.8',
        'lessons': '18',
        'color': AppColors.secondary,
      },
      {
        'title': 'Digital Curation Systems',
        'mentor': 'Marcus Roe',
        'rating': '4.7',
        'lessons': '20',
        'color': AppColors.tertiary,
      },
      {
        'title': 'History of Modern Art',
        'mentor': 'Elena L.',
        'rating': '4.6',
        'lessons': '16',
        'color': AppColors.primary,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Browse All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'SEE ALL',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return _buildBrowseCard(
                title: course['title'] as String,
                mentor: course['mentor'] as String,
                rating: course['rating'] as String,
                lessons: course['lessons'] as String,
                accentColor: course['color'] as Color,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBrowseCard({
    required String title,
    required String mentor,
    required String rating,
    required String lessons,
    required Color accentColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CourseDetailScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Center(
                child: Icon(Icons.play_circle_outline, color: accentColor, size: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mentor,
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.primary, size: 12),
                      const SizedBox(width: 4),
                      Text(rating, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text(
                        '$lessons lessons',
                        style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
