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
  
  
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();


    return Scaffold(