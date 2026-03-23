import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
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
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );
      print(response.body);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/icons/logo_genshin_import.svg',
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              'Register',
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
                      if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      return null;
                    },
                    obscureText: _isObscurePassword,
                    decoration: InputDecoration(
                      labelText: "Your Password",
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
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password can't be empty";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      if (value != _passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    obscureText: _isObscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(fontFamily: 'Hywenhei'),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscureConfirmPassword =
                                !_isObscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Register",
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
                        "Do you have an account?",
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                            "Login here",
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
