import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lg_controller_app/services/datamethods.dart';
import 'package:lg_controller_app/services/providers/connection_provider.dart';
import 'package:lg_controller_app/services/providers/theme_provider.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  late final TextEditingController _usernameController;
  late final TextEditingController _ipController;
  late final TextEditingController _portController;
  late final TextEditingController _passwordController;
  late final TextEditingController _screensController;

  final _formKey = GlobalKey<FormState>();
  bool _isConnecting = false;


  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: 'lg');
    _ipController = TextEditingController();
    _portController = TextEditingController(text: '22');
    _passwordController = TextEditingController(text: 'lqgalaxy');
    _screensController = TextEditingController(text: '5');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _passwordController.dispose();
    _screensController.dispose();
    super.dispose();
  }

  void _connect() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isConnecting = true);

      String result = await Datamethods().connect(
        ip: _ipController.text,
        port: int.parse(_portController.text),
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        setState(() => _isConnecting = false);

        if (result == "Success") {
          ref.read(connectionProvider.notifier).setConnected(
                true,
                _ipController.text,
                _usernameController.text,
                _passwordController.text,
                int.parse(_portController.text),
                int.parse(_screensController.text),
              );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connected to Liquid Galaxy!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final primaryColor = Theme.of(context).primaryColor;
    final bgColor = themeState.isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = themeState.isDark ? Colors.white : Colors.black87;

    InputDecoration inputDecor(String label, IconData icon) {
      return InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey),
        prefixIcon: Icon(
          icon,
          color: primaryColor.withAlpha((0.7 * 255).toInt()),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.withAlpha((0.3 * 255).toInt()),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: themeState.isDark ? Colors.black12 : Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: primaryColor,
          iconSize: 30,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: primaryColor.withAlpha((0.1 * 255).toInt()),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Connection Details',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor.withAlpha((0.8 * 255).toInt()),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                style: GoogleFonts.poppins(color: textColor),
                decoration: inputDecor('Username', Icons.person_outline),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ipController,
                style: GoogleFonts.poppins(color: textColor),
                decoration: inputDecor('IP Address', Icons.wifi),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _portController,
                      style: GoogleFonts.poppins(color: textColor),
                      decoration: inputDecor('Port', Icons.lan),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _screensController,
                      style: GoogleFonts.poppins(color: textColor),
                      decoration: inputDecor('Screens', Icons.monitor),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                style: GoogleFonts.poppins(color: textColor),
                obscureText: true,
                decoration: inputDecor('Password', Icons.lock_outline),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _isConnecting ? null : _connect,
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isConnecting
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'CONNECT',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          themeState.isDark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          color: primaryColor.withAlpha((0.6 * 255).toInt()),
                          size: 20,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          themeState.isDark ? 'Dark Mode' : 'Light Mode',
                          style: GoogleFonts.poppins(
                            color: primaryColor.withAlpha((0.6 * 255).toInt()),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: themeState.isDark,
                      onChanged: (value) {
                        ref.read(themeProvider.notifier).toggleTheme();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}