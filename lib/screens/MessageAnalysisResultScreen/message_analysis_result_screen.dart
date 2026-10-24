
import 'package:flutter/material.dart';

class MessageAnalysisResultScreen extends StatelessWidget {
  final String message;
  final String language;

  const MessageAnalysisResultScreen({
    super.key,
    required this.message,
    required this.language,
  });

  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color background = Color(0xFFF5F7FA);
  static const Color muted = Color(0xFF687588);

  List<Map<String, dynamic>> _findSignals() {
    final text = message.toLowerCase();

    final rules = <Map<String, dynamic>>[
      {
        'title': 'Urgent or threatening language',
        'description':
        'The message may pressure you to act quickly.',
        'terms': [
          'urgent',
          'immediately',
          'will be blocked',
          'account blocked',
          'suspended',
          'expires today',
        ],
      },
      {
        'title': 'Unexpected prize or reward',
        'description':
        'Unexpected prize claims can be used to lure people.',
        'terms': [
          'you won',
          'won a prize',
          'congratulations',
          'claim your prize',
          'lottery winner',
          'claim reward',
        ],
      },
      {
        'title': 'Sensitive information request',
        'description':
        'The wording may relate to account or identity verification.',
        'terms': [
          'otp',
          'password',
          'bank details',
          'bank account',
          'complete kyc',
          'verify your account',
          'share your pin',
        ],
      },
      {
        'title': 'Payment request',
        'description':
        'Unexpected fee or money requests should be independently verified.',
        'terms': [
          'processing fee',
          'pay a fee',
          'send money',
          'payment required',
          'upi payment',
          'pay now',
        ],
      },
      {
        'title': 'Encourages clicking a link',
        'description':
        'The message asks you to open a link.',
        'terms': [
          'click here',
          'click this link',
          'click the link',
          'tap the link',
          'open this link',
        ],
      },
    ];

    final signals = <Map<String, dynamic>>[];

    for (final rule in rules) {
      final terms = rule['terms'] as List<String>;

      if (terms.any((term) => text.contains(term))) {
        signals.add({
          'title': rule['title'],
          'description': rule['description'],
        });
      }
    }

    // Detect a URL-like string, but do not claim the URL is verified.
    final urlPattern = RegExp(
      r'(https?:\/\/|www\.|[a-z0-9-]+\.[a-z]{2,})',
      caseSensitive: false,
    );

    if (urlPattern.hasMatch(message)) {
      signals.add({
        'title': 'URL found in message',
        'description':
        'A URL-like string is present. Its reputation and destination have not been checked.',
      });
    }

    return signals;
  }

  String _localized(String en, String hi, String pa) {
    switch (language.toLowerCase()) {
      case 'hindi':
        return hi;
      case 'punjabi':
        return pa;
      default:
        return en;
    }
  }

