import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const HomeScreen(),
  );
}

const kBg = Color(0xFFFDF8F0);
const kInk = Color(0xFF0E0E1A);
const kGrey = Color(0xFF6B6B76);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, c) {
          final w = c.maxWidth;
          final s = w / 1144; // design scale (reference width 1144)
          final h = 1375 * s;
          return SingleChildScrollView(
            child: SizedBox(
              width: w,
              height: h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ..._blobs(s),
                  // ---- 4 cards ----
                  _pos(s, 43, 80, _FeatureCard(
                    s: s,
                    title: 'Check\nMessage',
                    subtitle: 'Scan SMS, WhatsApp\nor links',
                    icon: Icons.chat_bubble_rounded,
                    main: const Color(0xFFF58634),
                    iconBg: const Color(0xFFF58634),
                    iconColor: Colors.white,
                    bgTop: const Color(0xFFFFF1E4),
                    bgBottom: const Color(0xFFFFE3C9),
                    wave: const Color(0xFFFFC48A),
                    onTap: () {},
                  )),
                  _pos(s, 757, 80, _FeatureCard(
                    s: s,
                    title: 'Report\nScam',
                    subtitle: 'Report and help\nothers stay safe',
                    icon: Icons.phone_rounded,
                    main: const Color(0xFF1D5FE0),
                    iconBg: const Color(0xFFCFE4FF),
                    iconColor: const Color(0xFF1456D6),
                    bgTop: const Color(0xFFEAF4FF),
                    bgBottom: const Color(0xFFDDEBFF),
                    wave: const Color(0xFFA9D3FF),
                    onTap: () {},
                  )),
                  _pos(s, 43, 830, _FeatureCard(
                    s: s,
                    title: 'Learn\n& Stay Safe',
                    subtitle: 'Tips, guides and\nsafety awareness',
                    icon: Icons.menu_book_rounded,
                    main: const Color(0xFF7B4DD8),
                    iconBg: const Color(0xFFA974EE),
                    iconColor: Colors.white,
                    bgTop: const Color(0xFFF6EEFF),
                    bgBottom: const Color(0xFFEBDDFB),
                    wave: const Color(0xFFD9BDF5),
                    onTap: () {},
                  )),
                  _pos(s, 757, 830, _FeatureCard(
                    s: s,
                    title: 'Settings\n& Profile',
                    subtitle: 'Language, voice\nand more',
                    icon: Icons.settings_rounded,
                    main: const Color(0xFF1E8A4C),
                    iconBg: const Color(0xFFA6E6BE),
                    iconColor: const Color(0xFF0B5A2F),
                    bgTop: const Color(0xFFEDFAF1),
                    bgBottom: const Color(0xFFDDF5E5),
                    wave: const Color(0xFFAEE8C3),
                    onTap: () {},
                  )),

                  // ---- greeting ----
                  Positioned(
                    left: 391 * s,
                    width: 366 * s,
                    top: 130 * s,
                    child: Column(
                      children: [
                        Text('Hello Easin!',
                            style: TextStyle(fontSize: 28 * s, color: kGrey)),
                        SizedBox(height: 22 * s),
                        Text('How can I\nhelp you today?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 46 * s,
                                height: 1.2,
                                fontWeight: FontWeight.w800,
                                color: kInk)),
                      ],
                    ),
                  ),

                  // ---- rays ----
                  ..._rays(s),

                  // ---- orb ----
                  Positioned(
                    left: (572 - 215) * s,
                    top: (662 - 215) * s,
                    child: _Orb(s: s),
                  ),

                  // ---- label + mic ----
                  Positioned(
                    left: 391 * s,
                    width: 366 * s,
                    top: 858 * s,
                    child: Column(
                      children: [
                        Text('AI Assistant',
                            style: TextStyle(
                                fontSize: 44 * s,
                                fontWeight: FontWeight.w800,
                                color: kInk)),
                        SizedBox(height: 6 * s),
                        Text('Tap or speak...',
                            style: TextStyle(fontSize: 30 * s, color: kGrey)),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 391 * s,
                    width: 366 * s,
                    top: 985 * s,
                    child: _MicRow(s: s),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  static Widget _pos(double s, double x, double y, Widget child) =>
      Positioned(left: x * s, top: y * s, width: 348 * s, height: 422 * s, child: child);

  static List<Widget> _blobs(double s) {
    Widget blob(double x, double y, double d, Color c) => Positioned(
      left: x * s,
      top: y * s,
      child: Container(
        width: d * s,
        height: d * s,
        decoration: BoxDecoration(shape: BoxShape.circle, color: c),
      ),
    );
    return [
      blob(-200, -200, 420, const Color(0xFFFFE9CF)),
      blob(930, -150, 340, const Color(0xFFEBE0FA)),
      blob(-220, 650, 330, const Color(0xFFFFE6E6)),
      blob(1050, 660, 330, const Color(0xFFDDEEFB)),
      blob(-100, 1270, 330, const Color(0xFFE3E8FB)),
      blob(880, 1300, 400, const Color(0xFFFCE3E8)),
    ];
  }

  static List<Widget> _rays(double s) {
    const center = Offset(572, 662);
    final rays = <List<dynamic>>[
      [const Offset(433, 425), const Color(0xFFF59A3C)],
      [const Offset(710, 425), const Color(0xFF3FC0F2)],
      [const Offset(316, 577), const Color(0xFFF59A3C)],
      [const Offset(828, 577), const Color(0xFF9B7AF0)],
      [const Offset(312, 750), const Color(0xFFF58AB7)],
      [const Offset(830, 750), const Color(0xFFF58AB7)],
    ];
    return rays.map((r) {
      final o = r[0] as Offset;
      final color = r[1] as Color;
      final ang = math.atan2(o.dy - center.dy, o.dx - center.dx) + math.pi / 2;
      return Positioned(
        left: (o.dx - 6) * s,
        top: (o.dy - 25) * s,
        child: Transform.rotate(
          angle: ang,
          child: Container(
            width: 12 * s,
            height: 50 * s,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10 * s)),
          ),
        ),
      );
    }).toList();
  }
}

// ---------------------------------------------------------------- card
class _FeatureCard extends StatelessWidget {
  final double s;
  final String title, subtitle;
  final IconData icon;
  final Color main, iconBg, iconColor, bgTop, bgBottom, wave;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.s,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.main,
    required this.iconBg,
    required this.iconColor,
    required this.bgTop,
    required this.bgBottom,
    required this.wave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(60 * s);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: r,
          border: Border.all(color: Colors.white.withOpacity(.9), width: 3 * s),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [bgTop, bgBottom]),
          boxShadow: [
            BoxShadow(
                color: main.withOpacity(.12),
                blurRadius: 30 * s,
                offset: Offset(0, 12 * s)),
          ],
        ),
        child: ClipRRect(
          borderRadius: r,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 85 * s,
                child: CustomPaint(painter: _WavePainter(wave)),
              ),
              Positioned(
                left: 42 * s,
                top: 38 * s,
                child: Container(
                  width: 124 * s,
                  height: 124 * s,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(40 * s),
                    boxShadow: [
                      BoxShadow(
                          color: iconBg.withOpacity(.4),
                          blurRadius: 16 * s,
                          offset: Offset(0, 8 * s))
                    ],
                  ),
                  child: Icon(icon, size: 66 * s, color: iconColor),
                ),
              ),
              Positioned(
                right: 40 * s,
                top: 55 * s,
                child: Icon(Icons.chevron_right_rounded,
                    size: 52 * s, color: main),
              ),
              Positioned(
                left: 46 * s,
                top: 172 * s,
                right: 16 * s,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 38 * s,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                            color: kInk)),
                    SizedBox(height: 14 * s),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 27 * s, height: 1.3, color: kGrey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;
  _WavePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(0, h * .35)
      ..cubicTo(w * .18, h * .25, w * .30, h * .75, w * .55, h * .62)
      ..cubicTo(w * .75, h * .50, w * .85, h * .05, w, h * .12)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(path, Paint()..color = color.withOpacity(.75));
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) => old.color != color;
}

