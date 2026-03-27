import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/saree_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SareeProvider()),
      ],
      child: const SareeApp(),
    ),
  );
}

class SareeApp extends StatelessWidget {
  const SareeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SareeStream',
      theme: ThemeData(
        primaryColor: const Color(0xFF4A0404),
        scaffoldBackgroundColor: const Color(0xFFFFFDF8),
         colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A0404),
          primary: const Color(0xFF4A0404),
          secondary: const Color(0xFFD4AF37),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
