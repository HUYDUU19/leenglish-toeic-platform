import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/practice',
      builder:
          (context, state) => const Scaffold(
            body: Center(child: Text('Practice Screen - Coming Soon')),
          ),
    ),
    GoRoute(
      path: '/tests',
      builder:
          (context, state) => const Scaffold(
            body: Center(child: Text('Tests Screen - Coming Soon')),
          ),
    ),
    GoRoute(
      path: '/progress',
      builder:
          (context, state) => const Scaffold(
            body: Center(child: Text('Progress Screen - Coming Soon')),
          ),
    ),
  ],
);

void main() {
  runApp(const ProviderScope(child: LeEnglishApp()));
}

class LeEnglishApp extends StatelessWidget {
  const LeEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LeEnglish - TOEIC Learning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
