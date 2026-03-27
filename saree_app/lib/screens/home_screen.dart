import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/saree_provider.dart';
import '../widgets/saree_card.dart';
import 'upload_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SareeProvider>(context, listen: false).fetchSarees());
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4A0404); // Deep Maroon
    const accentColor = Color(0xFFD4AF37); // Royal Gold

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      appBar: AppBar(
        title: Text(
          'SareeStream',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: accentColor,
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: accentColor),
            onPressed: () => Provider.of<SareeProvider>(context, listen: false)
                .fetchSarees(),
          ),
        ],
      ),
      body: Consumer<SareeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          }
          if (provider.error.isNotEmpty) {
            return Center(child: Text('Error: ${provider.error}'));
          }
          if (provider.sarees.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: 80),
                  const SizedBox(height: 20),
                  Text('No sarees found in today\'s catalog.', style: GoogleFonts.inter(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: provider.sarees.length,
            itemBuilder: (context, index) {
              return SareeCard(saree: provider.sarees[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UploadScreen()),
        ),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add_photo_alternate, color: accentColor),
      ),
    );
  }
}
