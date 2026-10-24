import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key});

  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color muted = Color(0xFFADB8C9);

  static const MethodChannel _channel =
  MethodChannel('scamshield/notifications');

  Future<void> _openNotificationSettings(
      BuildContext context,
      ) async {
    try {
      await _channel.invokeMethod(
        'openNotificationAccessSettings',
      );
    } on PlatformException {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open settings. Please open Android Settings manually.',
          ),
        ),
      );
    } on MissingPluginException {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Android integration is not configured yet.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'PROTECTION SETUP',
                      style: TextStyle(
                        color: muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.shield_rounded,
                    color: saffron,
                    size: 28,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Main illustration
              Center(
                child: Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: saffron.withValues(alpha: 0.10),
                    border: Border.all(
                      color: saffron.withValues(alpha: 0.35),
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: saffron,
                    size: 56,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Enable Smart\nMessage Protection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Allow ScamShield to inspect the text '
                    'available in supported notifications '
                    'and identify possible scam signals.',
                style: TextStyle(
                  color: muted,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              // Feature cards
              const _PermissionFeature(
                icon: Icons.message_outlined,
                title: 'Monitor supported notifications',
                subtitle:
                'Read notification content when Android makes it available.',
              ),

              const SizedBox(height: 14),

              const _PermissionFeature(
                icon: Icons.psychology_outlined,
                title: 'Analyze suspicious signals',
                subtitle:
                'Check message wording and available links for warning signs.',
              ),

              const SizedBox(height: 14),

              const _PermissionFeature(
                icon: Icons.vibration_rounded,
                title: 'Receive safety alerts',
                subtitle:
                'Get an alert when the analysis identifies a potential risk.',
              ),

              const SizedBox(height: 24),

              // Privacy note
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.045),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white12,
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      color: saffron,
                      size: 22,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Notification access can expose private '
                            'message content. Only enable it if you '
                            'agree to the app’s stated data practices.',
                        style: TextStyle(
                          color: muted,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Open Android settings
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    await _openNotificationSettings(context);
                    if (!context.mounted) return;
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: saffron,
                    foregroundColor: navy,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Enable Notification Access',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text(
                    'I’ll do this later',
                    style: TextStyle(
                      color: muted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PermissionFeature({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  static const Color saffron = Color(0xFFD98E04);
  static const Color muted = Color(0xFFADB8C9);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: saffron.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: saffron,
            size: 23,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: muted,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
