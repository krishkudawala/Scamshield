
import 'package:flutter/material.dart';

class AlertDetailsScreen extends StatelessWidget {
  final String title;
  final String source;
  final String time;
  final String message;
  final String risk;
  final String category;
  final String reason;
  final String recommendation;

  const AlertDetailsScreen({
    super.key,
    required this.title,
    required this.source,
    required this.time,
    required this.message,
    required this.risk,
    required this.category,
    required this.reason,
    required this.recommendation,
  });

  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color background = Color(0xFFF5F7FA);
  static const Color muted = Color(0xFF687588);

  Color get riskColor {
    switch (risk.toLowerCase()) {
      case 'high':
        return const Color(0xFFC24141);
      case 'medium':
        return const Color(0xFFB7791F);
      case 'low':
        return const Color(0xFF16834A);
      default:
        return muted;
    }
  }

  IconData get riskIcon {
    switch (risk.toLowerCase()) {
      case 'high':
        return Icons.gpp_bad_rounded;
      case 'medium':
        return Icons.warning_amber_rounded;
      case 'low':
        return Icons.verified_user_outlined;
      default:
        return Icons.help_outline_rounded;
    }
  }

  void _showFeedback(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
          'Alert Details',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showFeedback(
                context,
                'Connect the report feature to your reporting system.',
              );
            },
            tooltip: 'Report alert',
            icon: const Icon(Icons.flag_outlined),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Risk assessment card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: riskColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            color: riskColor.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            riskIcon,
                            color: riskColor,
                            size: 31,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$risk Risk',
                                style: TextStyle(
                                  color: riskColor,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                category,
                                style: const TextStyle(
                                  color: muted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Text(
                      title,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 20,
                        height: 1.3,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'ScamShield identified potential warning signs '
                          'in this message.',
                      style: const TextStyle(
                        color: muted,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Source details
              const _SectionHeading(
                title: 'Message Information',
                subtitle: 'Where the alert came from',
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE7EAF0),
                  ),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.apps_rounded,
                      label: 'Source',
                      value: source,
                    ),
                    const Divider(height: 24),
                    _InfoRow(
                      icon: Icons.access_time_rounded,
                      label: 'Detected at',
                      value: time,
                    ),
                    const Divider(height: 24),
                    _InfoRow(
                      icon: Icons.category_outlined,
                      label: 'Category',
                      value: category,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Original message
              const _SectionHeading(
                title: 'Original Message',
                subtitle: 'Text available in the notification',
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE7EAF0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: saffron.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.message_outlined,
                        color: saffron,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 14,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Why flagged
              const _SectionHeading(
                title: 'Why Was It Flagged?',
                subtitle: 'Potential warning signs',
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.manage_search_rounded,
                          color: riskColor,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Analysis explanation',
                            style: TextStyle(
                              color: navy,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      reason,
                      style: const TextStyle(
                        color: Color(0xFF455165),
                        fontSize: 13,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Recommended actions
              const _SectionHeading(
                title: 'What Should You Do?',
                subtitle: 'Recommended safety steps',
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4EE),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFD0E7D8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: Color(0xFF16834A),
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Stay Safe',
                            style: TextStyle(
                              color: Color(0xFF17663D),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      recommendation,
                      style: const TextStyle(
                        color: Color(0xFF285740),
                        fontSize: 13,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Important disclaimer
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5DD),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF916000),
                      size: 21,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'This is a risk assessment, not proof of fraud. '
                            'Verify suspicious requests independently. '
                            'A link is not considered checked unless a '
                            'URL analysis was actually performed.',
                        style: TextStyle(
                          color: Color(0xFF795500),
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Review action
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showFeedback(
                      context,
                      'Alert marked as reviewed in this session.',
                    );
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Mark as Reviewed',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showFeedback(
                      context,
                      'Connect this action to your actual reporting flow.',
                    );
                  },
                  icon: const Icon(Icons.flag_outlined),
                  label: const Text(
                    'Report This Message',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: riskColor,
                    side: BorderSide(
                      color: riskColor.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeading({
    required this.title,
    required this.subtitle,
  });

  static const Color navy = Color(0xFF101B2D);
  static const Color muted = Color(0xFF687588);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: navy,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: muted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  static const Color navy = Color(0xFF101B2D);
  static const Color muted = Color(0xFF687588);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: muted, size: 21),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: muted,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
