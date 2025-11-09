import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String routeName = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  final List<_OnboardingPage> _pages = const <_OnboardingPage>[
    _OnboardingPage(
      title: 'Personalised Quran Learning',
      description:
          'Map your learning path with curated lessons, live coaching, and AI-generated reflections tailored to your pace.',
      icon: Icons.auto_awesome,
      accentColor: Color(0xFF0F4C5C),
    ),
    _OnboardingPage(
      title: 'AI-Powered Recitation Coach',
      description:
          'Record your tilawah and receive instant grading aligned with tajweed, fluency, and melody benchmarks.',
      icon: Icons.graphic_eq,
      accentColor: Color(0xFFFA9F42),
    ),
    _OnboardingPage(
      title: 'Thriving Community Circles',
      description:
          'Join live halaqah circles, progress with peers, and celebrate weekly recitation streaks together.',
      icon: Icons.groups_rounded,
      accentColor: Color(0xFF2A9D8F),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (int index) => setState(() => _pageIndex = index),
                itemCount: _pages.length,
                itemBuilder: (BuildContext context, int index) {
                  final _OnboardingPage page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 72,
                          width: 72,
                          decoration: BoxDecoration(
                            color: page.accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(page.icon, color: page.accentColor, size: 36),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          page.title,
                          style: theme.textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          page.description,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Row(
                          children: List<Widget>.generate(
                            _pages.length,
                            (int indicatorIndex) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(right: 8),
                              height: 8,
                              width: indicatorIndex == _pageIndex ? 28 : 10,
                              decoration: BoxDecoration(
                                color: indicatorIndex == _pageIndex
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.primary.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        PrimaryButton(
                          label: _pageIndex == _pages.length - 1 ? 'Start Learning' : 'Next',
                          onPressed: () {
                            if (_pageIndex == _pages.length - 1) {
                              context.read<AppState>().completeOnboarding();
                            } else {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            TextButton(
              onPressed: () => context.read<AppState>().completeOnboarding(),
              child: const Text('Skip introduction'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
}
