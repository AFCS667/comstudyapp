import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Warna utama disamakan dengan desain
  final Color primaryColor = const Color(0xFF1E3A8A);
  bool _isTermsAccepted = false; // State untuk checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Menggunakan SafeArea agar tidak tertutup notch HP
      body: SafeArea(
        child: SingleChildScrollView(
          // Agar bisa di-scroll saat keyboard muncul
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Logo & Judul Aplikasi
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school,
                    color: primaryColor,
                  ), // Pakai icon bawaan dulu
                  const SizedBox(width: 8),
                  Text(
                    'Academic Atelier',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 2. Judul Halaman
              Text(
                'Join Us',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Subjudul
              const Text(
                'Begin your journey in our curated gallery of knowledge.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 40),

              // 4. Input Fields
              _buildInputField(
                label: 'Full Name',
                hint: 'Enter your full name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              _buildInputField(
                label: 'Email Address',
                hint: 'name@example.com',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              _buildInputField(
                label: 'Password',
                hint: 'Create a password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),

              _buildInputField(
                label: 'Confirm Password',
                hint: 'Repeat your password',
                icon: Icons.verified_user_outlined,
                isPassword: true,
              ),
              const SizedBox(height: 20),

              // 5. Checkbox Terms & Conditions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _isTermsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _isTermsAccepted = value ?? false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'I agree to the ',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 6. Tombol Sign Up
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Logika pendaftaran disini
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 7. Divider "OR JOIN WITH"
              Row(
                children: [
                  const Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR JOIN WITH',
                      style: TextStyle(
                        color: Color(0xFFF5F3F7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 24),

              // 8. Tombol Sosial (Google & Apple)
              Row(
                children: [
                  Expanded(
                    child: _buildSocialButton(
                      icon: Icons.g_mobiledata,
                      label: 'Google',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSocialButton(
                      icon: Icons.apple,
                      label: 'Apple',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 9. Link Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Nanti diarahkan ke halaman Login
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER: Input Field ---
  // Dibuat jadi fungsi terpisah agar kodenya tidak mengulang-ulang
  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.blue, size: 20),
            filled: true,
            fillColor: Color(0xFFF5F3F7), // Latar abu-abu sangat terang
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none, // Tanpa border sesuai desain
            ),
          ),
        ),
      ],
    );
  }

  // --- WIDGET HELPER: Social Button ---
  Widget _buildSocialButton({required IconData icon, required String label}) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.black87),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: Color(0xFFF5F3F7),
        side: BorderSide.none, // Menghilangkan garis pinggir
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
