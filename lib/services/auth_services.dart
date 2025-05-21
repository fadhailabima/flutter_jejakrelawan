import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> login(String identifier, String password) async {
    final url = Uri.parse('http://127.0.0.1:8080/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identifier': identifier,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Ambil accessToken dari objek tokens
      final accessToken = data['tokens']?['accessToken'];
      if (accessToken != null) {
        await _saveToken(accessToken); // Simpan token
        return true; // Login berhasil
      }
    }

    return false; // Login gagal
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final token = await _getToken(); // Ambil token dari penyimpanan lokal
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final url = Uri.parse('http://127.0.0.1:8080/api/auth/profile');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Uraikan JSON dari response.body
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // Jika respons gagal, lemparkan exception
      throw Exception(
          'Gagal mengambil profil pengguna: ${response.statusCode}');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token); // Save token to SharedPreferences
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // Retrieve token using the correct key
  }
}
