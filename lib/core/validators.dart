// Validadores reutilizables para formularios de autenticación.

final RegExp _emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

/// Valida que el correo tenga formato válido (usuario@dominio.extensión).
bool isValidEmail(String email) {
  return _emailRegex.hasMatch(email.trim());
}

/// Valida usuario: obligatorio, mínimo 3 caracteres, solo letras, números y _.
String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'El usuario es obligatorio';
  }
  if (value.length < 3) {
    return 'El usuario debe tener al menos 3 caracteres';
  }
  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
    return 'Solo letras, números y guión bajo';
  }
  return null;
}

/// Valida correo: obligatorio y formato válido.
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'El correo es obligatorio';
  }
  if (!isValidEmail(value)) {
    return 'Ingresa un correo electrónico válido (ej: nombre@dominio.com)';
  }
  return null;
}

/// Valida contraseña: obligatoria, mínimo 6 caracteres, mayúscula, minúscula y número.
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es obligatoria';
  }
  if (value.length < 6) {
    return 'Mínimo 6 caracteres';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Debe tener al menos una mayúscula';
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'Debe tener al menos una minúscula';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Debe tener al menos un número';
  }
  return null;
}

/// Valida nombre completo: obligatorio, mínimo 3 caracteres, solo letras/espacios, nombre y apellido.
String? validateFullName(String? value) {
  if (value == null || value.isEmpty) {
    return 'El nombre es obligatorio';
  }
  if (value.trim().length < 3) {
    return 'El nombre debe tener al menos 3 caracteres';
  }
  if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$").hasMatch(value)) {
    return 'Solo letras y espacios (sin números ni símbolos)';
  }
  final words = value.trim().split(RegExp(r'\s+'));
  if (words.length < 2) {
    return 'Ingresa nombre y apellido';
  }
  return null;
}

/// Valida confirmación de contraseña: obligatorio y debe coincidir con [password].
String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Confirma tu contraseña';
  }
  if (value != password) {
    return 'Las contraseñas no coinciden';
  }
  return null;
}
