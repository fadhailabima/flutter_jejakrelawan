import 'package:flutter/material.dart';
import 'package:my_flutter_app/dashboard_screen.dart';
import 'package:my_flutter_app/services/auth_services.dart';
import 'package:my_flutter_app/services/event_services.dart';
import 'package:intl/intl.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  final AuthService authService = AuthService();
  final EventServices eventServices = EventServices();
  String profilePicture = '';
  String baseUrl = 'http://localhost:8080/api/file/';

  List<dynamic> upcomingEvents = []; // Renamed for clarity
  List<dynamic> completedEvents = [];
  bool isLoading = true;

  int _selectedTab = 0; // 0 for "Mendatang", 1 for "Selesai"

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadEvents();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await authService.getUserProfile();
      setState(() {
        if (profile.containsKey('foto')) {
          profilePicture = profile['foto'];
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
    setState(() {
      isLoading = true; // Set loading to true when fetching
    });
    try {
      final fetchedEvents = await eventServices.fetchEventsVolunteer();
      setState(() {
        // Filter for "Mendatang" (Upcoming) events
        upcomingEvents = fetchedEvents
            .where((event) =>
                event['volunteers'] != null &&
                event['volunteers'].isNotEmpty &&
                event['volunteers'][0]['status'] == 'Mendatang')
            .map((event) {
          final rawDate = event['start_date'];
          final rawEndDate = event['end_date'];
          final formattedEndDate =
              DateFormat('dd MMMM yyyy').format(DateTime.parse(rawEndDate));
          final formattedDate =
              DateFormat('dd MMMM yyyy').format(DateTime.parse(rawDate));

          return {
            'id': event['id'],
            'title': event['title'],
            'location': event['location'],
            'start_date': formattedDate,
            'end_date': formattedEndDate,
            'status': event['status'],
            'volunteer_status': event['volunteers'][0]['status'],
          };
        }).toList();

        // Filter for "Selesai" (Completed) events
        completedEvents = fetchedEvents
            .where((event) =>
                event['volunteers'] != null &&
                event['volunteers'].isNotEmpty &&
                event['volunteers'][0]['status'] == 'Selesai')
            .map((event) {
          final rawDate = event['start_date'];
          final rawEndDate = event['end_date'];
          final formattedEndDate =
              DateFormat('dd MMMM yyyy').format(DateTime.parse(rawEndDate));
          final formattedDate =
              DateFormat('dd MMMM yyyy').format(DateTime.parse(rawDate));

          return {
            'id': event['id'],
            'title': event['title'],
            'location': event['location'],
            'start_date': formattedDate,
            'end_date': formattedEndDate,
            'status': event['status'],
            'volunteer_status': event['volunteers'][0]['status'],
          };
        }).toList();
        isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      _showErrorDialog('Gagal memuat event. Silakan coba lagi nanti.');
      setState(() {
        isLoading = false; // Set loading to false on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine which list of events to display based on the selected tab
    List<dynamic> currentEvents =
        _selectedTab == 0 ? upcomingEvents : completedEvents;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tab buttons "Mendatang" and "Selesai"
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTab = 0;
                                  // No need to call _loadEvents() again, data is already filtered
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                  color: _selectedTab == 0
                                      ? const Color.fromRGBO(136, 214, 255, 1.0)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Mendatang',
                                  style: TextStyle(
                                    color: _selectedTab == 0
                                        ? Colors.black
                                        : const Color.fromRGBO(
                                            74, 85, 101, 1.0),
                                    fontWeight: _selectedTab == 0
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTab = 1;
                                  // No need to call _loadEvents() again, data is already filtered
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                  color: _selectedTab == 1
                                      ? const Color(0xFFC7E5FF)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Selesai',
                                  style: TextStyle(
                                    color: _selectedTab == 1
                                        ? Colors.black
                                        : const Color.fromRGBO(
                                            74, 85, 101, 1.0),
                                    fontWeight: _selectedTab == 1
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Conditional display based on loading state and event lists
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : currentEvents.isEmpty
                              ? Center(
                                  child: Text(
                                    _selectedTab == 0
                                        ? 'Tidak ada jadwal mendatang.'
                                        : 'Tidak ada jadwal selesai.',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(106, 114, 130, 1),
                                    ),
                                  ),
                                )
                              : Transform.translate(
                                  offset: const Offset(0, -50),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: currentEvents.length,
                                    itemBuilder: (context, index) {
                                      final event = currentEvents[index];
                                      return _buildEventCard(event);
                                    },
                                  ),
                                ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Posisi header fixed kiri atas (remains unchanged)
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

  // Helper method to build an event card
  Widget _buildEventCard(Map<String, dynamic> event) {
    DateTime startDate = DateFormat('dd MMMM yyyy')
        .parse(event['start_date']); // Parsing dari String ke DateTime
    DateTime endDate = DateFormat('dd MMMM yyyy')
        .parse(event['end_date']); // Parsing dari String ke DateTime
    DateTime now = DateTime.now();

    // Determine the status based on the current date
    String status;
    if (now.isBefore(startDate)) {
      status = 'Belum berjalan';
    } else if (now.isAfter(endDate)) {
      status = 'Selesai';
    } else {
      status = 'Sedang berjalan';
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Colors.grey, // Warna border
          width: 1.0, // Ketebalan border
        ),
      ),
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16), // Added margin for spacing
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(16, 24, 40, 1),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              event['location'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(106, 114, 130, 1),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${event['start_date']} - ${event['end_date']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(106, 114, 130, 1),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  // Display the event's general status or volunteer status if preferred
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(106, 114, 130, 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // "Tandai selesai" button only for "Mendatang" events
            if (event['volunteer_status'] == 'Mendatang')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      // Panggil fungsi untuk menandai selesai dengan event['id']
                      await eventServices.changeStatus(event['id']);

                      // Pastikan widget masih mounted sebelum melakukan operasi terkait UI
                      if (!mounted) return;

                      // Jika berhasil, set state untuk memperbarui status
                      setState(() {
                        status = 'Selesai';
                      });

                      // Tampilkan pesan sukses
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Berhasil menandai selesai'),
                        ),
                      );
                    } catch (e) {
                      // Tangani error jika terjadi
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal menandai selesai: $e'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(7, 122, 255, 1),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Tandai selesai',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else if (event['volunteer_status'] == 'Selesai')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman isi laporan
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IsiLaporanScreen(eventId: event['id']),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 200, 83, 1), // Warna hijau
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Isi Laporan',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: const Color(0xFF0D6EFD),
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
                color: const Color(0xFFC7E5FF),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF0D6EFD) : Colors.grey,
        ),
      ),
      label: label,
    );
  }
}
