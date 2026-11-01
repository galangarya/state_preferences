import 'package:flutter/material.dart';
import '../providers/user_provider.dart';
import 'profile_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context); 
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              provider.toggleTheme();
            },
            tooltip: 'Ganti Tema',
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.home, size: 80, color: Colors.deepPurple),
                    const SizedBox(height: 24),
                    Text(
                      provider.user.isLoggedIn
                          ? 'Selamat datang, ${provider.user.name}!'
                          : 'Selamat datang, Tamu!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Aplikasi ini telah dibuka sebanyak ${provider.visitCount} kali.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    if (provider.user.isLoggedIn) ...[
                      Text(
                        'Email: ${provider.user.email}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.person),
                        label: const Text('Lihat Profil'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          provider.logout();
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text('Logout', style: TextStyle(color: Colors.red)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ] else ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.login),
                        label: const Text('Login / Daftar'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}