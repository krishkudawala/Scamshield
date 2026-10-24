
import 'package:flutter/material.dart';

class LinkCheckerScreen extends StatefulWidget {
  const LinkCheckerScreen({super.key});

  @override
  State<LinkCheckerScreen> createState() => _LinkCheckerScreenState();
}

class _LinkCheckerScreenState extends State<LinkCheckerScreen> {
  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color background = Color(0xFFF5F7FA);
  static const Color muted = Color(0xFF687588);

  final TextEditingController _urlController =
  TextEditingController();

  bool _showValidation = false;
  bool _hasResult = false;
  bool _isValidUrl = false;

  String _checkedUrl = '';
  String _resultTitle = '';
  String _resultDescription = '';

  Color _resultColor = muted;
  IconData _resultIcon = Icons.link_rounded;

  List<String> _warnings = [];

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _loadExample(String url) {
    setState(() {
      _urlController.text = url;
      _showValidation = false;
      _hasResult = false;
    });
  }

  bool _isIPv4(String host) {
    final parts = host.split('.');
    if (parts.length != 4) return false;

    for (final part in parts) {
      final number = int.tryParse(part);
      if (number == null || number < 0 || number > 255) {
        return false;
      }
    }

    return true;
  }

  void _checkLink() {
    final input = _urlController.text.trim();

    if (input.isEmpty) {
      setState(() {
        _showValidation = true;
        _hasResult = false;
      });
      return;
    }

    // Do not open or fetch the submitted URL.
    // These are local structural checks only.
    var candidate = input;

    if (!candidate.contains('://')) {
      candidate = 'https://$candidate';
    }

    final uri = Uri.tryParse(candidate);

    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        !uri.host.contains('.') ||
        uri.host.startsWith('.') ||
        uri.host.endsWith('.') ||
        uri.host.contains(' ')) {
      setState(() {
        _showValidation = true;
        _hasResult = false;
      });
      return;
    }

    final host = uri.host.toLowerCase();
    final warnings = <String>[];

    if (uri.scheme.toLowerCase() != 'https') {
      warnings.add(
        'The URL does not use HTTPS. Its connection may not be encrypted.',
      );
    }

    if (_isIPv4(host)) {
      warnings.add(
        'The URL uses an IP address instead of a conventional domain name.',
      );
    }

    if (host.contains('xn--')) {
      warnings.add(
        'The domain contains an internationalized hostname encoding. '
            'Verify the spelling and destination carefully.',
      );
    }

    if (uri.userInfo.isNotEmpty || input.contains('@')) {
      warnings.add(
        'The URL contains an @ symbol or user-information component. '
            'Check which hostname the browser would actually visit.',
      );
    }

    const shorteners = {
      'bit.ly',
      't.co',
      'tinyurl.com',
      'is.gd',
      'ow.ly',
      'buff.ly',
      'shorturl.at',
      'cutt.ly',
    };

    if (shorteners.contains(host)) {
      warnings.add(
        'This appears to use a URL-shortening service, which can hide '
            'the final destination.',
      );
    }

    final labels = host.split('.');

    if (labels.length >= 5) {
      warnings.add(
        'The domain contains several subdomain levels. '
            'Check the registered domain carefully.',
      );
    }

    if (host.length > 45) {
      warnings.add(
        'The hostname is unusually long. Confirm that it matches '
            'the organization you expect.',
      );
    }

    if (host.contains('--') || host.split('.').any((label) {
      return label.startsWith('-') || label.endsWith('-');
    })) {
      warnings.add(
        'The domain contains unusual hyphen patterns. '
            'Check for look-alike spellings.',
      );
    }

