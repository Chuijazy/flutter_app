import 'package:flutter/material.dart';
import 'package:flutter_app/core/app_colors.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<Onboarding> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Проверяйте свои знания',
      'description':
          'Проходите интерактивные тесты, чтобы закреплять материал и сразу видеть свои сильные и слабые стороны.',
      'image': 'assets/onboarding/onboard_image.png',
    },
    {
      'title': 'Учитесь по темам',
      'description':
          'Выбирайте интересующие темы и следите за прогрессом — занимайтесь тем, что нужно именно вам.',
      'image': 'assets/onboarding/onboard_image.png',
    },
    {
      'title': 'Проходи',
      'description':
          'Отвечайте на вопросы в формате игры с Kahoot. Учитесь весело и соревнуйтесь с другими!',
      'image': 'assets/onboarding/onboard_image.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          final page = _pages[index];

          return Column(
            children: [
              SizedBox(
                height: screenHeight * 0.75,
                width: double.infinity,
                child: Image.asset(page['image']!, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      page['title']!,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      page['description']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentIndex < _pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, '/auth');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 150,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Далее",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
