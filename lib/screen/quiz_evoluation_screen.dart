import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class QuizEvaluationScreen extends StatefulWidget {
  const QuizEvaluationScreen({super.key});

  @override
  State<QuizEvaluationScreen> createState() => _QuizEvaluationScreenState();
}

class _QuizEvaluationScreenState extends State<QuizEvaluationScreen> {
  int _selectedOptionIndex = 1; // "Sophisticated Layering" selected by default

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProgressAndTimer(),
                  const SizedBox(height: 32),
                  _buildQuestion(),
                  const SizedBox(height: 40),
                  _buildOptions(),
                  const SizedBox(height: 32),
                  _buildNextButton(),
                  const SizedBox(height: 24),
                  _buildScorePill(),
                ],
              ),
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
      padding: const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 16),
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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDZUrJUzjCsgWaY0cByfRIiABxQr5GGx7oZJhCoPHDA2JysyrnJOIkdULIptkFnXQasnA67EKDHvMfwkenYIjWVC7QvIOSJUCbbZd_J_8wDHdTgQphSUGl41IRRKGKZQ9KlYhStYaUXtjAr3RQY9PRFRO1_feOTapwhjxB1XGAViH6afH7jbBmIWdFHDMB3OWsaPI4zoO17PanXtYbheiZAYxEMMek5u1ea5YzOlus7jjbw-kLzui9WCLc14mNg9kY_Ijry1QyHgVNr',
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
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProgressAndTimer() {
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
                const Text(
                  '04',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontFamily: 'Manrope',
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  ' / 12',
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
                children: const [
                  Icon(Icons.schedule, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '00:45',
                    style: TextStyle(
                      color: AppColors.primary,
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
                widthFactor: 0.33,
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

  Widget _buildQuestion() {
    return const Text(
      'In the context of the Curatorial North Star, which design principle prioritizes "tonal depth" over structural lines?',
      style: TextStyle(
        color: AppColors.onSurface,
        fontFamily: 'Manrope',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
    );
  }

  Widget _buildOptions() {
    final options = [
      {'letter': 'A', 'text': 'Industrial Utility Grids'},
      {'letter': 'B', 'text': 'Sophisticated Layering'},
      {'letter': 'C', 'text': 'Monochromatic Flatness'},
      {'letter': 'D', 'text': 'Strict 1px Bordering'},
    ];

    return Column(
      children: List.generate(options.length, (index) {
        final isSelected = _selectedOptionIndex == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedOptionIndex = index;
              });
            },
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
                      options[index]['letter']!,
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
                      options[index]['text']!,
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
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Next Question',
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: AppColors.onPrimary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScorePill() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.tertiaryFixed,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.check_circle,
              color: AppColors.tertiaryContainer,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'SCORE: 320 PTS',
              style: TextStyle(
                color: AppColors.tertiaryContainer,
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