    setState(() {
      _checkedUrl = candidate;
      _warnings = warnings;
      _showValidation = false;
      _hasResult = true;
      _isValidUrl = true;

      if (warnings.length >= 2) {
        _resultTitle = 'Caution: Warning Signs Found';
        _resultDescription =
        'This URL has multiple structural indicators that deserve '
            'further checking. This does not prove that the website is malicious.';
        _resultColor = const Color(0xFFC24141);
        _resultIcon = Icons.gpp_bad_rounded;
      } else if (warnings.isNotEmpty) {
        _resultTitle = 'Review This Link Carefully';
        _resultDescription =
        'A potential warning sign was found. Verify the destination '
            'independently before opening it.';
        _resultColor = const Color(0xFFB7791F);
        _resultIcon = Icons.warning_amber_rounded;
      } else {
        _resultTitle = 'No Basic Warning Signs Found';
        _resultDescription =
        'These simple checks found no matching structural warning '
            'patterns. This does not mean that the website is safe.';
        _resultColor = const Color(0xFF16834A);
        _resultIcon = Icons.info_outline_rounded;
      }
    });
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
          'Link Checker',
          style: TextStyle(
            fontSize: 20,
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
              // Header illustration
              Center(
                child: Container(
                  height: 106,
                  width: 106,
                  decoration: BoxDecoration(
                    color: saffron.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.link_rounded,
                    color: saffron,
                    size: 55,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              const Center(
                child: Text(
                  'Check Before You Click',
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
                'Review a suspicious link for common URL warning signs '
                    'before deciding what to do.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Enter suspicious URL',
                style: TextStyle(
                  color: navy,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 11),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: _showValidation
                        ? const Color(0xFFC24141)
                        : const Color(0xFFE2E7EF),
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _urlController,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _checkLink(),
                      onChanged: (_) {
                        setState(() {
                          _showValidation = false;
                          _hasResult = false;
                        });
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.language_rounded,
                          color: saffron,
                        ),
                        hintText: 'https://example.com',
                        hintStyle: TextStyle(
                          color: Color(0xFF9AA5B5),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: navy,
                        fontSize: 13,
                      ),
                    ),

                    const Divider(
                      color: Color(0xFFE9ECF2),
                    ),

                    const Row(
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: muted,
                          size: 17,
                        ),
                        SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            'The entered URL will not be opened by this demo.',
                            style: TextStyle(
                              color: muted,
                              fontSize: 10,
                            ),
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
                  'Enter a valid URL, such as example.com.',
                  style: TextStyle(
                    color: Color(0xFFC24141),
                    fontSize: 12,
                  ),
                ),
              ],

              const SizedBox(height: 15),

              const Text(
                'Try a sample URL format',
                style: TextStyle(
                  color: navy,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(
                    avatar: const Icon(
                      Icons.public,
                      color: saffron,
                      size: 17,
                    ),
                    label: const Text('HTTPS URL'),
                    onPressed: () =>
                        _loadExample('https://example.com'),
                    backgroundColor: Colors.white,
                  ),
                  ActionChip(
                    avatar: const Icon(
                      Icons.short_text_rounded,
                      color: saffron,
                      size: 17,
                    ),
                    label: const Text('Short URL'),
                    onPressed: () =>
                        _loadExample('https://bit.ly/example'),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _checkLink,
                  icon: const Icon(Icons.shield),
                  label: const Text(
                    'Analyze Link',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: saffron,
                    foregroundColor: navy,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              if (_hasResult) ...[
                const SizedBox(height: 30),

                const Text(
                  'Analysis Result',
                  style: TextStyle(
                    color: navy,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 13),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(19),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _resultColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _resultIcon,
                            color: _resultColor,
                            size: 29,
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              _resultTitle,
                              style: TextStyle(
                                color: _resultColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 13),

                      SelectableText(
                        _checkedUrl,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        _resultDescription,
                        style: const TextStyle(
                          color: muted,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 19),

                      const Text(
                        'Detected indicators',
                        style: TextStyle(
                          color: navy,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 10),

                      if (_warnings.isEmpty)
                        const _WarningRow(
                          icon: Icons.info_outline_rounded,
                          color: muted,
                          text: 'No basic structural warning patterns matched.',
                        )
                      else
                        ..._warnings.map(
                              (warning) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _WarningRow(
                              icon: Icons.warning_amber_rounded,
                              color: _resultColor,
                              text: warning,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5DD),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF916000),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This is a local structural check only. '
                              'No domain reputation, phishing database, '
                              'redirect chain, or website content was checked. '
                              'A clean result does not guarantee safety.',
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
              ],

              const SizedBox(height: 27),

              const Text(
                'Stay Safe Online',
                style: TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 13),

              const _SafetyTip(
                icon: Icons.language_rounded,
                title: 'Check the domain',
                subtitle:
                'Look for misspellings and fake look-alike domains.',
              ),

              const SizedBox(height: 12),

              const _SafetyTip(
                icon: Icons.password_rounded,
                title: 'Protect sensitive details',
                subtitle:
                'Never enter OTPs, passwords, or banking PINs on an '
                    'unverified website.',
              ),

              const SizedBox(height: 12),

              const _SafetyTip(
                icon: Icons.verified_user_outlined,
                title: 'Verify independently',
                subtitle:
                'Visit the official website by typing its address '
                    'yourself or using its official app.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WarningRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _WarningRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 19),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF455165),
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _SafetyTip extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SafetyTip({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFD98E04).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFD98E04),
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
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
                    fontSize: 12,
                    height: 1.5,
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
