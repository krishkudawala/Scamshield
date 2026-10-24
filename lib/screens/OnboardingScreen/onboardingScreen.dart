import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color muted = Color(0xFFADB8C9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            children: [
              // Top bar
              Row(
                children: [
                  const Icon(
                    Icons.shield_rounded,
                    color: saffron,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'ScamShield Bharat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: muted),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Main illustration
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.035),
                  border: Border.all(
                    color: saffron.withValues(alpha: 0.25),
                  ),
                ),
                child: Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: saffron.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: saffron,
                      size: 80,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Stay One Step Ahead\nof Every Scam',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Understand suspicious messages before '
                    'you click, pay, or share personal information.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // Feature 1
              const _FeatureRow(
                icon: Icons.notifications_active_outlined,
                title: 'Smart Message Alerts',
                subtitle:
                'Check supported notifications for scam signals.',
              ),

              const SizedBox(height: 16),

              // Feature 2
              const _FeatureRow(
                icon: Icons.psychology_outlined,
                title: 'AI-Powered Explanations',
                subtitle:
                'Understand suspicious signs in simple language.',
              ),

              const SizedBox(height: 16),

              // Feature 3
              const _FeatureRow(
                icon: Icons.language_rounded,
                title: 'Made for Bharat',
                subtitle:
                'Designed for Hindi, Punjabi and English.',
              ),

              const SizedBox(height: 30),

              // Get Started button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/language');
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
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Your safety. Your control.',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureRow({
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
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: saffron.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: saffron,
            size: 24,
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
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
