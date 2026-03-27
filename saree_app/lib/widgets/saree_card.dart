import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../models/saree.dart';
import '../constants.dart';

class SareeCard extends StatelessWidget {
  final Saree saree;

  const SareeCard({super.key, required this.saree});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4A0404); // Deep Maroon
    const accentColor = Color(0xFFD4AF37); // Royal Gold

    final imageUrl = saree.image != null
        ? (saree.image!.startsWith('http')
            ? saree.image!
            : '${AppConstants.baseUrl}${saree.image}')
        : 'https://via.placeholder.com/300x400';

    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    imageUrl,
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '₹${saree.price}',
                      style: GoogleFonts.inter(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      saree.category,
                      style: GoogleFonts.inter(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Details Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        saree.name,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: primaryColor),
                        onPressed: () {
                           Share.share('Check out this beautiful saree: ${saree.name}\nFabric: ${saree.fabric}\nColor: ${saree.color}\nPrice: ₹${saree.price}\n\nShared via SareeStream');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                   Row(
                    children: [
                      _buildChip(Icons.texture, saree.fabric),
                      const SizedBox(width: 10),
                      _buildChip(Icons.palette, saree.color),
                      const SizedBox(width: 10),
                      _buildChip(Icons.inventory_2, 'Stock: ${saree.stock}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[800], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
