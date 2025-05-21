import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventServices {
  final String baseUrl = 'http://127.0.0.1:8080';

  Future<List<dynamic>> fetchEvents() async {
    final token = await _getToken(); // Ambil token dari penyimpanan lokal
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
      // Decode JSON dari response.body
      final data = jsonDecode(response.body);
      if (data['events'] != null && data['events'] is List) {
        return data['events'] as List<dynamic>;
      } else {
        throw Exception('Format data tidak valid.');
      }
    } else {
      // Jika respons gagal, lemparkan exception
      throw Exception('Gagal mengambil daftar event: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchEventsSkill() async {
    final token = await _getToken(); // Ambil token dari penyimpanan lokal
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
      // Decode JSON dari response.body
      final data = jsonDecode(response.body);
      if (data['events'] != null && data['events'] is List) {
        return data['events'] as List<dynamic>;
      } else {
        throw Exception('Format data tidak valid.');
      }
    } else {
      // Jika respons gagal, lemparkan exception
      throw Exception('Gagal mengambil daftar event: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchEventById(int id) async {
    final token = await _getToken(); // Ambil token dari SharedPreferences
    final url =
        Uri.parse('$baseUrl/api/event/$id'); // Ganti dengan URL API Anda

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Sertakan token di header
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Decode JSON dari response.body
      final data = jsonDecode(response.body);
      if (data['event'] != null && data['event'] is Map<String, dynamic>) {
        return data['event'] as Map<String, dynamic>;
      } else {
        throw Exception('Format data tidak valid.');
      }
    } else {
      // Jika respons gagal, lemparkan exception
      throw Exception('Gagal mengambil detail event: ${response.statusCode}');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> createVolunteer(int eventId) async {
    final token = await _getToken(); // Ambil token dari penyimpanan lokal
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    // URL API
    final url = Uri.parse('$baseUrl/api/event/$eventId/volunteer');

    // Kirim permintaan POST ke API
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
    final token = await _getToken(); // Ambil token dari penyimpanan lokal
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
      // Decode JSON dari response.body
      final data = jsonDecode(response.body);
      if (data['events'] != null && data['events'] is List) {
        return data['events'] as List<dynamic>;
      } else {
        throw Exception('Format data tidak valid.');
      }
    } else {
      // Jika respons gagal, lemparkan exception
      throw Exception('Gagal mengambil daftar event: ${response.statusCode}');
    }
  }

  Future<void> changeStatus(int id) async {
    final token = await _getToken(); // Ambil token dari penyimpanan lokal
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
}
