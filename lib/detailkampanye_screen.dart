import 'package:flutter/material.dart';
import 'package:my_flutter_app/konfirmasi_screen.dart';

class DetailkampanyeScreen extends StatelessWidget {
  const DetailkampanyeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Aksi saat tombol kembali ditekan
            Navigator.pop(context);
          },
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Detail kampanye',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Gambar Kampanye
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
                  // Logo BPBD dan Nama Organisasi
                  Row(
                    children: [
                      Image.asset(
                        'assets/bpbd-solo.png',
                        width: 40.0,
                        height: 40.0,
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        'BPBD Kota Surakarta',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color.fromRGBO(106, 114, 130, 1),
                        ),
                      ),
                    ],
                  ),
                  // Judul Kampanye
                  const Text(
                    'Pendamping Lansia Pasca Banjir',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),

                  // Lokasi Kampanye
                  const Text(
                    'Kelurahan Joyosuran, Surakarta',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),

                  // Tanggal Kampanye
                  const Text(
                    '31 Mei - 2 Juni 2025',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),

                  // Relawan bergabung
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Relawan bergabung',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        '12/20',
                        style: TextStyle(
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

                  // Perolehan poin
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Perolehan poin',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Image(
                            image: AssetImage('assets/asset_poin.png'),
                            width: 25.0,
                            height: 25.0,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            '500 Poin',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  // Deskripsi Tugas
                  const Text(
                    'Deskripsi tugas',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  const Text(
                    'Banjir yang melanda Surakarta menyisakan tantangan besar bagi para lansia, terutama yang tinggal sendiri atau memiliki keterbatasan fisik. Sebagai relawan, kamu akan:',
                    style: TextStyle(fontSize: 16.0, height: 1.5),
                  ),
                  const SizedBox(height: 8.0),
                  _buildBulletPoint(
                      'Mendampingi lansia dalam aktivitas harian ringan'),
                  _buildBulletPoint(
                      'Menyalurkan makanan, vitamin, dan kebutuhan dasar'),
                  _buildBulletPoint(
                      'Menjadi teman bicara dan penyemangat pasca bencana'),
                  _buildBulletPoint(
                      'Membantu koordinasi dengan tenaga medis bila dibutuhkan'),
                  const SizedBox(height: 10.0),

                  // Syarat Keahlian
                  const Text(
                    'Syarat keahlian',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  const Text(
                    'Tidak harus berlatar belakang medis, cukup punya empati, kesabaran, dan kemampuan komunikasi yang baik.',
                    style: TextStyle(fontSize: 16.0, height: 1.5),
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
            16.0, 0, 16.0, 40.0), 
        child: ElevatedButton(
          onPressed: () {
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const KonfirmasiScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(
                7, 122, 255, 1), 
            foregroundColor: Colors.white, 
            minimumSize: const Size(
                double.infinity, 50), 
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

  // Widget untuk membuat bullet point
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
