import 'package:flutter/material.dart';
import 'package:scamshield/services/scam_service.dart';

class NotificationPermissionScreen extends StatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  State<NotificationPermissionScreen> createState() =>
      _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState
    extends State<NotificationPermissionScreen> with WidgetsBindingObserver {
  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color muted = Color(0xFFADB8C9);

  bool _isGranted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    final granted = await ScamService.instance.isNotificationPermissionGranted();
    if (mounted) {
      setState(() {
        _isGranted = granted;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleEnableAccess() async {
    await ScamService.instance.openNotificationAccessSettings();
    await _checkPermission();
    if (mounted && _isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification Listener Protection Enabled!'),
          backgroundColor: Color(0xFF16834A),
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
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

              // Main illustration & Status Badge
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isGranted
                            ? const Color(0xFF16834A).withValues(alpha: 0.15)
                            : saffron.withValues(alpha: 0.10),
                        border: Border.all(
                          color: _isGranted
                              ? const Color(0xFF16834A)
                              : saffron.withValues(alpha: 0.35),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _isGranted ? Icons.shield_rounded : Icons.notifications_active_outlined,
                        color: _isGranted ? const Color(0xFF16834A) : saffron,
                        size: 56,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _isGranted
                            ? const Color(0xFF16834A).withValues(alpha: 0.2)
                            : saffron.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isGranted ? const Color(0xFF16834A) : saffron,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isGranted ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                            color: _isGranted ? const Color(0xFF72D6A0) : saffron,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isLoading
                                ? 'Checking...'
                                : (_isGranted ? 'Listener Active & Granted' : 'Access Required'),
                            style: TextStyle(
                              color: _isGranted ? const Color(0xFF72D6A0) : saffron,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                'Allow ScamShield Notification Listener Service to inspect SMS, '
                'WhatsApp, and banking notifications in real-time on device for scam threats.',
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
                title: 'Real-time Android Listener Service',
                subtitle: 'Active background service monitors SMS & app notifications.',
              ),

              const SizedBox(height: 14),

              const _PermissionFeature(
                icon: Icons.psychology_outlined,
                title: 'AI & Hybrid Rule Threat Detector',
                subtitle: 'Scans message wording, links, and UPI PIN traps.',
              ),

              const SizedBox(height: 14),

              const _PermissionFeature(
                icon: Icons.vibration_rounded,
                title: 'Haptic & Vibration Alerts',
                subtitle: 'Triggers instant device vibration on high-risk scam alerts.',
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
                        'Notification access is handled on-device. Privacy is protected '
                        'and analyzed content is saved in local history.',
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

              // Open Android settings / Continue
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _handleEnableAccess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isGranted ? const Color(0xFF16834A) : saffron,
                    foregroundColor: navy,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isGranted ? 'Protection Granted • Go to Home' : 'Enable Notification Access',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white),
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
