import 'package:flutter/material.dart';
import 'package:geekcontrol/core/utils/default_images.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2B34),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            Stack(
              alignment: Alignment.center,
              children: [
                // Banner
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(DefaultImages.bannerStr),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(DefaultImages.iconStr),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            const Center(
              child: Column(
                children: [
                  Text(
                    'Skynoshine',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Description here...',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('491', 'Mangás lidos', Icons.book),
                _buildStatCard('29', 'Animes', Icons.smart_button),
              ],
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8E1A3),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF6B9D9B),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
