import 'package:flutter/material.dart';
import 'package:qr_master/constants/app_routes.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/onboarding_screen/onboarding_steps/index.dart';

class OnboardingSteps extends StatefulWidget {
  const OnboardingSteps({super.key});

  @override
  State<OnboardingSteps> createState() => _OnboardingStepsState();
}

class _OnboardingStepsState extends State<OnboardingSteps> {
  final PageController _pageController = PageController();
  final int _totalPages = 4;
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final storageService = StorageService();
    await storageService.setOnboardingCompleted(true);

    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              OnboardingStep1(),
              OnboardingStep2(),
              OnboardingStep3(),
              OnboardingStep4(),
            ],
          ),
        ),
        Column(
          children: [
            OnboardingStepsIndicator(
              currentPage: _currentPage,
              totalPages: _totalPages,
            ),
            const SizedBox(height: 21),
            OnboardingStepsActions(
              currentPage: _currentPage,
              totalPages: _totalPages,
              onNext: _nextPage,
              onSkip: _skipOnboarding,
            ),
          ],
        ),
      ],
    );
  }
}
