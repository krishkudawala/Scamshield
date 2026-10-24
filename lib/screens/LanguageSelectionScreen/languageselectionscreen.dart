
import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends State<LanguageSelectionScreen> {
  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color muted = Color(0xFFADB8C9);

  String selectedLanguage = 'Hindi';

  final List<Map<String, String>> languages = [
    {
      'name': 'Hindi',
      'native': 'हिन्दी',
      'description': 'सरल हिंदी में सुरक्षा अलर्ट',
      'flag': '🇮🇳',
    },
    {
      'name': 'Punjabi',
      'native': 'ਪੰਜਾਬੀ',
      'description': 'ਪੰਜਾਬੀ ਵਿੱਚ ਸੁਰੱਖਿਆ ਅਲਰਟ',
      'flag': '🇮🇳',
    },
    {
      'name': 'English',
      'native': 'English',
      'description': 'Security alerts in English',
      'flag': '🌐',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and progress
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'STEP 1 OF 2',
                      style: TextStyle(
                        color: muted,
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.shield_rounded,
                    color: saffron,
                    size: 28,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Heading
              const Text(
                'Choose Your\nLanguage',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Choose the language in which you want '
                    'to receive scam alerts and safety advice.',
                style: TextStyle(
                  color: muted,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 30),

              // Language cards
              ...languages.map((language) {
                final isSelected =
                    selectedLanguage == language['name'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      setState(() {
                        selectedLanguage = language['name']!;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? saffron.withValues(alpha: 0.10)
                            : Colors.white.withValues(alpha: 0.035),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? saffron
                              : Colors.white12,
                          width: isSelected ? 1.6 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            language['flag']!,
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  language['native']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  language['description']!,
                                  style: const TextStyle(
                                    color: muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.circle_outlined,
                            color: isSelected
                                ? saffron
                                : Colors.white38,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const Spacer(),

              // Privacy note
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.translate_rounded,
                      color: saffron,
                      size: 22,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You can change your language later '
                            'in Settings.',
                        style: TextStyle(
                          color: muted,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/permission');
                  },
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
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded),
                    ],
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
