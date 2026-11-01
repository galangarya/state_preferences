import 'package:flutter/material.dart';
import 'providers/user_provider.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
  Widget build(BuildContext context) {
    // Menggunakan ChangeNotifierProvider di root aplikasi[cite: 6]
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'State & Preferences',
            debugShowCheckedModeBanner: false,
            
            // Pengaturan Dark Mode secara dinamis
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}