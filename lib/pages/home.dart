import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lg_controller_app/services/datamethods.dart';

// FIX 1: Fixed the typo (comma changed to dot)
import 'package:lg_controller_app/services/providers/theme_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    // This watches the global provider from theme_provider.dart
    final themeState = ref.watch(themeProvider);
    
    final primaryColor = Theme.of(context).primaryColor;
    final bgColor = themeState.isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'LG Controller',
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // This toggles the global state
              ref.read(themeProvider).toggleTheme();
            },
            color: primaryColor,
            iconSize: 30,
            icon: const Icon(Icons.settings_outlined),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: primaryColor.withAlpha((0.2 * 255).toInt()),
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // --- ROW 1: Logo Controls ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SimpleMenuTile(
                  label: "SHOW LOGO", 
                  icon: Icons.tv, 
                  bgColor: bgColor,
                  onTap: () {Datamethods().sendLogo();},
                ),
                SimpleMenuTile(
                  label: "CLEAN LOGO", 
                  icon: Icons.tv_off, 
                  bgColor: bgColor,
                  onTap: () {Datamethods().cleanLogos();},
                ),
              ],
            ),
            
            // --- ROW 2: KML Controls ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SimpleMenuTile(
                  label: "3D PYRAMID", 
                  icon: Icons.change_history, 
                  bgColor: bgColor,
                  onTap: () {Datamethods().sendPyramid();},
                ),
                SimpleMenuTile(
                  label: "CLEAN KML", 
                  icon: Icons.clear_all, 
                  bgColor: bgColor,
                  onTap: () {Datamethods().cleanKMLs();},
                ),
              ],
            ),
            
            // --- ROW 3: Navigation ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SimpleMenuTile(
                  label: "FLY HOME", 
                  icon: Icons.flight_takeoff, 
                  bgColor: bgColor,
                  onTap: (){Datamethods().flyHome();},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleMenuTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bgColor;
  final VoidCallback onTap;

  const SimpleMenuTile({
    super.key,
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: 150,
      height: 140,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: primaryColor,
          width: 2.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 42, color: primaryColor),
              const SizedBox(height: 16),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}