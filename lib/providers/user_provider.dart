import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(name: '', email: '');
  bool _isLoading = true;
  bool _isDarkMode = false;
  int _visitCount = 0;
  List<String> _favorites = [];

  // Getter untuk mengakses nilai dari luar
  User get user => _user;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  int get visitCount => _visitCount;
  List<String> get favorites => _favorites;

  UserProvider() {
    _loadPreferences();
  }

  // Memuat data dari SharedPreferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? '';
    final email = prefs.getString('user_email') ?? '';
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    
    int currentCount = prefs.getInt('visit_count') ?? 0;
    currentCount++;
    await prefs.setInt('visit_count', currentCount);
    _visitCount = currentCount;

    _favorites = prefs.getStringList('favorites') ?? [];

    _user = User(name: name, email: email, isLoggedIn: isLoggedIn);
    _isLoading = false;
    notifyListeners(); // Beritahu widget bahwa data sudah dimuat
  }

  // Update Data User dengan Validasi Keamanan 
  Future<String?> updateUser(User newUser) async {
    final prefs = await SharedPreferences.getInstance();
    
    // a) Cek apakah nama mengandung karakter berbahaya (misalnya tag HTML / <script>)
    final dangerousPattern = RegExp(r'<[^>]*>|script', caseSensitive: false);
    if (dangerousPattern.hasMatch(newUser.name)) {
      return 'Error: Nama mengandung karakter atau tag yang tidak aman!';
    }

    // b) Cek apakah email sudah digunakan (simulasi pengecekan dengan SharedPreferences)
    final existingEmail = prefs.getString('user_email');
    if (existingEmail != null && existingEmail.isNotEmpty && existingEmail != _user.email && existingEmail == newUser.email) {
      return 'Error: Email tersebut sudah terdaftar/digunakan!';
    }

    _isLoading = true;
    notifyListeners();

    await prefs.setString('user_name', newUser.name);
    await prefs.setString('user_email', newUser.email);
    await prefs.setBool('is_logged_in', newUser.isLoggedIn);

    _user = newUser;
    _isLoading = false;
    notifyListeners();
    
    return null; // Berhasil, tidak ada error
  }

  // Toggle Theme (Dark Mode)
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = !_isDarkMode;
    await prefs.setBool('is_dark_mode', _isDarkMode);
    notifyListeners();
  }

  // Tambah Favorit
  Future<void> addFavorite(String item) async {
    if (item.trim().isEmpty) return;
    _favorites.add(item);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
    notifyListeners();
  }

  // Hapus Favorit
  Future<void> removeFavorite(int index) async {
    _favorites.removeAt(index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.setBool('is_logged_in', false);

    _user = _user.copyWith(name: '', isLoggedIn: false);
    notifyListeners();
  }
}