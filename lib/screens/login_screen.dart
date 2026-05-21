import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/login_provider.dart';
import 'home_screen.dart';
import 'registration_screen.dart';
import '../widget/social_buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usuarioController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Fondo azul claro
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícono de candado
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2196F3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Título
                  const Text(
                    'Inicia sesión',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Subtítulo
                  const Text(
                    'Accede a tu cuenta',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Campo: Usuario
                  TextFormField(
                    controller: _usuarioController,
                    decoration: _buildInputDecoration(
                      label: 'Usuario',
                      icon: Icons.person_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu usuario';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: Correo electrónico
                  TextFormField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration(
                      label: 'Correo electrónico',
                      icon: Icons.mail_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu correo';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Correo no válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: Contraseña
                  TextFormField(
                    controller: _contrasenaController,
                    obscureText: _obscurePassword,
                    decoration: _buildInputDecoration(
                      label: 'Contraseña',
                      icon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu contraseña';
                      }
                      if (value.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botón: Ingresar
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await provider.login(
                                  _usuarioController.text.trim(),
                                  _correoController.text.trim(),
                                  _contrasenaController.text.trim(),
                                );

                                if (provider.isLoggedIn && mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomeScreen(),
                                    ),
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Ingresar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Mensaje de error
                  if (provider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        provider.errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Separador: "o continuar con"
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'o continuar con',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Botones sociales (Google y Facebook)
                  const SocialButtons(),
                  const SizedBox(height: 24),

                  // Link: ¿No tienes cuenta? Regístrate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿No tienes cuenta? ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegistrationScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Regístrate',
                          style: TextStyle(
                            color: Color(0xFF2196F3),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: Colors.grey),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}