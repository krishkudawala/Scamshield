import 'package:flutter/material.dart';
import 'package:scamshield/screens/AlertDetailsScreen/alert_details_screen.dart';
import 'package:scamshield/services/scam_service.dart';

class HomeDashboardScreen extends StatefulWidget {
  final bool notificationAccessEnabled;

  final VoidCallback? onOpenManualChecker;
  final VoidCallback? onOpenAlerts;
  final VoidCallback? onOpenHistory;
  final VoidCallback? onOpenSettings;
  final VoidCallback? onOpenNotificationSetup;
  final VoidCallback? onOpenLinkChecker;
  final VoidCallback? onOpenReportScam;
  final VoidCallback? onOpenSafetyEducation;

  const HomeDashboardScreen({
    super.key,
    this.notificationAccessEnabled = false,
    this.onOpenManualChecker,
    this.onOpenAlerts,
    this.onOpenHistory,
    this.onOpenSettings,
    this.onOpenNotificationSetup,
    this.onOpenLinkChecker,
    this.onOpenReportScam,
    this.onOpenSafetyEducation,
  });

  @override
  State<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen>
    with WidgetsBindingObserver {
  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color muted = Color(0xFFADB8C9);
  static const Color background = Color(0xFFF5F7FA);

  int selectedIndex = 0;
  bool _accessEnabled = false;
  List<ScanRecord> _recentScans = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadDashboardData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadDashboardData();
    }
  }

  Future<void> _loadDashboardData() async {
    final granted = await ScamService.instance.isNotificationPermissionGranted();
    final scans = await ScamService.instance.getScanHistory();
    if (mounted) {
      setState(() {
        _accessEnabled = granted;
        _recentScans = scans;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _openScreen(
      VoidCallback? callback,
      String message,
      ) {
    if (callback != null) {
      callback();
    } else {
      _showMessage(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalChecked = _recentScans.length;
    final totalRisky = _recentScans.where((s) => s.risk == 'High' || s.risk == 'Medium').length;

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.shield_rounded,
                color: saffron,
                size: 27,
              ),
            ),
            const SizedBox(width: 11),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ScamShield',
                    style: TextStyle(
                      color: navy,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'BHARAT',
                    style: TextStyle(
                      color: saffron,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _openScreen(
              widget.onOpenAlerts,
              'Alerts screen will be connected here.',
            ),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: navy,
              size: 27,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              const Text(
                'Your Digital Safety',
                style: TextStyle(
                  color: navy,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Stay alert. Stay protected.',
                style: TextStyle(
                  color: Color(0xFF687588),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              // Protection status card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: navy.withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 47,
                          width: 47,
                          decoration: BoxDecoration(
                            color: saffron.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            _accessEnabled
                                ? Icons.shield_outlined
                                : Icons.shield_moon_outlined,
                            color: saffron,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 13),
                        const Expanded(
                          child: Text(
                            'Protection Status',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Icon(
                          _accessEnabled
                              ? Icons.check_circle
                              : Icons.info_outline_rounded,
                          color: _accessEnabled
                              ? const Color(0xFF72D6A0)
                              : saffron,
                          size: 25,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      _accessEnabled
                          ? 'Listener Protection Active'
                          : 'Setup Required',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _accessEnabled
                          ? 'Android Notification Listener Service is granted and active on device.'
                          : 'Enable notification access to allow ScamShield to inspect supported notifications.',
                      style: const TextStyle(
                        color: muted,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _openScreen(
                          widget.onOpenNotificationSetup,
                          'Notification permission setup will open here.',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: saffron,
                          foregroundColor: navy,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _accessEnabled
                                  ? 'Manage Protection Setup'
                                  : 'Enable Protection',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 19,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 27),

              // Statistics heading
              const Text(
                'Your Activity',
                style: TextStyle(
                  color: navy,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 14),

              // Statistics cards
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.document_scanner_outlined,
                      iconColor: const Color(0xFF3D6FE0),
                      title: 'Messages',
                      value: '$totalChecked',
                      subtitle: 'Checked',
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.warning_amber_rounded,
                      iconColor: const Color(0xFFC24141),
                      title: 'Risky',
                      value: '$totalRisky',
                      subtitle: 'Detected',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 27),

              // Quick actions heading
              const Text(
                'Quick Actions',
                style: TextStyle(
                  color: navy,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 14),

              // Manual checker card
              InkWell(
                onTap: () => _openScreen(
                  widget.onOpenManualChecker,
                  'Manual Message Checker will open here.',
                ),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE7EAF0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: saffron.withValues(alpha: 0.13),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          color: saffron,
                          size: 29,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Check a Message',
                              style: TextStyle(
                                color: navy,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Paste a suspicious message for analysis',
                              style: TextStyle(
                                color: Color(0xFF687588),
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: navy,
                        size: 17,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 13),

              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.notifications_active_outlined,
                      title: 'Alerts',
                      subtitle: 'View warnings',
                      onTap: () => _openScreen(
                        widget.onOpenAlerts,
                        'Alerts screen will open here.',
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.history_rounded,
                      title: 'Scan History',
                      subtitle: 'View past checks',
                      onTap: () => _openScreen(
                        widget.onOpenHistory,
                        'Scan History will open here.',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 13),

              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.link_rounded,
                      title: 'Link Checker',
                      subtitle: 'Check URL',
                      onTap: () => _openScreen(
                        widget.onOpenLinkChecker,
                        'Link Checker will open here.',
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.flag_outlined,
                      title: 'Report Scam',
                      subtitle: 'Submit report',
                      onTap: () => _openScreen(
                        widget.onOpenReportScam,
                        'Report Scam will open here.',
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.school_outlined,
                      title: 'Safety Ed',
                      subtitle: 'Learn tips',
                      onTap: () => _openScreen(
                        widget.onOpenSafetyEducation,
                        'Safety Education will open here.',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 27),

              // Recent activity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      color: navy,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _openScreen(
                      widget.onOpenHistory,
                      'Scan History will open here.',
                    ),
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        color: Color(0xFF9A6500),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              if (_recentScans.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 26,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE7EAF0),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        color: Color(0xFF9AA5B5),
                        size: 42,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No activity yet',
                        style: TextStyle(
                          color: navy,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Your analyzed messages and alerts will appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF687588),
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: _recentScans.take(3).map((item) {
                    final isHigh = item.risk == 'High';
                    final isMedium = item.risk == 'Medium';
                    final color = isHigh
                        ? const Color(0xFFC24141)
                        : (isMedium ? const Color(0xFFB7791F) : const Color(0xFF16834A));

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Color(0xFFE7EAF0)),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AlertDetailsScreen(
                                title: item.title,
                                source: item.source,
                                time: item.time,
                                message: item.message,
                                risk: item.risk,
                                category: item.category,
                                reason: item.reason,
                                recommendation: item.recommendation,
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: color.withValues(alpha: 0.12),
                          child: Icon(
                            isHigh ? Icons.gpp_bad_rounded : Icons.shield_outlined,
                            color: color,
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        subtitle: Text(
                          item.message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.risk,
                            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 18),

              const Center(
                child: Text(
                  'ScamShield Bharat • Stay cyber safe',
                  style: TextStyle(
                    color: Color(0xFF8993A1),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });

          switch (index) {
            case 0:
              break;
            case 1:
              _openScreen(
                widget.onOpenAlerts,
                'Alerts screen will open here.',
              );
              break;
            case 2:
              _openScreen(
                widget.onOpenHistory,
                'Scan History will open here.',
              );
              break;
            case 3:
              _openScreen(
                widget.onOpenSettings,
                'Settings screen will open here.',
              );
              break;
          }

          if (index != 0) {
            setState(() {
              selectedIndex = 0;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF9A6500),
        unselectedItemColor: const Color(0xFF8993A1),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Statistics card
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  static const Color navy = Color(0xFF101B2D);
  static const Color muted = Color(0xFF687588);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  color: navy,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: navy,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color muted = Color(0xFF687588);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE7EAF0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: saffron.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: saffron,
                size: 22,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: navy,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                color: muted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
