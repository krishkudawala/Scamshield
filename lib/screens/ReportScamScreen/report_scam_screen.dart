
import 'package:flutter/material.dart';
import 'package:scamshield/services/scam_service.dart';

class ReportScamScreen extends StatefulWidget {
  const ReportScamScreen({super.key});

  @override
  State<ReportScamScreen> createState() => _ReportScamScreenState();
}

class _ReportScamScreenState extends State<ReportScamScreen> {
  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color background = Color(0xFFF5F7FA);
  static const Color muted = Color(0xFF687588);

  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _urlController = TextEditingController();
  final _detailsController = TextEditingController();

  String selectedCategory = 'Phishing link';
  String selectedSource = 'SMS';
  bool consentGiven = false;

  bool _submitted = false;

  final List<String> categories = const [
    'Phishing link',
    'Banking / KYC scam',
    'UPI / Payment fraud',
    'Fake prize / Lottery',
    'Fake job offer',
    'Delivery / Parcel scam',
    'Impersonation',
    'Other',
  ];

  final List<String> sources = const [
    'SMS',
    'WhatsApp',
    'Other messaging app',
    'Email',
    'Phone call',
    'Website',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _urlController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hint,
    String? label,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      hintStyle: const TextStyle(
        color: Color(0xFF9AA5B5),
        fontSize: 13,
      ),
      labelStyle: const TextStyle(
        color: muted,
        fontSize: 13,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFE2E7EF),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFE2E7EF),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: saffron,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFC24141),
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please confirm that you understand how your report will be handled.',
          ),
        ),
      );
      return;
    }

    setState(() => _submitted = true);

    final reportId = 'REP-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final report = ScamReportRecord(
      id: reportId,
      category: selectedCategory,
      source: selectedSource,
      message: _messageController.text.trim(),
      url: _urlController.text.trim(),
      details: _detailsController.text.trim(),
      timestamp: 'Today · ${TimeOfDay.now().format(context)}',
    );

    await ScamService.instance.submitReport(report);
    await ScamService.instance.saveScanRecord(
      ScanRecord(
        id: reportId,
        title: 'Reported: $selectedCategory',
        source: selectedSource,
        time: 'Today',
        message: _messageController.text.trim().isNotEmpty ? _messageController.text.trim() : 'Scam report submitted',
        risk: 'High',
        category: selectedCategory,
        reason: 'User submitted report for investigation.',
        recommendation: 'Thank you for keeping Bharat cyber safe.',
      ),
    );

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF16834A),
            size: 45,
          ),
          title: Text(
            'Report Submitted • $reportId',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Your scam report has been successfully saved persistently to local history and registered for review.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: muted,
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    setState(() => _submitted = false);
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
          'Report a Scam',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: navy,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(
                          color: saffron.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.flag_outlined,
                          color: saffron,
                          size: 31,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Help Others Stay Safe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'Report suspicious messages, links '
                                  'or payment requests.',
                              style: TextStyle(
                                color: Color(0xFFADB8C9),
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'What would you like to report?',
                  style: TextStyle(
                    color: navy,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Provide only the information needed to describe '
                      'the suspicious activity.',
                  style: TextStyle(
                    color: muted,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 24),

                // Category
                const _FieldLabel(
                  number: '01',
                  title: 'Scam category',
                ),

                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  isExpanded: true,
                  decoration: _inputDecoration(
                    hint: 'Select category',
                    prefixIcon: const Icon(
                      Icons.category_outlined,
                      color: saffron,
                    ),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() => selectedCategory = value);
                  },
                ),

                const SizedBox(height: 22),

                // Source
                const _FieldLabel(
                  number: '02',
                  title: 'Where did you receive it?',
                ),

                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  initialValue: selectedSource,
                  isExpanded: true,
                  decoration: _inputDecoration(
                    hint: 'Select source',
                    prefixIcon: const Icon(
                      Icons.message_outlined,
                      color: saffron,
                    ),
                  ),
                  items: sources.map((source) {
                    return DropdownMenuItem(
                      value: source,
                      child: Text(
                        source,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() => selectedSource = value);
                  },
                ),

                const SizedBox(height: 22),

                // Message
                const _FieldLabel(
                  number: '03',
                  title: 'Suspicious message',
                  optional: true,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _messageController,
                  minLines: 4,
                  maxLines: 7,
                  maxLength: 3000,
                  decoration: _inputDecoration(
                    hint: 'Paste the suspicious message here...',
                  ).copyWith(
                    counterStyle: const TextStyle(
                      color: muted,
                      fontSize: 11,
                    ),
                  ),
                  style: const TextStyle(
                    color: navy,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 13),

                // URL
                const _FieldLabel(
                  number: '04',
                  title: 'Suspicious URL',
                  optional: true,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  maxLength: 2048,
                  decoration: _inputDecoration(
                    hint: 'https://example.com',
                    prefixIcon: const Icon(
                      Icons.link_rounded,
                      color: saffron,
                    ),
                  ).copyWith(
                    counterText: '',
                  ),
                  style: const TextStyle(
                    color: navy,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 22),

                // Additional details
                const _FieldLabel(
                  number: '05',
                  title: 'Additional details',
                  optional: true,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _detailsController,
                  minLines: 3,
                  maxLines: 5,
                  maxLength: 1000,
                  decoration: _inputDecoration(
                    hint: 'Describe what happened...',
                  ),
                  style: const TextStyle(
                    color: navy,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 15),

                // Privacy notice
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5DD),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFEED9A5),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.privacy_tip_outlined,
                        color: Color(0xFF916000),
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Do not include passwords, OTPs, PINs, '
                              'full card details or unrelated private '
                              'conversations. Your report may contain '
                              'personal information.',
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

                const SizedBox(height: 15),

                // Consent checkbox
                CheckboxListTile(
                  value: consentGiven,
                  onChanged: (value) {
                    setState(() {
                      consentGiven = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: saffron,
                  title: const Text(
                    'I understand how this report will be handled.',
                    style: TextStyle(
                      color: navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Review the app privacy notice before submitting.',
                    style: TextStyle(
                      color: muted,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Submit
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _submitted ? null : _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: saffron,
                      foregroundColor: navy,
                      disabledBackgroundColor:
                      saffron.withValues(alpha: 0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _submitted
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: navy,
                      ),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.outgoing_mail),
                        SizedBox(width: 10),
                        Text(
                          'Prepare Report',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Center(
                  child: Text(
                    'Demo form • No report is uploaded yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: muted,
                      fontSize: 11,
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

class _FieldLabel extends StatelessWidget {
  final String number;
  final String title;
  final bool optional;

  const _FieldLabel({
    required this.number,
    required this.title,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 28,
          width: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFD98E04).withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Color(0xFF916000),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF101B2D),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (optional)
          const Text(
            'Optional',
            style: TextStyle(
              color: Color(0xFF8993A1),
              fontSize: 11,
            ),
          ),
      ],
    );
  }
}
