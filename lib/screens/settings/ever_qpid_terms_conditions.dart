import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TermsAndConditionsPage extends ConsumerStatefulWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends ConsumerState<TermsAndConditionsPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _showScrollProgress = false;
  double _scrollProgress = 0.0;
  int _expandedSection = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      setState(() {
        _scrollProgress = currentScroll / maxScroll;
        _showScrollProgress = currentScroll > 100;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFA5C63B),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.share, color: Colors.white, size: 20),
            ),
            onPressed: () {
              // Add share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon!')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: _showScrollProgress
            ? PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            color: Colors.white.withOpacity(0.2),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _scrollProgress,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        )
            : null,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFFA5C63B),
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 120, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Header with Animation
              _buildAnimatedHeader(),

              const SizedBox(height: 32),

              // Quick Navigation Menu
              _buildQuickNavigation(),

              const SizedBox(height: 32),

              // Enhanced Sections
              ..._buildEnhancedSections(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildSmartFAB(),
    );
  }

  Widget _buildAnimatedHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFA5C63B).withOpacity(0.15),
            const Color(0xFFA5C63B).withOpacity(0.08),
            const Color(0xFFA5C63B).withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA5C63B).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Animated Logo
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1200),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA5C63B),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFA5C63B).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Animated Title
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: const Text(
                    'EVER QPID',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFA5C63B),
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          Text(
            'Terms and Conditions of Use',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFA5C63B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFA5C63B).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.update,
                  size: 16,
                  color: const Color(0xFFA5C63B),
                ),
                const SizedBox(width: 8),
                Text(
                  'Updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFFA5C63B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Reading time estimate
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.orange.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  '~8 min read',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickNavigation() {
    final sections = [
      {'title': 'Introduction', 'icon': Icons.info_outline},
      {'title': 'Eligibility', 'icon': Icons.person_outline},
      {'title': 'Content', 'icon': Icons.content_copy_outlined},
      {'title': 'Licensing', 'icon': Icons.important_devices},
      {'title': 'Conduct', 'icon': Icons.rule_outlined},
      {'title': 'Safety', 'icon': Icons.security_outlined},
      {'title': 'Payments', 'icon': Icons.payment_outlined},
      {'title': 'Privacy', 'icon': Icons.privacy_tip_outlined},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book,
                color: const Color(0xFFA5C63B),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Navigation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sections.map((section) {
              return GestureDetector(
                onTap: () {
                  // Scroll to section (you can implement this)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Scrolling to ${section['title']}')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA5C63B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFA5C63B).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        section['icon'] as IconData,
                        size: 16,
                        color: const Color(0xFFA5C63B),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        section['title'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFFA5C63B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEnhancedSections() {
    final sections = [
      {
        'title': 'Introduction',
        'icon': Icons.info_outline,
        'content': "Welcome to EVER QPID's Terms and Conditions of Use (these 'Terms'). This is a contract between you and EVER QPID and we want you to know yours and our rights before you use the EVER QPID mobile application ('EVER QPID' or the 'App'). Please take a few moments to read these Terms before enjoying the App, because once you access, view or use the App, you are going to be legally bound by these Terms.\n\nPlease also read our Community Guidelines (which form part of these Terms) and our Privacy Policy.\n\nBy using EVER QPID, you agree to be bound by these Terms, our Privacy Policy, and our Community Guidelines.",
        'color': Colors.blue,
      },
      {
        'title': '1. ELIGIBILITY AND ACCOUNT REGISTRATION',
        'icon': Icons.person_outline,
        'content': "Before you can use the App, you will need to register for an account ('Account'). In order to create an Account you must:\n\n• Be at least 18 years old or the age of majority to legally enter into a contract under the laws of your home country if that happens to be greater than 18\n• Be legally permitted to use the App by the laws of your home country\n• Provide accurate, current and complete information about yourself\n• Use your real name and real age in creating your EVER QPID account\n• Not have been previously removed from the service by us for violation of these Terms\n\nPlease note that we monitor for underage use and we will terminate, suspend or ask you to verify your Account if we have reason to believe that you may be underage.\n\nYou are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.",
        'color': Colors.green,
      },
      {
        'title': '2. TYPES OF CONTENT',
        'icon': Icons.content_copy_outlined,
        'content': "There are three types of content that you will be able to access on the App:\n\n• Content that you upload and provide ('Your Content')\n• Content that members provide ('Member Content')\n• Content that EVER QPID provides (including, without limitation, database(s) and/or software) ('Our Content')\n\n**Content Restrictions**\n\nThere is certain content we can't allow on EVER QPID. Our Community Guidelines form part of these Terms and outline what content and conduct is accepted on and off our App. You agree to comply with our Community Guidelines as may be updated from time to time.",
        'color': Colors.purple,
      },
      {
        'title': '3. YOUR CONTENT AND LICENSING',
        'icon': Icons.important_devices,
        'content': "**Your Content**\n\nAs Your Content is unique, you are responsible and liable for Your Content. You will indemnify, defend, release, and hold us harmless from any claims made in connection with Your Content.\n\nBy uploading Your Content on EVER QPID, you represent and warrant to us that you have all necessary rights and licenses to do so, and automatically grant us a non-exclusive, royalty-free, perpetual, worldwide license to use Your Content in any way (including, without limitation, editing, copying, modifying, adapting, translating, reformatting, creating derivative works from, incorporating into other works, advertising, distributing and otherwise making available to the general public such Content).",
        'color': Colors.orange,
      },
      {
        'title': '4. PROHIBITED USES AND CONDUCT',
        'icon': Icons.rule_outlined,
        'content': "You agree to:\n• Comply with all applicable laws, including privacy laws, intellectual property laws, anti-spam laws, and regulatory requirements\n• Use the services in a safe, inclusive and respectful manner\n• Adhere to our Community Guidelines at all times\n\nYou agree that you will NOT:\n• Act in an unlawful or disrespectful manner including being dishonest, abusive or discriminatory\n• Misrepresent your identity, age, current or previous positions, qualifications or affiliations\n• Stalk or harass any other user of the App\n• Use the App in any deceptive, inauthentic or manipulative way",
        'color': Colors.red,
      },
      {
        'title': '5. SAFETY AND SECURITY',
        'icon': Icons.security_outlined,
        'content': "**Background Checks**\n\nIn certain circumstances, such as in response to member-generated or press reports of suspected misconduct, EVER QPID may investigate whether a member has a criminal history, which may include searching sex offender registries or other public records.\n\n**Safety Measures**\n\nWe use a combination of automated systems, user reports and a team of moderators to monitor and review accounts and content to identify breaches of these Terms.\n\n**User Responsibility**\n\nYou are solely responsible for your interactions with other users of the App. EVER QPID does not conduct criminal background checks on all members and cannot guarantee the safety or conduct of any user.",
        'color': Colors.cyan,
      },
      {
        'title': '6. PAYMENT TERMS AND SUBSCRIPTIONS',
        'icon': Icons.payment_outlined,
        'content': "**In-App Purchases**\n\nEVER QPID may offer products and services for purchase on the App ('In-App Purchase'). If you choose to make an In-App Purchase, additional terms may apply.\n\n**Payment Methods**\n\nYou may make an In-App Purchase through:\n• Third-party platforms such as the Apple App Store and Google Play Store\n• Credit card, debit card, or PayPal account processed by a third-party processor",
        'color': Colors.amber,
      },
      {
        'title': '7. PRIVACY',
        'icon': Icons.privacy_tip_outlined,
        'content': "For information about how EVER QPID collects, uses, and shares your personal data, please check out our Privacy Policy. By using EVER QPID, you acknowledge that we may use such data in accordance with our Privacy Policy.\n\n**Data Collection**\n\nWe collect information you provide directly to us, information we collect automatically when you use our services, and information we collect from other sources.",
        'color': Colors.indigo,
      },
    ];

    return sections.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> section = entry.value;

      return _buildExpandableSection(
        title: section['title'] as String,
        content: section['content'] as String,
        icon: section['icon'] as IconData,
        color: section['color'] as Color,
        index: index,
        isLast: index == sections.length - 1,
      );
    }).toList();
  }

  Widget _buildExpandableSection({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
    required int index,
    bool isLast = false,
  }) {
    final isExpanded = _expandedSection == index;

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 80 : 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded
              ? color.withOpacity(0.3)
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: isExpanded ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? color.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            blurRadius: isExpanded ? 15 : 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _expandedSection = isExpanded ? -1 : index;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isExpanded ? 'Tap to collapse' : 'Tap to read more',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: color,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartFAB() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Scroll to top FAB
        if (_showScrollProgress)
          FloatingActionButton(
            heroTag: "scroll_top",
            onPressed: () => _scrollToTop(),
            backgroundColor: const Color(0xFFA5C63B),
            foregroundColor: Colors.white,
            mini: true,
            child: const Icon(Icons.keyboard_arrow_up),
          ),

        const SizedBox(height: 8),

        // Main FAB with actions
        FloatingActionButton.extended(
          heroTag: "main_fab",
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => _buildQuickActionsSheet(),
            );
          },
          backgroundColor: const Color(0xFFA5C63B),
          foregroundColor: Colors.white,
          label: const Text('Quick Actions'),
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 20),

          _buildQuickActionTile(
            icon: Icons.download,
            title: 'Download PDF',
            subtitle: 'Save terms as PDF',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF download coming soon!')),
              );
            },
          ),

          _buildQuickActionTile(
            icon: Icons.language,
            title: 'Translate',
            subtitle: 'Available in multiple languages',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Translation feature coming soon!')),
              );
            },
          ),

          _buildQuickActionTile(
            icon: Icons.help_outline,
            title: 'Need Help?',
            subtitle: 'Contact our support team',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening support...')),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuickActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFA5C63B).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFA5C63B),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      ),
      onTap: onTap,
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }
}
