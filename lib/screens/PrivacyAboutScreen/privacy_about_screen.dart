
import 'package:flutter/material.dart';

class PrivacyAboutScreen extends StatelessWidget {
  final bool notificationAccessEnabled;
  final String appVersion;
  final VoidCallback? onClearHistory;
  final VoidCallback? onOpenSystemSettings;

  const PrivacyAboutScreen({
    super.key,
    this.notificationAccessEnabled = false,
    this.appVersion = '1.0.0',
    this.onClearHistory,
    this.onOpenSystemSettings,
  });

  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color background = Color(0xFFF5F7FA);
  static const Color muted = Color(0xFF687588);

  void _showInfo(
      BuildContext context,
      String title,
      String description,
      ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: navy,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          description,
          style: const TextStyle(
            color: muted,
            fontSize: 13,
            height: 1.7,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Close',
              style: TextStyle(color: saffron),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClearHistory(
      BuildContext context,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear scan history?'),
        content: const Text(
          'This asks the app to clear its saved scan history. '
              'It may not remove data already sent to a server or '
              'stored elsewhere.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Clear',
              style: TextStyle(color: Color(0xFFC24141)),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    if (onClearHistory != null) {
      onClearHistory!();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'History storage is not connected yet.',
          ),
        ),
      );
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
          'Privacy & About',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          children: [
            // About banner
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(23),
              ),
              child: Column(
                children: [
                  Container(
                    height: 76,
                    width: 76,
                    decoration: BoxDecoration(
                      color: saffron.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(23),
                      border: Border.all(
                        color: saffron.withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: saffron,
                      size: 45,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'ScamShield Bharat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your digital safety companion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFADB8C9),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Version $appVersion',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 27),

            const _SectionHeading(
              title: 'Your Privacy',
              subtitle: 'Understand what access the app uses.',
            ),

            const SizedBox(height: 13),

            _InformationCard(
              icon: Icons.notifications_active_outlined,
              iconColor: saffron,
              title: 'Notification access',
              subtitle: notificationAccessEnabled
                  ? 'Android notification access is enabled.'
                  : 'Notification access is not confirmed.',
              trailing: Icon(
                notificationAccessEnabled
                    ? Icons.check_circle_rounded
                    : Icons.info_outline_rounded,
                color: notificationAccessEnabled
                    ? const Color(0xFF16834A)
                    : saffron,
              ),
              onTap: () {
                _showInfo(
                  context,
                  'Notification access',
                  'Android notification access can expose the content '
                      'of notifications from supported apps. ScamShield '
                      'should use only the content needed for its stated '
                      'security purpose. Review the app implementation '
                      'and privacy notice before enabling access.',
                );
              },
            ),

            const SizedBox(height: 11),

            _InformationCard(
              icon: Icons.memory_rounded,
              iconColor: const Color(0xFF3867D6),
              title: 'Local analysis',
              subtitle: 'Rules may inspect message text on the device.',
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: muted,
                size: 16,
              ),
              onTap: () {
                _showInfo(
                  context,
                  'Local analysis',
                  'Local rule checks can inspect message wording without '
                      'sending it to a server. Whether this is how the app '
                      'currently operates depends on the connected detector. '
                      'Local rule checks alone cannot confirm every scam.',
                );
              },
            ),

            const SizedBox(height: 11),

            _InformationCard(
              icon: Icons.cloud_outlined,
              iconColor: const Color(0xFF8054C7),
              title: 'AI and server processing',
              subtitle: 'Check where AI analysis is performed.',
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: muted,
                size: 16,
              ),
              onTap: () {
                _showInfo(
                  context,
                  'AI and server processing',
                  'If the app sends a message to Spring Boot or a remote '
                      'Ollama service, that message leaves the device. '
                      'Explain what is transmitted, why it is needed, '
                      'how long it is retained and who can access it. '
                      'Do not describe analysis as local-only unless the '
                      'implementation actually keeps the text on-device.',
                );
              },
            ),

            const SizedBox(height: 11),

            _InformationCard(
              icon: Icons.storage_outlined,
              iconColor: const Color(0xFF16834A),
              title: 'History and data retention',
              subtitle: 'Understand how analyzed messages are stored.',
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: muted,
                size: 16,
              ),
              onTap: () {
                _showInfo(
                  context,
                  'History and data retention',
                  'The app may store risk results and, if configured, '
                      'message text in local storage or a server database. '
                      'The production version should state exactly what is '
                      'saved, when it is deleted and how users can request '
                      'deletion. Do not store more content than necessary.',
                );
              },
            ),

            const SizedBox(height: 27),

            const _SectionHeading(
              title: 'Permissions',
              subtitle: 'Manage access granted by Android.',
            ),

            const SizedBox(height: 13),

            _InformationCard(
              icon: Icons.settings_outlined,
              iconColor: saffron,
              title: 'Android permission settings',
              subtitle: 'Review notification access for ScamShield.',
              trailing: const Icon(
                Icons.open_in_new_rounded,
                color: muted,
                size: 19,
              ),
              onTap: () {
                if (onOpenSystemSettings != null) {
                  onOpenSystemSettings!();
                } else {
                  _showInfo(
                    context,
                    'Android settings',
                    'Connect this action to Android Notification Access '
                        'settings so the user can review or revoke access.',
                  );
                }
              },
            ),

            const SizedBox(height: 27),

            const _SectionHeading(
              title: 'Data Controls',
              subtitle: 'Manage saved information.',
            ),

            const SizedBox(height: 13),

            _InformationCard(
              icon: Icons.delete_outline_rounded,
              iconColor: const Color(0xFFC24141),
              title: 'Clear scan history',
              subtitle: 'Request removal of saved scan records.',
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: muted,
                size: 16,
              ),
              onTap: () => _confirmClearHistory(context),
            ),

            const SizedBox(height: 27),

            const _SectionHeading(
              title: 'About the Protection',
              subtitle: 'Know what ScamShield can and cannot do.',
            ),

            const SizedBox(height: 13),

            _ExpandableInformation(
              icon: Icons.shield_outlined,
              title: 'How detection works',
              description:
              'ScamShield can combine local rules, URL indicators, '
                  'sender information where available, and AI analysis '
                  'when configured. Each signal has limitations, and '
                  'a suspicious message is not automatically proof of fraud.',
            ),

            const SizedBox(height: 10),

            _ExpandableInformation(
              icon: Icons.warning_amber_rounded,
              title: 'Detection limitations',
              description:
              'Some scams may evade detection, while legitimate '
                  'messages may be flagged incorrectly. Notification '
                  'content can be hidden or incomplete. URL reputation '
                  'must not be presented as verified unless a real check '
                  'was performed.',
            ),

            const SizedBox(height: 10),

            _ExpandableInformation(
              icon: Icons.vibration_rounded,
              title: 'Alerts and vibration',
              description:
              'Alerts depend on notification permissions, device '
                  'settings, available background execution and the '
                  'configured detection pipeline. The app cannot guarantee '
                  'that every suspicious message will be detected.',
            ),

            const SizedBox(height: 27),

            // Clear history
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => _confirmClearHistory(context),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text(
                  'Clear Scan History',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFC24141),
                  side: const BorderSide(
                    color: Color(0xFFE4B8B8),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Center(
              child: Text(
                'MADE FOR A SAFER DIGITAL INDIA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8993A1),
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeading({
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
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF687588),
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _InformationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const _InformationCard({
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
                height: 44,
                width: 44,
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

class _ExpandableInformation extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ExpandableInformation({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Icon(
            icon,
            color: const Color(0xFFD98E04),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF101B2D),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          iconColor: const Color(0xFFD98E04),
          collapsedIconColor: const Color(0xFF687588),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 17),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF687588),
                  fontSize: 12,
                  height: 1.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
