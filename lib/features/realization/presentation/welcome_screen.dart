import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:winemaker/app/router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Winemaker')),
      body: Center(
        child: ElevatedButton(
          child: const Text("Start Winemaker"),
          onPressed: () => context.pushNamed(
            AppRoute.recipe,
            pathParameters: {AppRoute.realizationIdParam: '1'},
          ),
        ),
      ),
    );
  }
}
