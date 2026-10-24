import 'package:flutter/material.dart';
import 'package:scamshield/services/scam_service.dart';

class SettingsScreen extends StatefulWidget {
  final bool notificationAccessEnabled;
  final VoidCallback? onOpenNotificationSettings;
  final VoidCallback? onOpenPrivacy;
  final VoidCallback? onOpenAbout;
  final VoidCallback? onClearHistory;

  const SettingsScreen({
    super.key,
    this.notificationAccessEnabled = false,
    this.onOpenNotificationSettings,
    this.onOpenPrivacy,
    this.onOpenAbout,
    this.onClearHistory,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with WidgetsBindingObserver {
  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color background = Color(0xFFF5F7FA);
  static const Color muted = Color(0xFF687588);

  String selectedLanguage = 'English';
  String alertSensitivity = 'Balanced';

  bool accessGranted = false;
  bool vibrationEnabled = true;
  bool highRiskAlertsEnabled = true;
  bool mediumRiskAlertsEnabled = true;
  bool showAlertPreview = true;
  bool useAiWhenAvailable = true;

  String springBootUrl = 'http://10.0.2.2:8080/api/analyze';
  String ollamaUrl = 'http://localhost:11434/api/generate';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadSettings();
    }
  }

  Future<void> _loadSettings() async {
    final granted = await ScamService.instance.isNotificationPermissionGranted();
    final vib = await ScamService.instance.isVibrationEnabled();
    final lang = await ScamService.instance.getAppLanguage();
    final spring = await ScamService.instance.getSpringBootUrl();
    final ollama = await ScamService.instance.getOllamaUrl();

    if (mounted) {
      setState(() {
        accessGranted = granted;
        vibrationEnabled = vib;
        selectedLanguage = lang;
        springBootUrl = spring;
        ollamaUrl = ollama;
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

  Future<void> _confirmClearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear scan history?'),
        content: const Text(
          'This action removes all stored scan records persistently from local storage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Clear History',
              style: TextStyle(color: Color(0xFFC24141)),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await ScamService.instance.clearScanHistory();
    if (widget.onClearHistory != null) {
      widget.onClearHistory!();
    }
    _showMessage('Scan history cleared persistently.');
  }

  void _configureServerUrls() {
    final springController = TextEditingController(text: springBootUrl);
    final ollamaController = TextEditingController(text: ollamaUrl);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Spring Boot & Ollama API Settings'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Configure Spring Boot & Ollama endpoints for live remote AI analysis:',
                style: TextStyle(fontSize: 12, color: muted),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: springController,
                decoration: const InputDecoration(
                  labelText: 'Spring Boot Endpoint',
                  hintText: 'http://10.0.2.2:8080/api/analyze',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ollamaController,
                decoration: const InputDecoration(
                  labelText: 'Ollama Endpoint',
                  hintText: 'http://localhost:11434/api/generate',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ScamService.instance.setSpringBootUrl(springController.text.trim());
              await ScamService.instance.setOllamaUrl(ollamaController.text.trim());
              if (!dialogContext.mounted) return;
              Navigator.pop(dialogContext);
              _loadSettings();
              _showMessage('Server configuration saved!');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _openPrivacy() {
    if (widget.onOpenPrivacy != null) {
      widget.onOpenPrivacy!();
    } else {
      Navigator.pushNamed(context, '/privacy');
    }
  }

  void _openAbout() {
    if (widget.onOpenAbout != null) {
      widget.onOpenAbout!();
    } else {
      Navigator.pushNamed(context, '/privacy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: saffron.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: saffron,
                      size: 31,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Make It Yours',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Manage your safety preferences.',
                          style: TextStyle(
                            color: Color(0xFFADB8C9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            const _SettingsSectionTitle(
              title: 'Protection',
              subtitle: 'Manage notification monitoring',
            ),

            const SizedBox(height: 12),

            // Notification access
            _SettingsTile(
              icon: Icons.notifications_active_outlined,
              iconColor: accessGranted
                  ? const Color(0xFF16834A)
                  : saffron,
              title: 'Notification access',
              subtitle: accessGranted
                  ? 'Android notification listener access is enabled'
                  : 'Listener permission is required',
              trailing: Icon(
                accessGranted
                    ? Icons.check_circle_rounded
                    : Icons.warning_amber_rounded,
                color: accessGranted
                    ? const Color(0xFF16834A)
                    : saffron,
              ),
              onTap: () async {
                await ScamService.instance.openNotificationAccessSettings();
                await _loadSettings();
              },
            ),

            const SizedBox(height: 10),

            _SettingsTile(
              icon: Icons.tune_rounded,
              iconColor: saffron,
              title: 'Alert sensitivity',
              subtitle: 'Adjust local warning rules',
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: alertSensitivity,
                  isDense: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'Conservative',
                      child: Text('Low'),
                    ),
                    DropdownMenuItem(
                      value: 'Balanced',
                      child: Text('Balanced'),
                    ),
                    DropdownMenuItem(
                      value: 'Sensitive',
                      child: Text('High'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => alertSensitivity = value);
                    }
                  },
                ),
              ),
              onTap: () {},
            ),

            const SizedBox(height: 26),

            const _SettingsSectionTitle(
              title: 'Notifications & Haptics',
              subtitle: 'Choose which warnings you receive',
            ),

            const SizedBox(height: 12),

            _SettingsSwitchTile(
              icon: Icons.vibration_rounded,
              title: 'Vibration alerts',
              subtitle: 'Vibrate for configured scam warnings',
              value: vibrationEnabled,
              onChanged: (value) async {
                setState(() => vibrationEnabled = value);
                await ScamService.instance.setVibrationEnabled(value);
                if (value) {
                  await ScamService.instance.triggerVibration();
                }
              },
            ),

            const SizedBox(height: 10),

            _SettingsSwitchTile(
              icon: Icons.gpp_bad_outlined,
              title: 'High-risk alerts',
              subtitle: 'Show warnings for high-risk assessments',
              value: highRiskAlertsEnabled,
              onChanged: (value) {
                setState(() => highRiskAlertsEnabled = value);
              },
            ),

            const SizedBox(height: 10),

            _SettingsSwitchTile(
              icon: Icons.warning_amber_rounded,
              title: 'Medium-risk alerts',
              subtitle: 'Show warnings for medium-risk assessments',
              value: mediumRiskAlertsEnabled,
              onChanged: (value) {
                setState(() => mediumRiskAlertsEnabled = value);
              },
            ),

            const SizedBox(height: 26),

            const _SettingsSectionTitle(
              title: 'Language & AI Endpoints',
              subtitle: 'Choose your language & AI connection',
            ),

            const SizedBox(height: 12),

            _SettingsTile(
              icon: Icons.translate_rounded,
              iconColor: saffron,
              title: 'App language',
              subtitle: 'Language for safety explanations',
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  isDense: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'Hindi',
                      child: Text('हिन्दी'),
                    ),
                    DropdownMenuItem(
                      value: 'Punjabi',
                      child: Text('ਪੰਜਾਬੀ'),
                    ),
                    DropdownMenuItem(
                      value: 'English',
                      child: Text('English'),
                    ),
                  ],
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() => selectedLanguage = value);
                      await ScamService.instance.setAppLanguage(value);
                    }
                  },
                ),
              ),
              onTap: () {},
            ),

            const SizedBox(height: 10),

            _SettingsTile(
              icon: Icons.cloud_outlined,
              iconColor: const Color(0xFF3867D6),
              title: 'Spring Boot & Ollama API',
              subtitle: 'Configure remote AI server endpoints',
              trailing: const Icon(
                Icons.settings_outlined,
                size: 20,
                color: muted,
              ),
              onTap: _configureServerUrls,
            ),

            const SizedBox(height: 26),

            const _SettingsSectionTitle(
              title: 'Privacy & Data',
              subtitle: 'Control your information',
            ),

            const SizedBox(height: 12),

            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              iconColor: saffron,
              title: 'Privacy & data usage',
              subtitle: 'Learn how notification text is processed',
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: muted,
              ),
              onTap: _openPrivacy,
            ),

