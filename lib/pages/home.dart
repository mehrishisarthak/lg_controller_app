import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lg_controller_app/pages/settings.dart';
import 'package:lg_controller_app/services/datamethods.dart';
import 'package:lg_controller_app/services/providers/connection_provider.dart';
import 'package:lg_controller_app/services/providers/theme_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final connectionState = ref.watch(connectionProvider);
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Settings(),
              ));
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
            
            Container(
  width: double.infinity, // Takes full width for better alignment
  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
  decoration: BoxDecoration(
    color: connectionState.isConnectedStatus() ? Color.fromARGB(50, 0, 255, 0) : Color.fromARGB(50, 255, 0, 0),
    borderRadius: BorderRadius.circular(12.0),
    border: Border.all(
      color: primaryColor.withAlpha((0.2 * 255).toInt()),
      width: 1.0,
    ),
  ),
  child: Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withAlpha((0.1 * 255).toInt()),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.wifi,
          color: primaryColor,
          size: 20,
        ),
      ),
      const SizedBox(width: 16),
      
      // 4. Organize text with hierarchy (Label vs Value)
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONNECTION STATUS',
            style: GoogleFonts.poppins(
              color: primaryColor.withAlpha((0.6 * 255).toInt()),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            connectionState.displayIp(),
            style: GoogleFonts.poppins(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ],
  ),
),

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