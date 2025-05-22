import 'package:flutter/material.dart';
import 'package:my_flutter_app/detailkampanye_screen.dart';
import 'package:my_flutter_app/jadwal_screen.dart';
import 'package:my_flutter_app/services/auth_services.dart';
import 'package:my_flutter_app/services/event_services.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentBannerIndex = 0;
  final AuthService authService = AuthService();
  final EventServices eventServices = EventServices();
  String userName = '';
  String profilePicture = '';
  String baseUrl = 'http://localhost:8080/api/file/';
  int totalPoint = 0;
  String alamat = '';
  List<String> skills = [];
  int volunteerCount = 0;

  List<dynamic> events = [];
  List<dynamic> eventSkills = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadEvents();
    _loadEventsSkill();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await authService.getUserProfile();
      setState(() {
        if (profile.containsKey('nama')) {
          userName = profile['nama'];
        }
        if (profile.containsKey('foto')) {
          profilePicture = profile['foto'];
        }
        if (profile.containsKey('alamat')) {
          alamat = profile['alamat'];
        }
        if (profile.containsKey('skills')) {
          // Extract the list of skills
          skills = (profile['skills'] as List)
              .map((skill) => skill['skill']['name'] as String)
              .toList();
        }
        if (profile.containsKey('_count') &&
            profile['_count'].containsKey('volunteers')) {
          volunteerCount = profile['_count']['volunteers'];
        }
      });
    } catch (e) {
      _showErrorDialog(
          'Gagal memuat profil pengguna. Silakan coba lagi nanti.');
    }
  }

  String get profilePicturePath {
    return profilePicture.isNotEmpty ? profilePicture.split('/').last : '';
  }

  String get fullProfilePictureUrl {
    return profilePicturePath.isNotEmpty ? '$baseUrl$profilePicturePath' : '';
  }

  String getImagePath(String imageUrl) {
    return imageUrl.isNotEmpty ? imageUrl.split('/').last : '';
  }

  String getFullImageUrl(String imageUrl) {
    final imagePath = getImagePath(imageUrl);
    return imagePath.isNotEmpty ? '$baseUrl$imagePath' : '';
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadEvents() async {
    try {
      final fetchedEvents = await eventServices.fetchEvents();
      setState(() {
        events = fetchedEvents.map((event) {
          final rawDate = event['start_date'];
          final formattedDate =
              DateFormat('dd MMMM yyyy').format(DateTime.parse(rawDate));
          return {
            'id': event['id'],
            'image': getFullImageUrl(event['image_url']),
            'title': event['title'],
            'location': event['location'],
            'start_date': formattedDate,
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      _showErrorDialog('Gagal memuat event. Silakan coba lagi nanti.');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadEventsSkill() async {
    try {
      final fetchedEventsSkill = await eventServices.fetchEventsSkill();
      setState(() {
        eventSkills = fetchedEventsSkill.map((eventSkills) {
          final skills = (eventSkills['skills'] as List)
              .map((skill) => skill['Skill']['name'] as String)
              .toList();

          final rawDate = eventSkills['start_date'];
          final formattedDate =
              DateFormat('dd MMMM yyyy').format(DateTime.parse(rawDate));
          return {
            'id': eventSkills['id'],
            'image': getFullImageUrl(eventSkills['image_url']),
            'title': eventSkills['title'],
            'location': eventSkills['location'],
            'max_volunteers': eventSkills['max_volunteers'],
            'volunteerCount': eventSkills['volunteerCount'],
            'skills': skills,
            'start_date': formattedDate,
            'raw_start_date': rawDate,
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      _showErrorDialog('Gagal memuat event. Silakan coba lagi nanti.');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 130,
                  child: Stack(
                    children: [],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, $userName!',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMainBanner(),
                      const SizedBox(height: 16),
                      _buildPoinSection(context),
                      const SizedBox(height: 24),
                      const Text(
                        'Rekomendasi untukmu',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildRekomendasiHorizontalList(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -10,
            left: -23,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo_apps.png',
                    height: 170,
                    width: 170,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications_none,
                      color: Colors.black, size: 28),
                  const SizedBox(width: 12),
                  const Icon(Icons.history, color: Colors.black, size: 28),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: profilePicturePath.isNotEmpty
                        ? NetworkImage('$baseUrl$profilePicturePath')
                        : const AssetImage('assets/profile_picture.jpg')
                            as ImageProvider,
                    child: profilePicturePath.isNotEmpty
                        ? null
                        : const Icon(Icons.person, size: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMainBanner() {
    if (events.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Icon(
              Icons.event_busy,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Tidak ada event tersedia saat ini',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: events.length,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = events[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailkampanyeScreen(
                        eventId: banner['id'],
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Image.network(
                        banner['image']!,
                        fit: BoxFit.cover,
                        height: 250,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey,
                          child: const Icon(Icons.broken_image,
                              color: Colors.white),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              banner['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${banner['location']!}, ${banner['start_date']!}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Lihat detail',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            events.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentBannerIndex == index ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPoinSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(
            context,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/asset_poin.png'),
                  width: 40.0,
                  height: 40.0,
                ),
                const SizedBox(width: 8.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Poin Relawan',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '$totalPoint Poin',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        const SizedBox(width: 3.0),
        Expanded(
          child: _buildInfoItem(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kampanye selesai',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4.0),
                Text(
                  '$volunteerCount Kampanye',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, Widget contentWidget,
      {Border? border, BorderRadius? borderRadius}) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: border,
        borderRadius: borderRadius,
      ),
      child: contentWidget,
    );
  }

  Widget _buildRekomendasiHorizontalList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (eventSkills.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Icon(
              Icons.search_off,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Tidak ada rekomendasi saat ini.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 350,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: eventSkills.length,
        itemBuilder: (context, index) {
          final event = eventSkills[index];

          final startDate = DateTime.parse(event['raw_start_date']);
          final now = DateTime.now().toUtc().add(const Duration(hours: 7));
          final difference = startDate.difference(now).inDays;
          final badgeText = '$difference hari lagi';

          return _buildRekomendasiCard(
            image: event['image'],
            title: event['title'],
            location: event['location'],
            tags: event['skills'],
            progress: '${event['volunteerCount']}/${event['max_volunteers']}',
            badgeText: badgeText,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailkampanyeScreen(
                    eventId: event['id'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRekomendasiCard({
    required String image,
    required String title,
    required String location,
    required List<String> tags,
    required String progress,
    String? badgeText,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 290,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ),
                if (badgeText != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: Colors.blue, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            badgeText,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(106, 114, 130, 1),
                      )),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: tags
                        .map((tag) => Chip(
                              label: Text(tag,
                                  style: const TextStyle(fontSize: 10)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              backgroundColor:
                                  const Color.fromRGBO(136, 214, 255, 1),
                              labelStyle:
                                  const TextStyle(color: Colors.black87),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Relawan bergabung',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(
                        progress,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(7, 122, 255, 1)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _parseProgress(progress),
                      minHeight: 6,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _parseProgress(String progress) {
    final parts = progress.split('/');
    if (parts.length == 2) {
      final current = int.tryParse(parts[0]) ?? 0;
      final total = int.tryParse(parts[1]) ?? 1;
      return current / total;
    }
    return 0.0;
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const JadwalScreen(),
        ),
      );
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      items: [
        _buildNavItem(Icons.home, 'Beranda', 0),
        _buildNavItem(Icons.calendar_today, 'Jadwal', 1),
        _buildNavItem(Icons.volunteer_activism, 'Kampanye', 2),
        _buildNavItem(Icons.group, 'Komunitas', 3),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.grey,
        ),
      ),
      label: label,
    );
  }
}
