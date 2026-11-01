import 'package:flutter/material.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final TextEditingController _favoriteController = TextEditingController();

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final provider = Provider.of<UserProvider>(context);
      _nameController = TextEditingController(text: provider.user.name);
      _emailController = TextEditingController(text: provider.user.email);
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _favoriteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengguna & Favorit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // Menggunakan ListView agar bisa di-scroll jika panjang
          children: [
            // Form Edit Profil yang sudah ada sebelumnya
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                    validator: (value) =>
                        value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        value!.isEmpty ? 'Email tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // 2. Menangkap pesan error dari provider
                        String? errorMsg = await provider.updateUser(
                          User(
                            name: _nameController.text,
                            email: _emailController.text,
                            isLoggedIn: true,
                          ),
                        );

                        if (!context.mounted) return;

                        // 3. Logika pengecekan error atau sukses
                        if (errorMsg != null) {
                          // Jika ada error keamanan (nama mengandung script / email duplikat)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMsg),
                              backgroundColor:
                                  Colors.red, // SnackBar merah untuk error
                            ),
                          );
                        } else {
                          // Jika berhasil disimpan
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Profil berhasil disimpan secara aman!',
                              ),
                              backgroundColor:
                                  Colors.green, // SnackBar hijau untuk sukses
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Simpan Profil'),
                  ),
                ],
              ),
            ),

            const Divider(height: 40, thickness: 2),

            // --- TAMBAHAN BARU: Bagian Form & Daftar Favorit (Latihan 3) ---
            const Text(
              'Daftar Hobi / Favorit Saya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Form Input Favorit Baru
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _favoriteController,
                    decoration: const InputDecoration(
                      labelText: 'Tambah Favorit Baru',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_favoriteController.text.isNotEmpty) {
                      provider.addFavorite(_favoriteController.text);
                      _favoriteController.clear();
                    }
                  },
                  child: const Text('Tambah'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Menampilkan Daftar Favorit Menggunakan ListView / Column
            provider.favorites.isEmpty
                ? const Text(
                    'Belum ada item favorit yang ditambahkan.',
                    style: TextStyle(color: Colors.grey),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.favorites.length,
                    itemBuilder: (context, index) {
                      final item = provider.favorites[index];
                      return Card(
                        child: ListTile(
                          title: Text(item),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              provider.removeFavorite(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
            // -------------------------------------------------------------
          ],
        ),
      ),
    );
  }
}
