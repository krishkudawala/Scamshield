
import 'package:flutter/material.dart';

class SafetyArticle {
  final String title;
  final String category;
  final String subtitle;
  final String example;
  final String warningSigns;
  final List<String> safetySteps;
  final IconData icon;
  final Color color;

  const SafetyArticle({
    required this.title,
    required this.category,
    required this.subtitle,
    required this.example,
    required this.warningSigns,
    required this.safetySteps,
    required this.icon,
    required this.color,
  });
}

class SafetyEducationScreen extends StatefulWidget {
  const SafetyEducationScreen({super.key});

  @override
  State<SafetyEducationScreen> createState() =>
      _SafetyEducationScreenState();
}

class _SafetyEducationScreenState
    extends State<SafetyEducationScreen> {
  static const Color navy = Color(0xFF101B2D);
  static const Color saffron = Color(0xFFD98E04);
  static const Color background = Color(0xFFF5F7FA);
  static const Color muted = Color(0xFF687588);

  final TextEditingController _searchController =
  TextEditingController();

  String selectedCategory = 'All';

  final List<SafetyArticle> articles = const [
    SafetyArticle(
      title: 'UPI Payment Scams',
      category: 'Payments',
      subtitle: 'Stay alert while receiving or sending money.',
      example:
      'Someone claims they are sending you money and asks '
          'you to scan a QR code or enter your UPI PIN to receive it.',
      warningSigns:
      'Receiving money generally does not require entering your UPI PIN. '
          'A request to enter a PIN may authorize a payment instead.',
      safetySteps: [
        'Never enter your UPI PIN just to receive money.',
        'Read the payment app screen before approving a request.',
        'Verify unexpected payment requests with the person independently.',
        'Never share your UPI PIN, OTP or screen-sharing access.',
      ],
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFF3867D6),
    ),
    SafetyArticle(
      title: 'Fake Bank & KYC Messages',
      category: 'Banking',
      subtitle: 'Recognize account-blocking threats.',
      example:
      'Your bank account will be blocked today. Update your KYC '
          'immediately using this link.',
      warningSigns:
      'Threats of immediate account suspension and unexpected '
          'verification links may be used to steal banking details.',
      safetySteps: [
        'Do not open links from unexpected bank messages.',
        'Open the official bank app or type the official website yourself.',
        'Call the bank using a number from its official website or card.',
        'Never share an OTP, PIN or password with a caller or message sender.',
      ],
      icon: Icons.account_balance_outlined,
      color: Color(0xFFC24141),
    ),
    SafetyArticle(
      title: 'OTP & Account Takeover',
      category: 'Privacy',
      subtitle: 'Protect your accounts and identity.',
      example:
      'A caller claims to be support staff and asks you to tell '
          'them the OTP you just received.',
      warningSigns:
      'An OTP can authorize a login, account recovery or transaction. '
          'Unexpected requests to disclose it are dangerous.',
      safetySteps: [
        'Never disclose OTPs to another person.',
        'Do not approve login prompts you did not initiate.',
        'Use a strong, unique password and available account protections.',
        'If you shared an OTP, secure the account immediately through official channels.',
      ],
      icon: Icons.password_rounded,
      color: Color(0xFF8054C7),
    ),
    SafetyArticle(
      title: 'Phishing & Fake Websites',
      category: 'Links',
      subtitle: 'Spot suspicious links before opening them.',
      example:
      'A message claims you have won a prize and asks you to '
          'sign in through an unfamiliar website.',
      warningSigns:
      'Look-alike domains, unexpected login requests and shortened '
          'links can hide the true destination.',
      safetySteps: [
        'Check the complete domain spelling.',
        'Avoid signing in through links in unexpected messages.',
        'Visit the official website directly instead.',
        'Remember that HTTPS alone does not prove a website is trustworthy.',
      ],
      icon: Icons.link_rounded,
      color: Color(0xFFB7791F),
    ),
    SafetyArticle(
      title: 'Fake Job & Work-from-Home Offers',
      category: 'Jobs',
      subtitle: 'Be cautious of guaranteed income promises.',
      example:
      'You are promised a high daily income for easy tasks but '
          'must pay a registration or recharge fee first.',
      warningSigns:
      'Upfront fees, pressure to deposit money and guaranteed high '
          'returns may be warning signs of a scam.',
      safetySteps: [
        'Research the employer using independently found contact details.',
        'Do not pay unexplained recruitment or task-unlocking fees.',
        'Do not deposit money to unlock supposed earnings.',
        'Avoid sharing identity documents before verifying the organization.',
      ],
      icon: Icons.work_outline_rounded,
      color: Color(0xFF16834A),
    ),
    SafetyArticle(
      title: 'Lottery & Prize Scams',
      category: 'Rewards',
      subtitle: 'Unexpected prizes deserve extra checking.',
      example:
      'You receive a message saying you won a lottery you never entered '
          'and must pay a processing fee to claim it.',
      warningSigns:
      'Unexpected winnings, secrecy, urgency and advance-fee demands '
          'are common prize-scam warning signs.',
      safetySteps: [
        'Check whether you actually entered the contest.',
        'Verify the offer with the official organizer.',
        'Do not pay a fee to claim an unexpected prize.',
        'Do not share bank details or OTPs with an unknown sender.',
      ],
      icon: Icons.card_giftcard_rounded,
      color: Color(0xFFD16C35),
    ),
    SafetyArticle(
      title: 'Courier & Parcel Scams',
      category: 'Links',
      subtitle: 'Check delivery problems through official channels.',
      example:
      'A text says your parcel is on hold and demands a small fee '
          'through a link to release it.',
      warningSigns:
      'Unexpected small payments can be used to collect card details '
          'or lead to fake delivery websites.',
      safetySteps: [
        'Check tracking through the courier official app or website.',
        'Do not rely on links or phone numbers in an unexpected message.',
        'Do not enter card details on an unverified page.',
        'Contact the seller or courier through trusted contact details.',
      ],
      icon: Icons.local_shipping_outlined,
      color: Color(0xFF3B8292),
    ),
    SafetyArticle(
      title: 'Remote Access & Screen-Sharing Scams',
      category: 'Privacy',
      subtitle: 'Keep control of your phone and accounts.',
      example:
      'A caller tells you to install a remote-access app to fix a '
          'banking problem or receive a refund.',
      warningSigns:
      'Unexpected requests for screen sharing, device control or '
          'accessibility permissions can expose sensitive information.',
      safetySteps: [
        'Do not give unknown callers remote access to your device.',
        'Do not share your screen while banking or entering credentials.',
        'Install apps only from trusted sources for a verified purpose.',
        'If access was granted, disconnect and review permissions promptly.',
      ],
      icon: Icons.phonelink_lock_rounded,
      color: Color(0xFF526A86),
    ),
  ];

  final List<String> categories = const [
    'All',
    'Payments',
    'Banking',
    'Privacy',
    'Links',
    'Jobs',
    'Rewards',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SafetyArticle> get filteredArticles {
    final query = _searchController.text.trim().toLowerCase();

    return articles.where((article) {
      final matchesCategory = selectedCategory == 'All' ||
          article.category == selectedCategory;

      final searchableText = [
        article.title,
        article.category,
        article.subtitle,
        article.example,
        article.warningSigns,
      ].join(' ').toLowerCase();

      final matchesSearch =
          query.isEmpty || searchableText.contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _openArticle(SafetyArticle article) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.88,
          ),
          decoration: const BoxDecoration(
            color: background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              color: article.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              article.icon,
                              color: article.color,
                              size: 29,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article.title,
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  article.category,
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

                      const SizedBox(height: 23),

                      const _DetailHeading(
                        icon: Icons.message_outlined,
                        title: 'Example scenario',
                      ),
                      const SizedBox(height: 10),
                      _DetailCard(
                        color: Colors.white,
                        child: Text(
                          article.example,
                          style: const TextStyle(
                            color: navy,
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      const _DetailHeading(
                        icon: Icons.search_rounded,
                        title: 'Warning signs',
                      ),
                      const SizedBox(height: 10),
                      _DetailCard(
                        color: const Color(0xFFFFF5DD),
                        child: Text(
                          article.warningSigns,
                          style: const TextStyle(
                            color: Color(0xFF795500),
                            fontSize: 13,
                            height: 1.7,
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      const _DetailHeading(
                        icon: Icons.shield_outlined,
                        title: 'How to stay safe',
                      ),
                      const SizedBox(height: 12),

                      ...article.safetySteps.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 27,
                                width: 27,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD98E04)
                                      .withValues(alpha: 0.14),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${entry.key + 1}',
                                  style: const TextStyle(
                                    color: Color(0xFF916000),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 11),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 13,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 51,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Got It',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleArticles = filteredArticles;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Safety Education',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            // Main banner
            Container(
              padding: const EdgeInsets.all(21),
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(23),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: saffron.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      color: saffron,
                      size: 29,
                    ),
                  ),
                  const SizedBox(height: 19),
                  const Text(
                    'Know the Scam.\nStop the Scam.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Simple guides to help you recognize common '
                        'online fraud tactics and protect your money.',
                    style: TextStyle(
                      color: Color(0xFFADB8C9),
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 19),
                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_outlined,
                        color: saffron,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${articles.length} safety guides',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Learn to Protect Yourself',
              style: TextStyle(
                color: navy,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Choose a topic to read real-world examples and safety steps.',
              style: TextStyle(
                color: muted,
                fontSize: 12,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 17),

            // Search
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search scam types or safety tips...',
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
                    setState(() => _searchController.clear());
                  },
                  icon: const Icon(Icons.close_rounded),
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
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
              ),
            ),

            const SizedBox(height: 17),

            // Category filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  final selected = selectedCategory == category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: selected,
                      showCheckmark: false,
                      onSelected: (_) {
                        setState(() => selectedCategory = category);
                      },
                      selectedColor:
                      saffron.withValues(alpha: 0.18),
                      backgroundColor: Colors.white,
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

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Safety Guides',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${visibleArticles.length} topics',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 13),

            if (visibleArticles.isEmpty)
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      color: muted,
                      size: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No topics found',
                      style: TextStyle(
                        color: navy,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Try a different search or category.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...visibleArticles.map(
                    (article) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _SafetyArticleCard(
                    article: article,
                    onTap: () => _openArticle(article),
                  ),
                ),
              ),

            const SizedBox(height: 13),

            // General safety reminder
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5DD),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Color(0xFF916000),
                    size: 23,
                  ),
                  SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      'Golden rule: Never share an OTP, PIN or password, '
                          'and verify unexpected payment requests independently.',
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
          ],
        ),
      ),
    );
  }
}

class _SafetyArticleCard extends StatelessWidget {
  final SafetyArticle article;
  final VoidCallback onTap;

  const _SafetyArticleCard({
    required this.article,
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
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: article.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  article.icon,
                  color: article.color,
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        color: Color(0xFF101B2D),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      article.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF687588),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: article.color.withValues(alpha: 0.09),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        article.category,
                        style: TextStyle(
                          color: article.color,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF8993A1),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailHeading extends StatelessWidget {
  final IconData icon;
  final String title;

  const _DetailHeading({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFFD98E04),
          size: 22,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF101B2D),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final Color color;
  final Widget child;

  const _DetailCard({
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: child,
    );
  }
}