            const SizedBox(height: 10),

            _SettingsTile(
              icon: Icons.delete_outline_rounded,
              iconColor: const Color(0xFFC24141),
              title: 'Clear scan history',
              subtitle: 'Remove saved analysis records persistently',
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: muted,
              ),
              onTap: _confirmClearHistory,
            ),

            const SizedBox(height: 26),

            const _SettingsSectionTitle(
              title: 'About',
              subtitle: 'Learn more about ScamShield Bharat',
            ),

            const SizedBox(height: 12),

            _SettingsTile(
              icon: Icons.info_outline_rounded,
              iconColor: saffron,
              title: 'About ScamShield Bharat',
              subtitle: 'App information and support',
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: muted,
              ),
              onTap: _openAbout,
            ),

            const SizedBox(height: 25),

            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.shield_rounded,
                    color: saffron,
                    size: 29,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ScamShield Bharat',
                    style: TextStyle(
                      color: navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Your digital safety companion',
                    style: TextStyle(
                      color: muted,
                      fontSize: 11,
                    ),
                  ),
                  SizedBox(height: 9),
                  Text(
                    'Version 1.0.0 • Connected',
                    style: TextStyle(
                      color: Color(0xFF8993A1),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SettingsSectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF101B2D),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF687588),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: const Color(0xFFE7EAF0),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 43,
                width: 43,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF101B2D),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF687588),
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 11, 10, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 43,
            width: 43,
            decoration: BoxDecoration(
              color: const Color(0xFFD98E04).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFD98E04),
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF101B2D),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF687588),
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: const Color(0xFFD98E04),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
