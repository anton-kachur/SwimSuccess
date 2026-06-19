import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/pace_selector/presentation/pace_provider.dart';
import 'features/pace_selector/presentation/pace_screen.dart';
import 'features/user_list/presentation/user_provider.dart';

/// The global application launch entry point.
void main() {
  runApp(const MyApp());
}

/// The root application widget orchestrating the global dependency injection 
/// tree and material platform configurations.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject state machine dependencies at the top level of the widget tree
    return MultiProvider(
      providers: [
        // Instantiates the standalone controller for the pace metrics feature
        ChangeNotifierProvider(create: (_) => PaceProvider()),
        
        // Instantiates the user directory provider and immediately triggers 
        // the initial asynchronous REST API fetch task using method cascading
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUsers()),
      ],
      child: MaterialApp(
        title: 'Swim Success',
        debugShowCheckedModeBanner: false, // Disables the generic debug badge banner
        theme: AppTheme.darkTheme,         // Attaches the custom system-wide dark style parameters
        home: const PaceScreen(),          // Configures the default layout initialization gateway route
      ),
    );
  }
}


