import 'package:flutter/material.dart';
import 'package:my_flutter_app/services/event_services.dart';

class KonfirmasiScreen extends StatefulWidget {
  final int eventId; // Tambahkan parameter eventId

  const KonfirmasiScreen({super.key, required this.eventId});

  @override
  State<KonfirmasiScreen> createState() => _KonfirmasiScreenState();
}

class _KonfirmasiScreenState extends State<KonfirmasiScreen> {
  final EventServices _eventServices =
      EventServices(); // Ganti dengan base URL Anda
  bool _bersediaHadir = false;
  bool _sehatFisikMental = false;
  bool _siapBriefing = false;
  bool _patuhiAturanPanduan = false;
  bool _pendaftaranBerhasil =
      false; // State baru untuk mengontrol tampilan sukses

  bool _isFormValid() {
    return _bersediaHadir &&
        _sehatFisikMental &&
        _siapBriefing &&
        _patuhiAturanPanduan;
  }

  late Future<Map<String, dynamic>> _eventDetails;
  final String baseUrl = 'http://localhost:8080/api/file/';

  @override
  void initState() {
    super.initState();
    _eventDetails = fetchEventDetails(); // Panggil fungsi untuk mengambil data
  }

  Future<Map<String, dynamic>> fetchEventDetails() async {
    final eventServices = EventServices(); // Instansiasi EventServices
    return await eventServices.fetchEventById(widget.eventId);
  }

  String getImagePath(String imageUrl) {
    return imageUrl.isNotEmpty
        ? imageUrl.split('/').last // Ekstrak bagian terakhir dari URL
        : '';
  }

  String getFullImageUrl(String imageUrl) {
    final imagePath = getImagePath(imageUrl);
    return imagePath.isNotEmpty
        ? '$baseUrl$imagePath' // Gabungkan base URL dengan path
        : ''; // Fallback jika URL kosong
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
        title: Text(
          _pendaftaranBerhasil
              ? 'Konfirmasi pendaftaran'
              : 'Konfirmasi pendaftaran', // Judul app bar bisa sama atau berbeda
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _pendaftaranBerhasil
          ? _buildPendaftaranBerhasilView(
              context) // Tampilkan view sukses jika pendaftaran berhasil
          : _buildKonfirmasiForm(
              context), // Tampilkan form konfirmasi jika belum berhasil
    );
  }

  // Widget untuk membangun form konfirmasi
  Widget _buildKonfirmasiForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: _eventDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 220,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return const SizedBox(
                  height: 220,
                  child: Center(child: Text('Gagal memuat gambar')),
                );
              } else if (snapshot.hasData) {
                final imageUrl = snapshot.data?['image_url'] ?? '';
                final fullImageUrl = getFullImageUrl(imageUrl);
                return Image.network(
                  fullImageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 220,
                      child: Center(child: Text('Gambar tidak tersedia')),
                    );
                  },
                );
              } else {
                return const SizedBox(
                  height: 220,
                  child: Center(child: Text('Tidak ada data')),
                );
              }
            },
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Konfirmasi Kesiapan Relawan',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24.0),
                _buildCheckboxQuestion(
                  questionNumber: 1,
                  question: 'Saya bersedia hadir di lokasi sesuai jadwal',
                  value: _bersediaHadir,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _bersediaHadir = newValue ?? false;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                _buildCheckboxQuestion(
                  questionNumber: 2,
                  question: 'Saya dalam kondisi sehat secara fisik dan mental',
                  value: _sehatFisikMental,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _sehatFisikMental = newValue ?? false;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                _buildCheckboxQuestion(
                  questionNumber: 3,
                  question:
                      'Saya siap mengikuti briefing teknis sebelum bertugas',
                  value: _siapBriefing,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _siapBriefing = newValue ?? false;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                _buildCheckboxQuestion(
                  questionNumber: 4,
                  question: 'Saya akan mematuhi aturan dan panduan relawan',
                  value: _patuhiAturanPanduan,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _patuhiAturanPanduan = newValue ?? false;
                    });
                  },
                ),
                const SizedBox(height: 22.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid()
                        ? () async {
                            try {
                              // Panggil fungsi createVolunteer
                              await _eventServices.createVolunteer(widget.eventId);

                              // Pastikan widget masih mounted sebelum melakukan operasi terkait UI
                              if (!mounted) return;

                              // Jika berhasil, set state untuk menampilkan view sukses
                              setState(() {
                                _pendaftaranBerhasil = true;
                              });
                            } catch (e) {
                              // Pastikan widget masih mounted sebelum menampilkan pesan error
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(7, 122, 255, 1),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
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
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membangun tampilan "Pendaftaran Berhasil"
  Widget _buildPendaftaranBerhasilView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(), // Dorong konten ke tengah vertikal

          const Text(
            'Pendaftaran berhasil',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Terima kasih telah mendaftar! Sampai jumpa di hari pelaksanaan tugas, ya!',
            style: TextStyle(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(), // Dorong konten ke tengah vertikal

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Kembali ke layar sebelumnya (misalnya Home Screen)
                Navigator.popUntil(context, (route) => route.isFirst);
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
                'Selesai',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 40.0), // Padding bawah untuk tombol
        ],
      ),
    );
  }

  Widget _buildCheckboxQuestion({
    required int questionNumber,
    required String question,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$questionNumber. $question',
          style: const TextStyle(fontSize: 16.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => onChanged(true),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: value,
                    onChanged: onChanged,
                    activeColor: const Color.fromRGBO(7, 122, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                  ),
                  const Text('Ya'),
                ],
              ),
            ),
            InkWell(
              onTap: () => onChanged(false),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: !value,
                    onChanged: (newValue) => onChanged(!newValue!),
                    activeColor: const Color.fromRGBO(7, 122, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                  ),
                  const Text('Tidak'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
