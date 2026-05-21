import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/retailer_repository.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FieldForceApp());
}

class FieldForceApp extends StatelessWidget {
  const FieldForceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RetailerRepository>(
          create: (_) => RetailerRepository(),
        ),
      ],
      child: MaterialApp(
        title: 'Saksham Edge',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0F2F6C), // Deep Blue
            primary: const Color(0xFF0F2F6C),
            secondary: Colors.green, // Green
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.white, // Crisp White
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0F2F6C),
            foregroundColor: Colors.white,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
