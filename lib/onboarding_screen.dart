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
    return Scaffold(
      body: Stack(
        children: [
          // PageView untuk slide onboarding
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              // Slide 1
              _buildOnboardingSlide(
                imagePath: 'assets/onboarding_slide1.png',
                title: 'Jadilah Bagian dari Perubahan Sosial',
                description:
                    'Jejak Relawan menghubungkanmu dengan berbagai kampanye sosial di sekitarmu. Temukan aksi nyata yang sesuai dengan keahlian dan waktumu!',
              ),
              // Slide 2
              _buildOnboardingSlide(
                imagePath: 'assets/onboarding_slide2.png',
                title: 'Kontribusi Nyata, Dampak Nyata',
                description:
                    'Setiap kontribusimu dicatat, dihargai poin, dan bisa dikonversi jadi sertifikat digital. Bangun portofolio kebaikanmu hari ini!',
              ),
              // Slide 3
              _buildOnboardingSlide(
                imagePath: 'assets/onboarding_slide3.png',
                title: 'Gabung Komunitas Relawan Hebat',
                description:
                    'Temui relawan lain, naikkan peringkat di leaderboard, dan rasakan semangat kolaborasi di setiap kampanye yang kamu ikuti!',
              ),
            ],
          ),

          // Logo di pojok kiri atas
          Positioned(
            top: 0, // Tambahkan jarak dari atas
            left: 0, // Tambahkan jarak dari kiri
            child: Image.asset(
              'assets/logo_apps.png',
              height: 170, // Sesuaikan ukuran logo jika terlalu besar
              width: 170, // Sesuaikan ukuran logo jika terlalu besar
            ),
          ),

          // Indikator dan tombol di bagian bawah
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: 10.0, // tambahkan bottom padding lebih besar
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Indikator titik
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: _currentPage == 0 ? Colors.blue : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: _currentPage == 1 ? Colors.blue : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: _currentPage == 2 ? Colors.blue : Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Tombol Selanjutnya
                  SizedBox(
                    width: double.infinity,
                    height: 50,
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
                        style: const TextStyle(
                          fontSize: 16,
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
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 150),
          Center(
            child: Image.asset(
              imagePath,
              height: 380,
              width: 380,
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -35),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
