import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {
  final bool hasBackButton;

  const CustomAppBar({super.key, this.hasBackButton = false});

  @override
  Widget build(BuildContext context) {
    final double topSafeAreaHeight = MediaQuery.of(context).padding.top;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            Container(
              height: topSafeAreaHeight + 55,
              color: const Color(0xFF1C1B1F),
              child: Padding(
                padding: EdgeInsets.only(top: topSafeAreaHeight),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (hasBackButton)
                      IconButton(
                        iconSize: 30.0,
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    else
                      IconButton(
                        iconSize: 30.0,
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () { },
                      ),
                    IconButton(
                      iconSize: 30.0,
                      icon: const Icon(Icons.account_circle, color: Colors.white),
                      onPressed: () { },
                    ),
                  ],
                ),
              ),
            ),
            // Espaçador
            const SizedBox(height: 1),
            Container(
              height: 75,
              color: const Color(0xFF1C1B1F),
              child: Center(
                child: Text(
                  'RICK AND MORTY API',
                  style: GoogleFonts.lato(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: (topSafeAreaHeight + 55) - (80 / 2),
          child: SizedBox(
            height: 80,
            child: Image.asset('assets/logo4.png'),
          ),
        ),
      ],
    );
  }
}
