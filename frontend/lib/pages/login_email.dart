import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginEmailPage extends StatefulWidget {
  const LoginEmailPage({super.key});

  @override
  State<LoginEmailPage> createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Validasi apakah TextFormField kosong/tidak valid
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://URL_BACKEND/api/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login berhasil!')));
          // Navigator.pushReplacement(context, ...);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login gagal: Cek email atau password')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan jaringan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SvgPicture.asset(
              "assets/icons/logo_genshin_import.svg",
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              "Login",
              style: TextStyle(
                fontFamily: 'Hywenhei',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email can't be empty";
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@[\w-\.]');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(fontFamily: 'Hywenhei'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password can't be empty";
                      }
                      return null;
                    },
                    obscureText: _isObscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(fontFamily: 'Hywenhei'),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscurePassword = !_isObscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: 'Hywenhei',
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.blue,
                            ),
                          ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontFamily: 'Hywenhei',
                          fontSize: 12.0,
                          color: Colors.blue,
                        ),
                      ),
                      TextButton(
                        style:
                            TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                            ).copyWith(
                              overlayColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                            ),
                        onPressed: () {},
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 2),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: const Text(
                            "Register here",
                            style: TextStyle(
                              fontFamily: 'Hywenhei',
                              fontSize: 12.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Forgot your password?',
                        style: TextStyle(
                          fontFamily: 'Hywenhei',
                          fontSize: 12.0,
                          color: Colors.blue,
                        ),
                      ),
                      TextButton(
                        style:
                            TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                            ).copyWith(
                              overlayColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                            ),
                        onPressed: () {},
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 2),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: const Text(
                            "Change Password",
                            style: TextStyle(
                              fontFamily: 'Hywenhei',
                              fontSize: 12.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