// ---------------------------------------------------------------- orb
class _Orb extends StatelessWidget {
  final double s;
  const _Orb({required this.s});

  @override
  Widget build(BuildContext context) {
    final ring = 430 * s, orb = 356 * s;
    return SizedBox(
      width: ring,
      height: ring,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // soft outer rings
          Container(
            width: ring,
            height: ring,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(.35),
              border: Border.all(
                  color: const Color(0xFFE6DAFB), width: 3 * s),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFFD9C8FF).withOpacity(.5),
                    blurRadius: 50 * s)
              ],
            ),
          ),
          Container(
            width: ring - 28 * s,
            height: ring - 28 * s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFFF3C9E8).withOpacity(.7), width: 2 * s),
            ),
          ),
          // gradient sphere
          ClipOval(
            child: SizedBox(
              width: orb,
              height: orb,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFD27A), Color(0xFFFF5FA2), Color(0xFF7A3DFF)],
                      ),
                    ),
                  ),
                  _glow(orb, -.1, .1, const Color(0xFFFF4F9A), .75),
                  _glow(orb, .95, -.55, const Color(0xFFB9FFF0), .95),
                  _glow(orb, .2, .9, const Color(0xFF7A35FF), 1),
                  _glow(orb, .95, .35, const Color(0xFF2FA8FF), .9),
                  _glow(orb, -.9, -.25, const Color(0xFFFFE08A), .8),
                ],
              ),
            ),
          ),
          // eyes
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _eye(s),
              SizedBox(width: 70 * s),
              _eye(s),
            ],
          ),
        ],
      ),
    );
  }

  Widget _glow(double size, double ax, double ay, Color c, double op) =>
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(ax, ay),
              radius: .75,
              colors: [c.withOpacity(op), c.withOpacity(0)],
            ),
          ),
        ),
      );

  Widget _eye(double s) => Container(
    width: 32 * s,
    height: 58 * s,
    decoration: BoxDecoration(
      color: const Color(0xFFFFF4FA),
      borderRadius: BorderRadius.circular(20 * s),
    ),
  );
}

// ---------------------------------------------------------------- mic row
class _MicRow extends StatelessWidget {
  final double s;
  const _MicRow({required this.s});

  Widget _bars(List<double> hs, Color color) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: hs
        .map((h) => Container(
      width: 8 * s,
      height: h * s,
      margin: EdgeInsets.symmetric(horizontal: 4 * s),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8 * s)),
    ))
        .toList(),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _bars([26, 44, 34, 58, 40], const Color(0xFFE2D4F7)),
        SizedBox(width: 24 * s),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 120 * s,
            height: 120 * s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF7F2FF),
              border: Border.all(color: Colors.white, width: 3 * s),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF9B7AF0).withOpacity(.25),
                    blurRadius: 24 * s,
                    offset: Offset(0, 8 * s))
              ],
            ),
            child: Icon(Icons.mic_rounded,
                size: 60 * s, color: const Color(0xFF6A3DF0)),
          ),
        ),
        SizedBox(width: 24 * s),
        _bars([40, 58, 34, 44, 26], const Color(0xFFF6D3E6)),
      ],
    );
  }
}