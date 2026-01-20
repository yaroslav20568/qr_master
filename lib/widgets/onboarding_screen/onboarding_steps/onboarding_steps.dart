import 'package:flutter/material.dart';
import 'package:qr_master/constants/app_routes.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/utils/responsive_utils.dart';
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

    final authService = AuthService();
    final isAuthenticated = authService.isAuthenticated;

    final route = isAuthenticated ? AppRoutes.main : AppRoutes.auth;

    Navigator.of(context).pushReplacementNamed(route);
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
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(child: OnboardingStep1()),
                    ),
                  );
                },
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(child: OnboardingStep2()),
                    ),
                  );
                },
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(child: OnboardingStep3()),
                    ),
                  );
                },
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(child: OnboardingStep4()),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Builder(
          builder: (context) {
            final isSmallHeight = context.isSmallHeight;

            return Column(
              children: [
                if (!isSmallHeight) ...[
                  OnboardingStepsIndicator(
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                  ),
                ],
                SizedBox(height: !isSmallHeight ? 21 : 10),
                OnboardingStepsActions(
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                  onNext: _nextPage,
                  onSkip: _skipOnboarding,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
