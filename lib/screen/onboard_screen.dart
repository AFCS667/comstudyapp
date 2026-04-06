import 'package:flutter/material.dart';
import 'package:comstudyapp/screen/signup_screen.dart';

const Color kPrimaryColor = Color(0xFF1E3A8A);
const Color kInactiveDotColor = Color(0xFFD1D5DB);

class OnboardingData {
  final String image;
  final String title;
  final String description;
  final String? labelText;
  final Color? labelColor;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
    this.labelText,
    this.labelColor,
  });
}

final List<OnboardingData> onboardingPagesData = [
  OnboardingData(
    image: 'assets/images/gambaronboard1.png',
    title: 'Curated Courses',
    description:
        'Access a library of knowledge hand-picked by experts to accelerate your growth.',
    labelText: 'HAND-PICKED',
    labelColor: const Color(0xFF4ADE80),
  ),
  OnboardingData(
    image: 'assets/images/gambaronboard2.png',
    title: 'Engage in Discussion',
    description:
        'Connect with fellow learners, share insights, and get answers in our active community.',
  ),
  OnboardingData(
    image: 'assets/images/gambaronboard3.png',
    title: 'Meet & Track Progress',
    description:
        'Join local meetups and monitor your learning journey with our powerful tracking tools.',
    labelText: 'GOAL REACHED',
    labelColor: Colors.black, // Hitam di label
  ),
];

class OnboardingPageContent extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPageContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Gambar Utama
            Image.asset(data.image, height: 250, fit: BoxFit.contain),
            if (data.labelText != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: data.labelColor ?? Colors.grey,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    data.labelText!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 48),
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor, // Biru tua
          ),
        ),
        const SizedBox(height: 16),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < onboardingPagesData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SignUpScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    }
  }

  void _skipOnboarding() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingPagesData.length,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPageContent(
                      data: onboardingPagesData[index],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    onboardingPagesData.length,
                    (index) => Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? kPrimaryColor
                            : kInactiveDotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _currentIndex == onboardingPagesData.length - 1
                      ? SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : _currentIndex == 1
                      ? SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : TextButton.icon(
                          onPressed: _nextPage,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text(
                            'Next',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: kPrimaryColor,
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
