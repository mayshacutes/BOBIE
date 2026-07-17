import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../widgets/primary_button.dart';

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
  String _selectedGender = 'Laki-laki';

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
      backgroundColor: AppColors.skyBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Image.asset(
                  'assets/images/logo_bobie.png',
                  width: 160,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LogoLetter('B', AppColors.logoPurple),
                      _LogoLetter('O', AppColors.logoBlue),
                      _LogoLetter('B', AppColors.logoPink),
                      _LogoLetter('i', AppColors.logoYellow),
                      _LogoLetter('e', AppColors.logoPurple),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Daftar Akun Siswa',
                  style: GoogleFonts.jua(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 24),
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
                  hint: 'Nama Siswa',
                  icon: Icons.person_outline,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Nama siswa tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.inputBg,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.wc, color: AppColors.darkGray, size: 22),
                      const SizedBox(width: 12),
                      Text(
                        'Jenis Kelamin',
                        style: GoogleFonts.jua(
                          fontSize: 15,
                          color: AppColors.gray,
                        ),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        value: _selectedGender,
                        underline: const SizedBox(),
                        style: GoogleFonts.jua(
                          fontSize: 15,
                          color: AppColors.black,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                          DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                        ],
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedGender = v);
                        },
                      ),
                    ],
                  ),
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
                PrimaryButton(
                  text: 'Daftar',
                  onPressed: _onDaftar,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/signin'),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.jua(fontSize: 14),
                      children: [
                        TextSpan(
                          text: 'Sudah punya akun? ',
                          style: TextStyle(color: AppColors.darkGray),
                        ),
                        TextSpan(
                          text: 'Masuk di sini',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoLetter extends StatelessWidget {
  final String letter;
  final Color color;

  const _LogoLetter(this.letter, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      letter,
      style: GoogleFonts.jua(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: color,
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
      style: GoogleFonts.jua(fontSize: 15, color: AppColors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.jua(fontSize: 15, color: AppColors.gray),
        prefixIcon: Icon(icon, color: AppColors.darkGray, size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}
