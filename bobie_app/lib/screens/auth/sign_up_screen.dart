import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nisController = TextEditingController();
  final _namaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureKonfirmasi = true;
  String? _selectedGender;

  @override
  void dispose() {
    _nisController.dispose();
    _namaController.dispose();
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  void _onDaftar() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacementNamed(context, '/signin');
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
            bottom: -130,
            height: 1200,
            child: Transform.scale(
              scale: 1.05,
              child: Image.asset(
                'assets/images/bg_signup.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
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
                          controller: _namaController,
                          hint: 'Nama Lengkap',
                          icon: Icons.person_outline,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Nama lengkap tidak boleh kosong' : null,
                        ),
                        const SizedBox(height: 16),
                        _GenderDropdown(
                          value: _selectedGender,
                          onChanged: (v) {
                            setState(() => _selectedGender = v);
                          },
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
                        const SizedBox(height: 16),
                        _InputField(
                          controller: _konfirmasiController,
                          hint: 'Konfirmasi Kata Sandi',
                          icon: Icons.lock_outline,
                          obscureText: _obscureKonfirmasi,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureKonfirmasi ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.darkGray,
                            ),
                            onPressed: () =>
                                setState(() => _obscureKonfirmasi = !_obscureKonfirmasi),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Konfirmasi kata sandi tidak boleh kosong';
                            if (v != _passwordController.text) return 'Kata sandi tidak cocok';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 160,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: _onDaftar,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              elevation: 2,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF4FA8DF), Color(0xFF2B5B79)],
                                ),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Daftar',
                                style: GoogleFonts.jua(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, '/signin'),
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.jua(fontSize: 13),
                              children: [
                                TextSpan(
                                  text: 'Sudah memiliki akun? ',
                                  style: TextStyle(color: AppColors.darkGray),
                                ),
                                TextSpan(
                                  text: 'Masuk',
                                  style: TextStyle(
                                    color: const Color(0xFFF4900C),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

class _GenderDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const _GenderDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        hint: Text(
          'Jenis Kelamin',
          style: GoogleFonts.jua(fontSize: 14, color: AppColors.gray),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          prefixIcon: Icon(Icons.wc, color: AppColors.darkGray, size: 20),
        ),
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.darkGray),
        style: GoogleFonts.jua(fontSize: 14, color: AppColors.black),
        items: const [
          DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
          DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
        ],
        onChanged: onChanged,
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
