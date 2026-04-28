import 'package:flutter/material.dart';
import '../core/validators.dart' as validators;
import '../services/auth_service.dart';

class LoginProvider extends ChangeNotifier {
  String username = '';
  String email = '';
  String password = '';
  bool isLoading = false;
  bool obscurePassword = true;

  void setUsername(String value) => username = value;
  void setEmail(String value) => email = value;
  void setPassword(String value) => password = value;

  void togglePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  String? validateUsername(String? value) => validators.validateUsername(value);
  String? validateEmail(String? value) => validators.validateEmail(value);
  String? validatePassword(String? value) => validators.validatePassword(value);

  /// Intenta iniciar sesión. Devuelve true si las credenciales son correctas
  /// (usuario registrado y contraseña válida), false en caso contrario.
  Future<bool> loginNormal(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final ok = await AuthService.login(email: email.trim(), password: password);

    isLoading = false;
    notifyListeners();

    if (context.mounted) {
      if (ok) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Bienvenido, $username')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Credenciales incorrectas o no estás registrado. Regístrate primero.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    return ok;
  }

  void loginGoogle(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Se ha logeado con Google')));
  }

  void loginFacebook(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Se ha logeado con Facebook')));
  }
}