  @override
  Widget build(BuildContext context) {
    final signals = _findSignals();

    // Demo heuristic only; this is not an AI model or
    // a definitive determination of whether a message is fraudulent.
    final String risk;
    final Color riskColor;
    final IconData riskIcon;

    if (signals.length >= 3) {
      risk = 'High';
      riskColor = const Color(0xFFC24141);
      riskIcon = Icons.gpp_bad_rounded;
    } else if (signals.isNotEmpty) {
      risk = 'Needs Caution';
      riskColor = const Color(0xFFB7791F);
      riskIcon = Icons.warning_amber_rounded;
    } else {
      risk = 'No Common Signals Found';
      riskColor = const Color(0xFF16834A);
      riskIcon = Icons.shield_outlined;
    }

    final String recommendation;

    if (signals.isNotEmpty) {
      recommendation = _localized(
        'Do not click unexpected links or share OTPs, passwords, or banking details. Verify the request through an official channel.',
        'अनजान लिंक पर क्लिक न करें और OTP, पासवर्ड या बैंक विवरण साझा न करें। आधिकारिक माध्यम से अनुरोध की पुष्टि करें।',
        'ਅਣਜਾਣ ਲਿੰਕ ਨਾ ਖੋਲ੍ਹੋ ਅਤੇ OTP, ਪਾਸਵਰਡ ਜਾਂ ਬੈਂਕ ਵੇਰਵੇ ਸਾਂਝੇ ਨਾ ਕਰੋ। ਅਧਿਕਾਰਤ ਮਾਧਿਅਮ ਰਾਹੀਂ ਪੁਸ਼ਟੀ ਕਰੋ।',
      );
    } else {
      recommendation = _localized(
        'No common warning patterns were found, but that does not mean the message is safe. Verify unexpected requests independently.',
        'कोई सामान्य चेतावनी पैटर्न नहीं मिला, लेकिन इसका मतलब यह नहीं कि संदेश सुरक्षित है। अनजान अनुरोध की पुष्टि करें।',
        'ਕੋਈ ਆਮ ਚੇਤਾਵਨੀ ਸੰਕੇਤ ਨਹੀਂ ਮਿਲਿਆ, ਪਰ ਇਸਦਾ ਮਤਲਬ ਇਹ ਨਹੀਂ ਕਿ ਸੁਨੇਹਾ ਸੁਰੱਖਿਅਤ ਹੈ। ਅਣਜਾਣੇ ਬੇਨਤੀਆਂ ਦੀ ਪੁਸ਼ਟੀ ਕਰੋ।',
      );
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: navy,
        elevation: 0,
        title: Text(
          _localized(
            'Analysis Result',
            'विश्लेषण परिणाम',
            'ਵਿਸ਼ਲੇਸ਼ਣ ਨਤੀਜਾ',
          ),
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Result card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: riskColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 76,
                      width: 76,
                      decoration: BoxDecoration(
                        color: riskColor.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        riskIcon,
                        color: riskColor,
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 17),
                    Text(
                      risk,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: riskColor,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _localized(
                        '${signals.length} common warning pattern(s) found',
                        '${signals.length} सामान्य चेतावनी संकेत मिले',
                        '${signals.length} ਆਮ ਚੇਤਾਵਨੀ ਸੰਕੇਤ ਮਿਲੇ',
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Preliminary rule-based assessment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Submitted message
              const Text(
                'Message Analyzed',
                style: TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 11),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: const Color(0xFFE2E7EF),
                  ),
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Warning signals
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Possible Warning Signs',
                      style: TextStyle(
                        color: navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: saffron.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      '${signals.length} found',
                      style: const TextStyle(
                        color: Color(0xFF916000),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (signals.isEmpty)
                _SignalCard(
                  icon: Icons.info_outline_rounded,
                  color: muted,
                  title: 'No common patterns detected',
                  description:
                  'This simple rule checker found no matching indicators. '
                      'More sophisticated scams may not match these rules.',
                )
              else
                ...signals.map(
                      (signal) => Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: _SignalCard(
                      icon: Icons.warning_amber_rounded,
                      color: riskColor,
                      title: signal['title'] as String,
                      description: signal['description'] as String,
                    ),
                  ),
                ),

              const SizedBox(height: 14),

              // Safety recommendation
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
                          Icons.shield_moon_outlined,
                          color: Color(0xFF16834A),
                          size: 24,
                        ),
                        SizedBox(width: 9),
                        Text(
                          'Recommended Action',
                          style: TextStyle(
                            color: Color(0xFF17663D),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
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

              const SizedBox(height: 17),

              // Limitations notice
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
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'This demo uses simple keyword rules, not Ollama or a live URL reputation service. '
                            'The result is not proof of fraud, and a message with no warning signs may still be unsafe.',
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

              const SizedBox(height: 23),

              // Back button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text(
                    'Check Another Message',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
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
            ],
          ),
        ),
      ),
    );
  }
}

class _SignalCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _SignalCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E7EF),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF101B2D),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF687588),
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
