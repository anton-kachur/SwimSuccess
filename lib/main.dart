import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/pace_selector/presentation/pace_provider.dart';
import 'features/pace_selector/presentation/pace_screen.dart';
import 'features/user_list/presentation/user_provider.dart'; // Add this import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PaceProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUsers()), // Initialize with automatic fetch
      ],
      child: MaterialApp(
        title: 'Swim Success',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const PaceScreen(),
      ),
    );
  }
}

