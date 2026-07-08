import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/supabase-service.dart';
import 'providers/profile-provider.dart';
import 'providers/booking-provider.dart';
import 'providers/passeio-provider.dart';
import 'screens/splash-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SupabaseService.initialize();

  runApp(const PetHubApp());
}

class PetHubApp extends StatelessWidget {
  const PetHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => PasseioProvider()),
      ],
      child: MaterialApp(
        title: 'PetHub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF1E88E5),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF1E88E5),
            secondary: const Color(0xFFFFB300),
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          fontFamily: 'Inter',
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}