import 'package:flutter/material.dart';
import 'package:scamshield/screens/AlertDetailsScreen/alert_details_screen.dart';
import 'package:scamshield/screens/LiveScamAlertsScreen/live_scam_alerts_screen.dart';
import 'package:scamshield/services/scam_service.dart';

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
  List<ScamAlertItem> _history = [];
  bool _isLoading = true;

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
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final savedScans = await ScamService.instance.getScanHistory();
    if (savedScans.isNotEmpty) {
      _history = savedScans
          .map((s) => ScamAlertItem(
                title: s.title,
                source: s.source,
                time: s.time,
                message: s.message,
                risk: s.risk,
                category: s.category,
                reason: s.reason,
                recommendation: s.recommendation,
              ))
          .toList();
    } else {
      _history = List<ScamAlertItem>.from(widget.history ?? _demoHistory);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
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
            'This removes all saved scan records from device local storage.',
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

    await ScamService.instance.clearScanHistory();

    if (!mounted) return;

    setState(() {
      _history.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Scan history cleared persistently.'),
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
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Clear history',
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: SafeArea(
        top: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Search & Filter
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search history...',
                            prefixIcon: const Icon(Icons.search_rounded),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFFE2E7EF)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['All', 'High', 'Medium', 'Low'].map((risk) {
                              final isSelected = selectedRisk == risk;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  selected: isSelected,
                                  label: Text(risk),
                                  onSelected: (_) => setState(() => selectedRisk = risk),
                                  selectedColor: saffron.withValues(alpha: 0.2),
                                  checkmarkColor: saffron,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // History list
                  Expanded(
                    child: items.isEmpty
                        ? const Center(
                            child: Text(
                              'No matching scan records found.',
                              style: TextStyle(color: muted),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final color = _riskColor(item.risk);

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  side: const BorderSide(color: Color(0xFFE2E7EF)),
                                ),
                                child: ListTile(
                                  onTap: () => _openDetails(item),
                                  leading: CircleAvatar(
                                    backgroundColor: color.withValues(alpha: 0.12),
                                    child: Icon(
                                      item.risk == 'High' ? Icons.gpp_bad_rounded : Icons.shield_outlined,
                                      color: color,
                                    ),
                                  ),
                                  title: Text(
                                    item.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    item.message,
                                    maxLines: 2,
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
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
