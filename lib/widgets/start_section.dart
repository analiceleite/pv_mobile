import 'package:flutter/material.dart';

class StartSection extends StatelessWidget {
  const StartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/background_shirlei.jpg',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                _buildButton('Cultos'),
                const SizedBox(height: 12),
                _buildButton('Grupos Familiares'),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://i.imgur.com/6YzWg9u.jpeg',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildButton('Cultos'),
                      const SizedBox(height: 12),
                      _buildButton('Grupos Familiares'),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }
}
