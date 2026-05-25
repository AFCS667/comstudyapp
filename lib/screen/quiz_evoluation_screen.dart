import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/quiz_model.dart';
import '../theme/app_colors.dart';

class QuizEvaluationScreen extends StatefulWidget {
  final String? quizId;
  const QuizEvaluationScreen({super.key, this.quizId});

  @override
  State<QuizEvaluationScreen> createState() => _QuizEvaluationScreenState();
}

class _QuizEvaluationScreenState extends State<QuizEvaluationScreen> {
  Quiz? _quiz;
  bool _isLoading = true;
  int _currentIndex = 0;
  String? _selectedOptionId;
  final Map<String, String> _answers = {}; // questionId -> optionId
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _isFinished = false;
  int _score = 0;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.quizId != null) {
      _fetchQuiz();
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchQuiz() async {
    final data = await supabase
        .from('quizzes')
        .select('*, quiz_questions(*, quiz_options(*))')
        .eq('id', widget.quizId!)
        .single();

    final quiz = Quiz.fromJson(data);
    _remainingSeconds = quiz.timeLimitSeconds;

    if (!mounted) return;
    setState(() {
      _quiz = quiz;
      _isLoading = false;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _finishQuiz();
        return;
      }
      setState(() {
        _remainingSeconds--;
      });
    });
  }

  String get _formattedTime {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _selectOption(String optionId) {
    setState(() {
      _selectedOptionId = optionId;
    });
  }

  void _nextQuestion() {
    if (_quiz == null) return;
    final questions = _quiz!.questions;
    if (_currentIndex >= questions.length) return;

    final question = questions[_currentIndex];
    if (_selectedOptionId != null) {
      _answers[question.id] = _selectedOptionId!;
    }

    if (_currentIndex < questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionId = _answers[questions[_currentIndex].id];
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    _timer?.cancel();
    if (_quiz == null) return;

    // Save last answer if not yet saved
    final questions = _quiz!.questions;
    if (_currentIndex < questions.length && _selectedOptionId != null) {
      _answers[questions[_currentIndex].id] = _selectedOptionId!;
    }

    // Calculate score
    int correct = 0;
    for (final question in questions) {
      final answered = _answers[question.id];
      final correctOption = question.options.where((o) => o.isCorrect).firstOrNull;
      if (answered != null && correctOption != null && answered == correctOption.id) {
        correct++;
      }
    }

    final totalQuestions = questions.length;
    final percentage = totalQuestions > 0 ? (correct / totalQuestions) * 100 : 0.0;
    final passed = percentage >= _quiz!.passingScore;

    // Submit to Supabase
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      final attemptData = await supabase.from('quiz_attempts').insert({
        'quiz_id': _quiz!.id,
        'user_id': userId,
        'score': percentage,
        'passed': passed,
      }).select().single();

      final attemptId = attemptData['id'] as String;

      final answerRows = _answers.entries.map((entry) => {
        'attempt_id': attemptId,
        'question_id': entry.key,
        'selected_option_id': entry.value,
      }).toList();

      if (answerRows.isNotEmpty) {
        await supabase.from('quiz_answers').insert(answerRows);
      }
    }

    if (!mounted) return;
    setState(() {
      _isFinished = true;
      _score = percentage.round();
      _correctCount = correct;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 80,
                left: 24,
                right: 24,
                bottom: 48,
              ),
              child: _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 80),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _isFinished
                      ? _buildResult()
                      : _buildQuizContent(),
            ),
          ),
          Positioned(top: 0, left: 0, right: 0, child: _buildHeader()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 96,
      padding: const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 15),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              Text(
                _quiz?.title ?? 'Quiz',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizContent() {
    if (_quiz == null || _quiz!.questions.isEmpty) {
      return const Center(child: Text('No questions available'));
    }

    final questions = _quiz!.questions;
    final question = questions[_currentIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildProgressAndTimer(questions.length),
        const SizedBox(height: 32),
        _buildQuestion(question),
        const SizedBox(height: 40),
        _buildOptions(question),
        const SizedBox(height: 32),
        _buildNextButton(),
      ],
    );
  }

  Widget _buildProgressAndTimer(int totalQuestions) {
    final progress = totalQuestions > 0 ? (_currentIndex + 1) / totalQuestions : 0.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'QUESTION',
              style: TextStyle(
                color: AppColors.onSurfaceVariant,
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  (_currentIndex + 1).toString().padLeft(2, '0'),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontFamily: 'Manrope',
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  ' / $totalQuestions',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                    fontFamily: 'Manrope',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: _remainingSeconds < 30
                        ? AppColors.error
                        : AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formattedTime,
                    style: TextStyle(
                      color: _remainingSeconds < 30
                          ? AppColors.error
                          : AppColors.primary,
                      fontFamily: 'Manrope',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 128,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
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
          ],
        ),
      ],
    );
  }

  Widget _buildQuestion(QuizQuestion question) {
    return Text(
      question.questionText,
      style: const TextStyle(
        color: AppColors.onSurface,
        fontFamily: 'Manrope',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
    );
  }

  Widget _buildOptions(QuizQuestion question) {
    final letters = ['A', 'B', 'C', 'D', 'E', 'F'];

    return Column(
      children: List.generate(question.options.length, (index) {
        final option = question.options[index];
        final isSelected = _selectedOptionId == option.id;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => _selectOption(option.id),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryContainer.withValues(alpha: 0.1)
                    : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryContainer
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      letters[index],
                      style: const TextStyle(
                        color: AppColors.primaryContainer,
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      option.optionText,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNextButton() {
    final questions = _quiz!.questions;
    final isLast = _currentIndex >= questions.length - 1;

    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _selectedOptionId != null ? _nextQuestion : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLast ? 'Finish Quiz' : 'Next Question',
                style: TextStyle(
                  color: _selectedOptionId != null
                      ? AppColors.onPrimary
                      : AppColors.onPrimary.withValues(alpha: 0.5),
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isLast ? Icons.check : Icons.arrow_forward,
                color: _selectedOptionId != null
                    ? AppColors.onPrimary
                    : AppColors.onPrimary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    if (_quiz == null) return const SizedBox.shrink();
    final totalQuestions = _quiz!.questions.length;
    final passed = _score >= _quiz!.passingScore;

    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: passed ? AppColors.tertiaryFixed : AppColors.error.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            passed ? Icons.check_circle : Icons.cancel,
            color: passed ? AppColors.tertiaryContainer : AppColors.error,
            size: 60,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          passed ? 'Congratulations!' : 'Keep Trying!',
          style: const TextStyle(
            color: AppColors.onSurface,
            fontFamily: 'Manrope',
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          passed ? 'You passed the quiz!' : 'You didn\'t pass this time',
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Score',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$_score%',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Correct Answers',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$_correctCount / $totalQuestions',
                    style: const TextStyle(
                      color: AppColors.tertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Passing Score',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${_quiz!.passingScore.round()}%',
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryContainer],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.of(context).pop(),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Back to Course',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontFamily: 'Manrope',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_back, color: AppColors.onPrimary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
