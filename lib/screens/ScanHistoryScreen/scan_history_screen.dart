
import 'package:flutter/material.dart';
import 'package:scamshield/screens/AlertDetailsScreen/alert_details_screen.dart';
import 'package:scamshield/screens/LiveScamAlertsScreen/live_scam_alerts_screen.dart';



class ScanHistoryScreen extends StatefulWidget {
  final List<ScamAlertItem>? history;

  const ScanHistoryScreen({
    super.key,
    this.history,
  });

  @override
  State<ScanHistoryScreen> createState() =>
      _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color background = Color(0xFFF5F7FA);
  static const Color muted = Color(0xFF687588);

  final TextEditingController _searchController =
  TextEditingController();

  String selectedRisk = 'All';
  late List<ScamAlertItem> _history;

  // Demo data for development. Replace with saved scan records.
  final List<ScamAlertItem> _demoHistory = const [
    ScamAlertItem(
      title: 'Possible bank impersonation',
      source: 'SMS',
      time: 'Today · 10:42 AM',
      message:
      'Your bank account will be blocked today. Complete KYC immediately.',
      risk: 'High',
      category: 'Banking scam',
      reason:
      'Urgency and a request to complete sensitive account verification '
          'can be warning signs.',
      recommendation:
      'Verify the request through your bank official app or website. '
          'Do not open unknown links.',
    ),
    ScamAlertItem(
      title: 'Unexpected prize claim',
      source: 'WhatsApp',
      time: 'Today · 09:15 AM',
      message:
      'Congratulations! You won a prize. Click this link to claim it now.',
      risk: 'High',
      category: 'Prize scam',
      reason:
      'An unexpected reward and pressure to click may indicate a scam.',
      recommendation:
      'Verify the contest independently. Do not pay a fee to claim '
          'an unexpected prize.',
    ),
    ScamAlertItem(
      title: 'Unverified delivery fee',
      source: 'SMS',
      time: 'Yesterday · 06:20 PM',
      message:
      'Your parcel is on hold. Pay a small fee to release it.',
      risk: 'Medium',
      category: 'Delivery scam',
      reason:
      'Unexpected delivery fee requests can lead to payment phishing.',
      recommendation:
      'Check the tracking number through the courier official website.',
    ),
    ScamAlertItem(
      title: 'Unknown payment request',
      source: 'WhatsApp',
      time: '22 Oct · 03:40 PM',
      message:
      'Please transfer the money immediately to confirm your booking.',
      risk: 'Medium',
      category: 'Payment request',
      reason:
      'An urgent and unexpected payment request should be verified.',
      recommendation:
      'Contact the person or organization using a trusted contact method.',
    ),
    ScamAlertItem(
      title: 'Message reviewed',
      source: 'Manual checker',
      time: '21 Oct · 11:25 AM',
      message:
      'Your appointment confirmation is ready.',
      risk: 'Low',
      category: 'General message',
      reason:
      'The demo rule checker found few common warning patterns.',
      recommendation:
      'No matching warning patterns does not guarantee safety. '
          'Verify unexpected requests independently.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _history = List<ScamAlertItem>.from(
      widget.history ?? _demoHistory,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _riskColor(String risk) {
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

  List<ScamAlertItem> get _filteredHistory {
    final query = _searchController.text.trim().toLowerCase();

    return _history.where((item) {
      final matchesRisk =
          selectedRisk == 'All' || item.risk == selectedRisk;

      final searchableText = [
        item.title,
        item.source,
        item.message,
        item.category,
        item.reason,
      ].join(' ').toLowerCase();

      final matchesSearch =
          query.isEmpty || searchableText.contains(query);

      return matchesRisk && matchesSearch;
    }).toList();
  }

  Future<void> _confirmClearHistory() async {
    if (_history.isEmpty) return;

    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear scan history?'),
          content: const Text(
            'This removes all records from this screen. '
                'This demo action does not delete records from a database.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              child: const Text(
                'Clear history',
                style: TextStyle(color: Color(0xFFC24141)),
              ),
            ),
          ],
        );
      },
    );

    if (shouldClear != true || !mounted) return;

    setState(() {
      _history.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('History cleared from this screen.'),
      ),
    );
  }

  void _openDetails(ScamAlertItem item) {
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
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredHistory;

    final highCount = _history
        .where((item) => item.risk == 'High')
        .length;

    final mediumCount = _history
        .where((item) => item.risk == 'Medium')
        .length;

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Scan History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _confirmClearHistory,
            tooltip: 'Clear history',
            icon: const Icon(Icons.delete_outline_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20, 8, 20, 24,
                ),
                children: [
                  const Text(
                    'Your Scan Activity',
                    style: TextStyle(
                      color: navy,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'Find previously analyzed messages and review '
                        'their risk assessments.',
                    style: TextStyle(
                      color: muted,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Summary cards
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Total scans',
                          value: '${_history.length}',
                          icon: Icons.manage_search_rounded,
                          color: const Color(0xFF3D6FE0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'High risk',
                          value: '$highCount',
                          icon: Icons.warning_amber_rounded,
                          color: const Color(0xFFC24141),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Medium',
                          value: '$mediumCount',
                          icon: Icons.error_outline_rounded,
                          color: const Color(0xFFB7791F),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // Search field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFFE2E7EF),
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search messages or categories...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9AA5B5),
                          fontSize: 12,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: muted,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Filter by risk',
                    style: TextStyle(
                      color: navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 12),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'High', 'Medium', 'Low']
                          .map((risk) {
                        final selected = selectedRisk == risk;

                        return Padding(
                          padding: const EdgeInsets.only(right: 9),
                          child: ChoiceChip(
                            label: Text(risk),
                            selected: selected,
                            onSelected: (_) {
                              setState(() {
                                selectedRisk = risk;
                              });
                            },
                            selectedColor: saffron.withValues(
                              alpha: 0.18,
                            ),
                            backgroundColor: Colors.white,
                            showCheckmark: false,
                            labelStyle: TextStyle(
                              color: selected ? navy : muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                              side: BorderSide(
                                color: selected
                                    ? saffron
                                    : const Color(0xFFE2E7EF),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Previous scans',
                        style: TextStyle(
                          color: navy,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${items.length} records',
                        style: const TextStyle(
                          color: muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 13),

                  if (items.isEmpty)
                    _EmptyHistory(
                      hasRecords: _history.isNotEmpty,
                    )
                  else
                    ...items.map(
                          (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _HistoryCard(
                          item: item,
                          riskColor: _riskColor(item.risk),
                          onTap: () => _openDetails(item),
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  const Center(
                    child: Text(
                      'Sample records are for UI testing only.',
                      style: TextStyle(
                        color: Color(0xFF8993A1),
                        fontSize: 11,
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

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF101B2D),
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF687588),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final ScamAlertItem item;
  final Color riskColor;
  final VoidCallback onTap;

  const _HistoryCard({
    required this.item,
    required this.riskColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
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
                  Container(
                    height: 43,
                    width: 43,
                    decoration: BoxDecoration(
                      color: riskColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: riskColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: Color(0xFF101B2D),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${item.source}  •  ${item.time}',
                          style: const TextStyle(
                            color: Color(0xFF687588),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: riskColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.risk,
                      style: TextStyle(
                        color: riskColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 13),

              Text(
                item.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF455165),
                  fontSize: 12,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        color: Color(0xFF687588),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const Text(
                    'View details',
                    style: TextStyle(
                      color: Color(0xFF9A6500),
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
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

class _EmptyHistory extends StatelessWidget {
  final bool hasRecords;

  const _EmptyHistory({required this.hasRecords});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(27),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.manage_search_rounded,
            color: Color(0xFF8993A1),
            size: 45,
          ),
          const SizedBox(height: 12),
          Text(
            hasRecords
                ? 'No matching scans'
                : 'No scan history yet',
            style: const TextStyle(
              color: Color(0xFF101B2D),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            hasRecords
                ? 'Try another search or risk filter.'
                : 'Analyzed messages will appear here '
                'once scan history storage is connected.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF687588),
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
