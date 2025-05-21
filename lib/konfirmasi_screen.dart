import 'package:flutter/material.dart';

class KonfirmasiScreen extends StatefulWidget {
  const KonfirmasiScreen({super.key});

  @override
  State<KonfirmasiScreen> createState() => _KonfirmasiScreenState();
}

class _KonfirmasiScreenState extends State<KonfirmasiScreen> {
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
          Image.asset(
            'assets/card_pendampinglansia.jpg',
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
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
                        ? () {
                            setState(() {
                              _pendaftaranBerhasil =
                                  true; // Set state untuk menampilkan view sukses
                            });
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
