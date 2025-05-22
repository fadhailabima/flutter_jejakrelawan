import 'package:flutter/material.dart';
import 'package:my_flutter_app/konfirmasi_screen.dart';
import 'package:my_flutter_app/services/event_services.dart';
import 'package:intl/intl.dart';

class DetailkampanyeScreen extends StatefulWidget {
  final int eventId;

  const DetailkampanyeScreen({super.key, required this.eventId});

  @override
  DetailkampanyeScreenState createState() => DetailkampanyeScreenState();
}

class DetailkampanyeScreenState extends State<DetailkampanyeScreen> {
  late Future<Map<String, dynamic>> _eventDetails;
  final String baseUrl = 'http://localhost:8080/api/file/';

  @override
  void initState() {
    super.initState();
    _eventDetails = fetchEventDetails();
  }

  Future<Map<String, dynamic>> fetchEventDetails() async {
    final eventServices = EventServices();
    return await eventServices.fetchEventById(widget.eventId);
  }

  String getImagePath(String imageUrl) {
    return imageUrl.isNotEmpty ? imageUrl.split('/').last : '';
  }

  String getFullImageUrl(String imageUrl) {
    final imagePath = getImagePath(imageUrl);
    return imagePath.isNotEmpty ? '$baseUrl$imagePath' : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detail Kampanye',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _eventDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final event = snapshot.data!;
            final rawStartDate = event['start_date'] ?? '';
            final rawEndDate = event['end_date'] ?? '';
            String formattedDateRange;
            if (rawStartDate.isNotEmpty && rawEndDate.isNotEmpty) {
              final startDate = DateTime.parse(rawStartDate);
              final endDate = DateTime.parse(rawEndDate);
              final sameMonth = startDate.month == endDate.month &&
                  startDate.year == endDate.year;

              final startFormat = DateFormat('d MMMM yyyy');
              final endFormat = sameMonth
                  ? DateFormat('d MMMM yyyy')
                  : DateFormat('d MMMM yyyy');

              formattedDateRange =
                  '${startFormat.format(startDate)} - ${endFormat.format(endDate)}';
            } else {
              formattedDateRange = 'Tanggal tidak tersedia';
            }

            final imageUrl = event['image_url'] ?? '';
            final organizerLogo = event['organizer_logo'] ?? '';
            final fullLogo = getFullImageUrl(organizerLogo);
            final fullImageUrl = getFullImageUrl(imageUrl);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    fullImageUrl,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              fullLogo,
                              width: 40.0,
                              height: 40.0,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              event['organizer'],
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Color.fromRGBO(106, 114, 130, 1),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          event['title'],
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          event['location'],
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          formattedDateRange,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Relawan bergabung',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              '${event['volunteerCount']}/${event['max_volunteers']}',
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: Color.fromRGBO(7, 122, 255, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: LinearProgressIndicator(
                            value: 12 / 20,
                            minHeight: 8.0,
                            backgroundColor: Colors.grey[200],
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Perolehan poin',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                const Image(
                                  image: AssetImage('assets/asset_poin.png'),
                                  width: 25.0,
                                  height: 25.0,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  '${event['point_reward']}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Deskripsi tugas',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            ..._buildDescription(event['description'] ??
                                'Deskripsi tidak tersedia.'),
                            const SizedBox(height: 10.0),
                          ],
                        ),
                        const Text(
                          'Syarat keahlian',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          event['requirements'],
                          style: const TextStyle(fontSize: 16.0, height: 1.5),
                        ),
                        const SizedBox(height: 30.0),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Tidak ada data.'));
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 40.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KonfirmasiScreen(eventId: widget.eventId),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(7, 122, 255, 1),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
          ),
          child: const Text(
            'Daftar',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDescription(String description) {
    final parts = description.split('\n•');
    final widgets = <Widget>[];

    if (parts.isNotEmpty) {
      widgets.add(
        Text(
          parts[0],
          style: const TextStyle(fontSize: 16.0, height: 1.5),
        ),
      );
    }

    for (var i = 1; i < parts.length; i++) {
      widgets.add(_buildBulletPoint(parts[i].trim()));
    }

    return widgets;
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16.0, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
