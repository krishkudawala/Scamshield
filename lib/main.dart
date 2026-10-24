
import 'package:flutter/material.dart';
import 'package:scamshield/screens/HomeDashBoardScreen/home_dashboard_screen.dart';
import 'package:scamshield/screens/LanguageSelectionScreen/languageselectionscreen.dart';
import 'package:scamshield/screens/LinkCheckerScreen/link_checker_screen.dart';
import 'package:scamshield/screens/LiveScamAlertsScreen/live_scam_alerts_screen.dart';
import 'package:scamshield/screens/ManualMessageCheckerScreen/manual_message_checker_screen.dart';
import 'package:scamshield/screens/MessageAnalysisResultScreen/message_analysis_result_screen.dart';
import 'package:scamshield/screens/NotificationpermissionScreen/notification_permission_screen.dart';
import 'package:scamshield/screens/OnboardingScreen/onboardingScreen.dart';
import 'package:scamshield/screens/PrivacyAboutScreen/privacy_about_screen.dart';
import 'package:scamshield/screens/ReportScamScreen/report_scam_screen.dart';
import 'package:scamshield/screens/SafetyEducationScreen/safety_education_screen.dart';
import 'package:scamshield/screens/ScanHistoryScreen/scan_history_screen.dart';
import 'package:scamshield/screens/SettingsScreen/settings_screen.dart';
import 'package:scamshield/screens/splashscreen/SplashScrren.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ScamShieldApp());
}

class ScamShieldApp extends StatelessWidget {
  const ScamShieldApp({super.key});

  Route<dynamic> _buildRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );

      case '/language':
        return MaterialPageRoute(
          builder: (_) => const LanguageSelectionScreen(),
        );

      case '/permission':
        return MaterialPageRoute(
          builder: (_) => const NotificationPermissionScreen(),
        );

      case '/home':
        return MaterialPageRoute(
          builder: (context) => HomeDashboardScreen(
            notificationAccessEnabled: false,

            onOpenNotificationSetup: () {
              Navigator.pushNamed(context, '/permission');
            },

            onOpenAlerts: () {
              Navigator.pushNamed(context, '/alerts');
            },

            onOpenManualChecker: () {
              Navigator.pushNamed(context, '/manual-checker');
            },

            onOpenHistory: () {
              Navigator.pushNamed(context, '/history');
            },

            onOpenSettings: () {
              Navigator.pushNamed(context, '/settings');
            },

            onOpenLinkChecker: () {
              Navigator.pushNamed(context, '/link-checker');
            },

            onOpenReportScam: () {
              Navigator.pushNamed(context, '/report-scam');
            },

            onOpenSafetyEducation: () {
              Navigator.pushNamed(context, '/safety-education');
            },
          ),
        );

      case '/alerts':
        return MaterialPageRoute(
          builder: (_) => const LiveScamAlertsScreen(),
        );

      case '/manual-checker':
        return MaterialPageRoute(
          builder: (context) => ManualMessageCheckerScreen(
            onAnalyze: (message, language) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MessageAnalysisResultScreen(
                    message: message,
                    language: language,
                  ),
                ),
              );
            },
          ),
        );

      case '/history':
        return MaterialPageRoute(
          builder: (_) => const ScanHistoryScreen(),
        );

      case '/link-checker':
        return MaterialPageRoute(
          builder: (_) => const LinkCheckerScreen(),
        );

      case '/report-scam':
        return MaterialPageRoute(
          builder: (_) => const ReportScamScreen(),
        );

      case '/safety-education':
        return MaterialPageRoute(
          builder: (_) => const SafetyEducationScreen(),
        );

      case '/settings':
        return MaterialPageRoute(
          builder: (context) => SettingsScreen(
            notificationAccessEnabled: false,

            onOpenNotificationSettings: () {
              Navigator.pushNamed(context, '/permission');
            },

            onOpenPrivacy: () {
              Navigator.pushNamed(context, '/privacy');
            },

            onOpenAbout: () {
              Navigator.pushNamed(context, '/privacy');
            },
          ),
        );

      case '/privacy':
        return MaterialPageRoute(
          builder: (context) => PrivacyAboutScreen(
            notificationAccessEnabled: false,
            onOpenSystemSettings: () {
              Navigator.pushNamed(context, '/permission');
            },
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Page not found')),
            body: Center(
              child: Text('Unknown route: ${settings.name}'),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScamShield Bharat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD98E04),
          brightness: Brightness.light,
        ),
      ),

      // The splash screen handles the initial transition.
      home: const SplashScreen(),

      onGenerateRoute: _buildRoute,
    );
  }
}
