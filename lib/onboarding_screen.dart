import 'package:flutter/material.dart';
import 'package:my_flutter_app/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildOnboardingSlide(
                imagePath: 'assets/onboarding_slide1.png',
                title: 'Jadilah Bagian dari Perubahan Sosial',
                description:
                    'Jejak Relawan menghubungkanmu dengan berbagai kampanye sosial di sekitarmu. Temukan aksi nyata yang sesuai dengan keahlian dan waktumu!',
                size: size,
              ),
              _buildOnboardingSlide(
                imagePath: 'assets/onboarding_slide2.png',
                title: 'Kontribusi Nyata, Dampak Nyata',
                description:
                    'Setiap kontribusimu dicatat, dihargai poin, dan bisa dikonversi jadi sertifikat digital. Bangun portofolio kebaikanmu hari ini!',
                size: size,
              ),
              _buildOnboardingSlide(
                imagePath: 'assets/onboarding_slide3.png',
                title: 'Gabung Komunitas Relawan Hebat',
                description:
                    'Temui relawan lain, naikkan peringkat di leaderboard, dan rasakan semangat kolaborasi di setiap kampanye yang kamu ikuti!',
                size: size,
              ),
            ],
          ),
          Positioned(
            left: 0,
            child: Image.asset(
              'assets/logo_apps.png',
              height: size.height * 0.2,
              width: size.width * 0.35,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.02,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Icon(
                          Icons.circle,
                          size: 10,
                          color:
                              _currentPage == index ? Colors.blue : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: size.height * 0.05),
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage < 2) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        _currentPage < 2 ? 'Selanjutnya' : 'Selesai',
                        style: TextStyle(
                          fontSize: size.height * 0.02,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingSlide({
    required String imagePath,
    required String title,
    required String description,
    required Size size,
  }) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.15),
          Center(
            child: Image.asset(
              imagePath,
              height: size.height * 0.4,
              width: size.width * 0.8,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            title,
            style: TextStyle(
              fontSize: size.height * 0.03,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            description,
            style: TextStyle(
              fontSize: size.height * 0.02,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
