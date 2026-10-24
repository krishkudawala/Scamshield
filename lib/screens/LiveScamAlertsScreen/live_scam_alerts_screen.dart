
import 'package:flutter/material.dart';
import 'package:scamshield/screens/AlertDetailsScreen/alert_details_screen.dart';

class ScamAlertItem {
  final String title;
  final String source;
  final String time;
  final String message;
  final String risk;
  final String category;
  final String reason;
  final String recommendation;

  const ScamAlertItem({
    required this.title,
    required this.source,
    required this.time,
    required this.message,
    required this.risk,
    required this.category,
    required this.reason,
    required this.recommendation,
  });
}

class LiveScamAlertsScreen extends StatefulWidget {
  final List<ScamAlertItem>? alerts;
  final ValueChanged<ScamAlertItem>? onAlertTap;

  const LiveScamAlertsScreen({
    super.key,
    this.alerts,
    this.onAlertTap,
  });

  @override
  State<LiveScamAlertsScreen> createState() =>
      _LiveScamAlertsScreenState();
}

class _LiveScamAlertsScreenState
    extends State<LiveScamAlertsScreen> {
  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color background = Color(0xFFF5F7FA);
  static const Color muted = Color(0xFF687588);

  String selectedFilter = 'All';

  // Sample data for UI development only.
  // Replace with actual notification analysis results.
  final List<ScamAlertItem> demoAlerts = const [
    ScamAlertItem(
      title: 'Possible bank impersonation',
      source: 'SMS',
      time: '10:42 AM',
      message:
      'Your bank account will be blocked. Complete KYC immediately.',
      risk: 'High',
      category: 'Banking scam',
      reason:
      'The message creates urgency and asks the recipient '
          'to complete a sensitive account verification.',
      recommendation:
      'Do not open unknown links. Verify the request '
          'through your bank official app or website.',
    ),
    ScamAlertItem(
      title: 'Unexpected prize claim',
      source: 'WhatsApp',
      time: '09:15 AM',
      message:
      'Congratulations! You won a prize. Click to claim it now.',
      risk: 'High',
      category: 'Prize scam',
      reason:
      'An unexpected prize and pressure to click can be '
          'signs of a prize scam.',
      recommendation:
      'Verify the contest independently. Never pay a fee '
          'or share an OTP to claim an unexpected prize.',
    ),
    ScamAlertItem(
      title: 'Unverified delivery fee',
      source: 'SMS',
      time: 'Yesterday',
      message:
      'Your parcel is on hold. Pay a small fee to release it.',
      risk: 'Medium',
      category: 'Delivery scam',
      reason:
      'Unexpected delivery fees can be used to lure users '
          'to payment phishing pages.',
      recommendation:
      'Check the shipment using the courier official '
          'website or app before making a payment.',
    ),
  ];

  List<ScamAlertItem> get allAlerts =>
      widget.alerts ?? demoAlerts;

  List<ScamAlertItem> get filteredAlerts {
    if (selectedFilter == 'All') return allAlerts;

    return allAlerts
        .where((alert) => alert.risk == selectedFilter)
        .toList();
  }

  Color _riskColor(String risk) {
    switch (risk) {
      case 'High':
        return const Color(0xFFC24141);
      case 'Medium':
        return const Color(0xFFB7791F);
      case 'Low':
        return const Color(0xFF16834A);
      default:
        return muted;
    }
  }

  IconData _sourceIcon(String source) {
    switch (source.toLowerCase()) {
      case 'whatsapp':
        return Icons.chat_rounded;
      case 'sms':
        return Icons.sms_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  void _openAlert(ScamAlertItem alert) {
    if (widget.onAlertTap != null) {
      widget.onAlertTap!(alert);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlertDetailsScreen(
          title: alert.title,
          source: alert.source,
          time: alert.time,
          message: alert.message,
          risk: alert.risk,
          category: alert.category,
          reason: alert.reason,
          recommendation: alert.recommendation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alerts = filteredAlerts;

    final highCount = allAlerts
        .where((alert) => alert.risk == 'High')
        .length;

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scam Alerts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  const Text(
                    'Stay one step ahead.',
                    style: TextStyle(
                      color: navy,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Review suspicious notifications and learn '
                        'why they may be risky.',
                    style: TextStyle(
                      color: muted,
                      height: 1.5,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Summary card
                  Container(
                    padding: const EdgeInsets.all(19),
                    decoration: BoxDecoration(
                      color: navy,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: saffron.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.shield_moon_outlined,
                            color: saffron,
                            size: 29,
                          ),
                        ),
                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Potentially suspicious',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${allAlerts.length} alert(s) in this list',
                                style: const TextStyle(
                                  color: Color(0xFFADB8C9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$highCount',
                              style: const TextStyle(
                                color: saffron,
                                fontSize: 29,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              'High risk',
                              style: TextStyle(
                                color: Color(0xFFADB8C9),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Demo notice
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5DD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFEED9A5),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFF916000),
                          size: 20,
                        ),
                        SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            'Demo alerts: These examples are for UI '
                                'testing, not real detected messages.',
                            style: TextStyle(
                              color: Color(0xFF795500),
                              fontSize: 11,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 23),

                  const Text(
                    'Filter by risk',
                    style: TextStyle(
                      color: navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Risk filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'High', 'Medium', 'Low']
                          .map((filter) {
                        final isSelected = selectedFilter == filter;

                        return Padding(
                          padding: const EdgeInsets.only(right: 9),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                selectedFilter = filter;
                              });
                            },
                            selectedColor: saffron.withValues(
                              alpha: 0.18,
                            ),
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? navy : muted,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected
                                    ? saffron
                                    : const Color(0xFFE3E7EE),
                              ),
                            ),
                            showCheckmark: false,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Alert list',
                        style: TextStyle(
                          color: navy,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${alerts.length} found',
                        style: const TextStyle(
                          color: muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 13),

                  if (alerts.isEmpty)
                    _EmptyAlertsState(filter: selectedFilter)
                  else
                    ...alerts.map(
                          (alert) => Padding(
                        padding: const EdgeInsets.only(bottom: 13),
                        child: _AlertCard(
                          alert: alert,
                          riskColor: _riskColor(alert.risk),
                          sourceIcon: _sourceIcon(alert.source),
                          onTap: () => _openAlert(alert),
                        ),
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

class _AlertCard extends StatelessWidget {
  final ScamAlertItem alert;
  final Color riskColor;
  final IconData sourceIcon;
  final VoidCallback onTap;

  const _AlertCard({
    required this.alert,
    required this.riskColor,
    required this.sourceIcon,
    required this.onTap,
  });

  static const Color navy = Color(0xFF101B2D);
  static const Color muted = Color(0xFF687588);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
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
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: riskColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: riskColor,
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.title,
                          style: const TextStyle(
                            color: navy,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${alert.source}  •  ${alert.time}',
                          style: const TextStyle(
                            color: muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: riskColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      alert.risk,
                      style: TextStyle(
                        color: riskColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                alert.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF455165),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Icon(
                    sourceIcon,
                    size: 16,
                    color: muted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      alert.category,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const Text(
                    'View details',
                    style: TextStyle(
                      color: Color(0xFF9A6500),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFF9A6500),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyAlertsState extends StatelessWidget {
  final String filter;

  const _EmptyAlertsState({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: Color(0xFF8993A1),
            size: 43,
          ),
          const SizedBox(height: 12),
          const Text(
            'No alerts found',
            style: TextStyle(
              color: Color(0xFF101B2D),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            filter == 'All'
                ? 'There are no alerts to display.'
                : 'No $filter-risk alerts in this list.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF687588),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
