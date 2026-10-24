
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scamshield/screens/MessageAnalysisResultScreen/message_analysis_result_screen.dart';
import 'package:scamshield/services/scam_service.dart';

class ManualMessageCheckerScreen extends StatefulWidget {
  final void Function(String message, String language)? onAnalyze;

  const ManualMessageCheckerScreen({
    super.key,
    this.onAnalyze,
  });

  @override
  State<ManualMessageCheckerScreen> createState() =>
      _ManualMessageCheckerScreenState();
}

class _ManualMessageCheckerScreenState
    extends State<ManualMessageCheckerScreen> {
  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color background = Color(0xFFF5F7FA);
  static const Color muted = Color(0xFF687588);

  final TextEditingController _messageController =
  TextEditingController();

  String selectedLanguage = 'English';
  bool _showValidation = false;

  final List<String> examples = [
    'Bank KYC',
    'Prize message',
    'Delivery fee',
  ];

  final Map<String, String> exampleMessages = {
    'Bank KYC':
    'Your bank account will be blocked today. '
        'Complete KYC immediately using this link.',
    'Prize message':
    'Congratulations! You won a prize. '
        'Click this link to claim it now.',
    'Delivery fee':
    'Your parcel is on hold. Pay a small fee '
        'to release your delivery.',
  };

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _loadExample(String example) {
    setState(() {
      _messageController.text = exampleMessages[example]!;
      _messageController.selection = TextSelection.fromPosition(
        TextPosition(offset: _messageController.text.length),
      );
      _showValidation = false;
    });
  }

  Future<void> _analyzeMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      setState(() => _showValidation = true);
      return;
    }

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Analyzing message with ScamShield Hybrid Engine...'),
        duration: Duration(seconds: 1),
      ),
    );

    await ScamService.instance.analyzeMessage(message, selectedLanguage);

    if (!mounted) return;

    if (widget.onAnalyze != null) {
      widget.onAnalyze!(message, selectedLanguage);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessageAnalysisResultScreen(
          message: message,
          language: selectedLanguage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messageLength = _messageController.text.length;

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Message Checker',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header illustration
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: saffron.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.manage_search_rounded,
                    size: 56,
                    color: saffron,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              const Center(
                child: Text(
                  'Think Before You Click',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: navy,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 9),

              const Text(
                'Paste a suspicious message to check for '
                    'possible fraud indicators and learn how '
                    'to stay safe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 28),

              // Quick examples
              const Text(
                'Try an example',
                style: TextStyle(
                  color: navy,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: examples.map((example) {
                  return ActionChip(
                    onPressed: () => _loadExample(example),
                    avatar: const Icon(
                      Icons.bolt_rounded,
                      size: 17,
                      color: saffron,
                    ),
                    label: Text(example),
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color(0xFFE2E7EF),
                    ),
                    labelStyle: const TextStyle(
                      color: navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 26),

              // Message input heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Message content',
                    style: TextStyle(
                      color: navy,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (_messageController.text.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _messageController.clear();
                          _showValidation = false;
                        });
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          color: Color(0xFF9A6500),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              // Input card
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _showValidation
                        ? const Color(0xFFC24141)
                        : const Color(0xFFE2E7EF),
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _messageController,
                      minLines: 5,
                      maxLines: 8,
                      maxLength: 3000,
                      maxLengthEnforcement:
                      MaxLengthEnforcement.enforced,
                      onChanged: (_) {
                        setState(() {
                          _showValidation = false;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText:
                        'Paste SMS or notification text here...',
                        hintStyle: TextStyle(
                          color: Color(0xFF9AA5B5),
                          fontSize: 13,
                          height: 1.5,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      style: const TextStyle(
                        color: navy,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),

                    const Divider(
                      color: Color(0xFFE9ECF2),
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.text_fields_rounded,
                          size: 17,
                          color: muted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$messageLength / 3000 characters',
                          style: const TextStyle(
                            color: muted,
                            fontSize: 11,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.content_paste_rounded,
                          size: 17,
                          color: saffron,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Paste text',
                          style: TextStyle(
                            color: Color(0xFF9A6500),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (_showValidation) ...[
                const SizedBox(height: 8),
                const Text(
                  'Please paste a message before analyzing.',
                  style: TextStyle(
                    color: Color(0xFFC24141),
                    fontSize: 12,
                  ),
                ),
              ],

              const SizedBox(height: 25),

              // Language selector
              const Text(
                'Explanation language',
                style: TextStyle(
                  color: navy,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 11),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFE2E7EF),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLanguage,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: navy,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Hindi',
                        child: Text('हिन्दी (Hindi)'),
                      ),
                      DropdownMenuItem(
                        value: 'Punjabi',
                        child: Text('ਪੰਜਾਬੀ (Punjabi)'),
                      ),
                      DropdownMenuItem(
                        value: 'English',
                        child: Text('English'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        selectedLanguage = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Privacy note
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5DD),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFEED9A5),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      color: Color(0xFF916000),
                      size: 21,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Messages can contain sensitive information. '
                            'Avoid pasting OTPs, passwords, or bank details. '
                            'Check the app’s data practices before submitting.',
                        style: TextStyle(
                          color: Color(0xFF795500),
                          fontSize: 11,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Analyze button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _analyzeMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: saffron,
                    foregroundColor: navy,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shield_moon_sharp, size: 22),
                      SizedBox(width: 10),
                      Text(
                        'Analyze Message',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 19),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 13),

              const Center(
                child: Text(
                  'An analysis can identify warning signs, '
                      'but cannot guarantee a message is safe.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: muted,
                    fontSize: 11,
                    height: 1.5,
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
