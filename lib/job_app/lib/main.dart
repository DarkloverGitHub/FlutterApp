import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/job_detail_screen.dart';

void main() => runApp(
      DevicePreview(
        enabled: true, // set to false for production
        builder: (context) => const DreamJobApp(),
      ),
    );

class DreamJobApp extends StatelessWidget {
  const DreamJobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DreamJob',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      // DevicePreview requirements
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/welcome': (_) => const WelcomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/job-detail': (_) => const JobDetailScreen(),
      },
    );
  }
}
