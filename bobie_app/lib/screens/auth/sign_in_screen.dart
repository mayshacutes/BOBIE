import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../models/app_user.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _nisController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nisController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onMasuk() {
    if (_formKey.currentState?.validate() ?? false) {
      final user = findUser(_nisController.text.trim(), _passwordController.text);
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('NIS atau kata sandi salah')),
        );
        return;
      }
      Navigator.pushReplacementNamed(context, '/main', arguments: user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFFA3DEFA)),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 280,
            child: Image.asset(
              'assets/images/bg_signin.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 60, 32, 32),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/logo_bobie.png',
                          width: 150,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Text(
                            'BOBIe',
                            style: GoogleFonts.jua(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _InputField(
                          controller: _nisController,
                          hint: 'Nomor Induk Siswa',
                          icon: Icons.badge_outlined,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Nomor induk siswa tidak boleh kosong' : null,
                        ),
                        const SizedBox(height: 16),
                        _InputField(
                          controller: _passwordController,
                          hint: 'Kata Sandi',
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.darkGray,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Kata sandi tidak boleh kosong' : null,
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Lupa Password?',
                              style: GoogleFonts.jua(fontSize: 12, color: AppColors.darkGray),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 200,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: _onMasuk,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              'Masuk',
                              style: GoogleFonts.jua(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum memiliki akun? ',
                              style: GoogleFonts.jua(fontSize: 13, color: AppColors.darkGray),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/signup'),
                              child: Text(
                                'Registrasi',
                                style: GoogleFonts.jua(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFF4900C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: GoogleFonts.jua(fontSize: 14, color: AppColors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.jua(fontSize: 14, color: AppColors.gray),
        prefixIcon: Icon(icon, color: AppColors.darkGray, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
