import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:comstudyapp/screen/quiz_evoluation_screen.dart';
import '../main.dart';
import '../models/course_model.dart';
import '../models/quiz_model.dart';
import '../theme/app_colors.dart';

class CourseDetailScreen extends StatefulWidget {
  final String? courseId;
  const CourseDetailScreen({super.key, this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final Color primary = AppColors.primary;
  final Color primaryContainer = AppColors.primaryContainer;
  final Color onSurface = AppColors.onSurface;
  final Color onSurfaceVariant = AppColors.onSurfaceVariant;

  Course? _course;
  YoutubePlayerController? _youtubeController;
  bool _isLoading = true;
  int _activeLessonIndex = 0;
  List<Quiz> _quizzes = [];

  @override
  void initState() {
    super.initState();
    if (widget.courseId != null) {
      _fetchCourse();
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  Future<void> _fetchCourse() async {
    final data = await supabase
        .from('courses')
        .select('*, modules(*, lessons(*))')
        .eq('id', widget.courseId!)
        .single();
    final course = Course.fromJson(data);
    final allLessons = course.modules.expand((m) => m.lessons).toList();
    final firstVideo = allLessons.firstWhere(
      (l) => l.youtubeVideoId != null,
      orElse: () => const Lesson(id: '', title: ''),
    );
    if (firstVideo.youtubeVideoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: firstVideo.youtubeVideoId!,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
      _activeLessonIndex = allLessons.indexOf(firstVideo);
    }

    // Fetch quizzes for this course
    final quizData = await supabase
        .from('quizzes')
        .select('id, title')
        .eq('course_id', widget.courseId!);
    final quizzes = (quizData as List)
        .map((e) => Quiz.fromJson(e as Map<String, dynamic>))
        .toList();

    if (!mounted) return;
    setState(() {
      _course = course;
      _quizzes = quizzes;
      _isLoading = false;
    });
  }

  List<Lesson> get _allLessons =>
      _course?.modules.expand((m) => m.lessons).toList() ?? [];

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
              BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                final lessons = _allLessons;
                if (_activeLessonIndex < lessons.length - 1) {
                  final next = lessons[_activeLessonIndex + 1];
                  if (next.youtubeVideoId != null) {
                    _youtubeController?.load(next.youtubeVideoId!);
                  }
                  setState(() {
                    _activeLessonIndex++;
                  });
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Continue Learning',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5)),
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
        borderRadius:
            const BorderRadius.only(bottomRight: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: AppColors.onBackground.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 4),
              Text(
                _course?.title ?? 'Course Detail',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_isLoading || _youtubeController == null) {
      return Container(
        width: double.infinity,
        height: 220,
        color: AppColors.onBackground,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return YoutubePlayer(
      controller: _youtubeController!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: primary,
    );
  }

  Widget _buildCourseMeta() {
    if (_course == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _course!.title,
                  style: const TextStyle(
                      color: AppColors.onSurface,
                      fontFamily: 'Manrope',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.2),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.primary, size: 14),
                    const SizedBox(width: 4),
                    Text(_course!.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.schedule,
                  color: AppColors.onSurfaceVariant, size: 14),
              const SizedBox(width: 6),
              Text(
                  _course!.durationText ?? '${_course!.totalLessons} Lessons',
                  style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              const SizedBox(width: 24),
              const Icon(Icons.layers,
                  color: AppColors.onSurfaceVariant, size: 14),
              const SizedBox(width: 6),
              Text('${_course!.totalLessons} Lessons',
                  style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsContent() {
    if (_course == null) return const SizedBox.shrink();
    final allLessons = _allLessons;
    final completedCount = _activeLessonIndex > 0 ? _activeLessonIndex : 0;
    final progressPercent = allLessons.isNotEmpty
        ? (completedCount / allLessons.length)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Course Content',
                  style: TextStyle(
                      color: AppColors.onSurface,
                      fontFamily: 'Manrope',
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text('${(progressPercent * 100).round()}% Completed',
                  style: const TextStyle(
                      color: AppColors.tertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
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
                widthFactor: progressPercent,
                child: Container(color: AppColors.tertiary),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(allLessons.length, (index) {
            final lesson = allLessons[index];
            final num = (index + 1).toString().padLeft(2, '0');
            if (index < _activeLessonIndex) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCompletedLesson(
                    num, lesson.title, lesson.durationText ?? ''),
              );
            } else if (index == _activeLessonIndex) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildActiveLesson(
                    num, lesson.title, lesson.durationText ?? '', lesson),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildLockedLesson(
                    num, lesson.title, lesson.durationText ?? ''),
              );
            }
          }),
          const SizedBox(height: 32),
          _buildMentorSection(),
          if (_quizzes.isNotEmpty) ...[
            const SizedBox(height: 32),
            _buildQuizSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildCompletedLesson(String num, String title, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: AppColors.tertiaryFixed,
                borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.check,
                color: AppColors.onTertiaryFixed, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LESSON $num',
                    style: const TextStyle(
                        color: AppColors.onTertiaryFixedVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
                const SizedBox(height: 2),
                Text(title,
                    style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(time,
                    style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _buildActiveLesson(
      String num, String title, String time, Lesson lesson) {
    return GestureDetector(
      onTap: () {
        if (lesson.youtubeVideoId != null) {
          _youtubeController?.load(lesson.youtubeVideoId!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: AppColors.primaryContainer.withValues(alpha: 0.2),
              width: 2),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(16)),
              child:
                  const Icon(Icons.play_arrow, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LESSON $num',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                  const SizedBox(height: 2),
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(time,
                      style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: AppColors.primary, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                const Text('PLAYING',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedLesson(String num, String title, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.lock,
                color: AppColors.onSurfaceVariant, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LESSON $num',
                    style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
                const SizedBox(height: 2),
                Text(title,
                    style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(time,
                    style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
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
      decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 2),
                      color: AppColors.primaryContainer,
                    ),
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_course?.mentorName ?? 'Mentor',
                          style: const TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const Text('Course Instructor',
                          style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                    color: AppColors.onSurface,
                    borderRadius: BorderRadius.circular(12)),
                child: const Text('Follow',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _course?.mentorBio ?? '',
            style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 12,
                fontStyle: FontStyle.italic,
                height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quizzes',
            style: TextStyle(
                color: AppColors.onSurface,
                fontFamily: 'Manrope',
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ..._quizzes.map((quiz) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizEvaluationScreen(quizId: quiz.id),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.primaryContainer.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.quiz,
                            color: AppColors.primaryContainer, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(quiz.title,
                                style: const TextStyle(
                                    color: AppColors.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text('${quiz.questions.length} questions',
                                style: const TextStyle(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          color: AppColors.onSurfaceVariant, size: 16),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
