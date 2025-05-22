import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class EventServices {
  final String baseUrl = 'http://127.0.0.1:8080';

  Future<List<dynamic>> fetchEvents() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final url = Uri.parse('$baseUrl/api/event');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['events'] != null && data['events'] is List) {
        return data['events'] as List<dynamic>;
      } else {
        throw Exception('Format data tidak valid.');
      }
    } else {
      throw Exception('Gagal mengambil daftar event: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchEventsSkill() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final url = Uri.parse('$baseUrl/api/event/user-skills');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['events'] != null && data['events'] is List) {
        return data['events'] as List<dynamic>;
      } else {
        throw Exception('Format data tidak valid.');
      }
    } else {
      throw Exception('Gagal mengambil daftar event: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchEventById(int id) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/api/event/$id');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['event'] != null && data['event'] is Map<String, dynamic>) {
        return data['event'] as Map<String, dynamic>;
      } else {
        throw Exception('Format data tidak valid.');
      }
    } else {
      throw Exception('Gagal mengambil detail event: ${response.statusCode}');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> createVolunteer(int eventId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    // URL API
    final url = Uri.parse('$baseUrl/api/event/$eventId/volunteer');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Gagal membuat volunteer: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<dynamic>> fetchEventsVolunteer() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final url = Uri.parse('$baseUrl/api/event/upcoming');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['events'] != null && data['events'] is List) {
        return data['events'] as List<dynamic>;
      } else {
        throw Exception('Format data tidak valid.');
      }
    } else {
      throw Exception('Gagal mengambil daftar event: ${response.statusCode}');
    }
  }

  Future<void> changeStatus(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    // URL API
    final url = Uri.parse('$baseUrl/api/event/$id/volunteer/selesai');

    // Kirim permintaan POST ke API
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Gagal membuat volunteer: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> createReport(
      int eventId, Map<String, dynamic> reportData, String? filePath) async {
    final token = await _getToken();

    final url = Uri.parse('$baseUrl/api/event/$eventId/report');

    try {
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Authorization': 'Bearer $token',
        });

      reportData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (filePath != null) {
        final file = await http.MultipartFile.fromPath('photo', filePath);
        request.files.add(file);
      }

      // Kirim request
      final response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
      } else {
        try {
          final errorResponse = jsonDecode(responseBody);
          throw Exception(
              'Gagal membuat laporan: ${response.statusCode} - ${errorResponse['error'] ?? responseBody}');
        } catch (e) {
          throw Exception(
              'Gagal membuat laporan: ${response.statusCode} - $responseBody');
        }
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception(
          'Format respons tidak valid. Pastikan server mengembalikan JSON.');
    } catch (error) {
      throw Exception('Terjadi kesalahan saat membuat laporan.');
    }
  }
}
