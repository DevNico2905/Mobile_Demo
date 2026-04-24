import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),

      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}

class LoginProvider extends ChangeNotifier {
  String username = '';
  String email = '';
  String password = '';

  bool isLoading = false;
  bool obscurePassword = false;

  // Métodos para guardar

  // When user input data in the field this method will save
  void setUsername(String username) {
    username = username;
  }

  void setEmail(String email) {
    email = email;
  }

  void setPass(String pass) {
    password = pass;
  }

  void togglePassword() {
    obscurePassword = !obscurePassword;

    notifyListeners();
  }

  String? validatedUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'El usuario es obligatorio';
    }

    return null;
  }

  String? validatedEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es obligatorio';
    }

    return null;
  }

  String? validatedPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatorio';
    }

    return null;
  }

  //Login normal simulado
  Future<void> loginNormal(BuildContext context) async {
    isLoading = true;

    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;

    notifyListeners();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Se ha logeado $username')));
  }

  void loginGoogle(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Se ha logeado con Google')));
  }

  void loginFacebook(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Se ha logeado con Facebook')));
  }
}

// Pantalla del login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();
  }
}
