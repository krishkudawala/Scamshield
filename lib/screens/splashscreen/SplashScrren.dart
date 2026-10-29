import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color lightText = Color(0xFFE8EDF5);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // App Logo
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: saffron.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: saffron.withValues(alpha: 0.12),
                          blurRadius: 35,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shield_rounded,
                        color: saffron,
                        size: 72,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // App Name
                const Text(
                  'ScamShield',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 4),

                // Left padding = letterSpacing, taaki trailing space compensate ho
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Text(
                    'BHARAT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: saffron,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 6,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36),
                  child: Text(
                    'Your Digital Safety Companion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: lightText,
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Loading Indicator
                const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: saffron,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Securing your digital world...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),

                const Spacer(),

                const Padding(
                  padding: EdgeInsets.only(bottom: 24, left: 1.5),
                  child: Text(
                    'MADE FOR A SAFER DIGITAL INDIA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}