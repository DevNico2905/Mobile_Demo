import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/login_provider.dart';
import 'screens/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App',
        home: const LoginScreen(),
      ),
    );
  }
}
