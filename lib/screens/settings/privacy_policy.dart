import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrivacyPolicyPage extends ConsumerStatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends ConsumerState<PrivacyPolicyPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late AnimationController _shieldController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shieldRotation;
  bool _showScrollProgress = false;
  double _scrollProgress = 0.0;
  int _expandedSection = -1;
  int _selectedCategory = 0;

  final List<String> _categories = [
    'Overview',
    'Data Collection',
    'Your Rights',
    'Security',
    'Contact'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _shieldController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _shieldRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shieldController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _shieldController.repeat();

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
    _shieldController.dispose();
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
          'Privacy Policy',
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
              child: const Icon(Icons.download, color: Colors.white, size: 20),
            ),
            onPressed: () => _showDownloadOptions(),
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
        child: Column(
          children: [
            // Category Navigation
            Container(
              margin: const EdgeInsets.fromLTRB(16, 120, 16, 0),
              child: _buildCategoryNavigation(),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced Privacy Hero Section
                    _buildPrivacyHero(),

                    const SizedBox(height: 32),

                    // Privacy Summary Cards
                    _buildPrivacySummary(),

                    const SizedBox(height: 32),

                    // Category Content
                    _buildCategoryContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildSmartFAB(),
    );
  }

  Widget _buildCategoryNavigation() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFA5C63B)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFA5C63B)
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                ),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: const Color(0xFFA5C63B).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : [],
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrivacyHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
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
        borderRadius: BorderRadius.circular(24),
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
          // Animated Privacy Shield
          AnimatedBuilder(
            animation: _shieldRotation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _shieldRotation.value * 0.1,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade600,
                        Colors.blue.shade800,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.security,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Title
          const Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Color(0xFFA5C63B),
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Your Privacy, Our Priority',
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          // Company Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFA5C63B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFA5C63B).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified,
                  size: 18,
                  color: const Color(0xFFA5C63B),
                ),
                const SizedBox(width: 8),
                const Text(
                  'SOMEET TECH SOLUTIONS PVT LTD',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFA5C63B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Last Updated Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.update,
                  size: 16,
                  color: Colors.blue,
                ),
                const SizedBox(width: 6),
                Text(
                  'Last Updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
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

  Widget _buildPrivacySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy at a Glance',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                Icons.lock,
                'Data Protection',
                'Your data is encrypted and secured',
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                Icons.visibility_off,
                'No Selling',
                'We never sell your information',
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                Icons.control_point,
                'Your Control',
                'Manage your privacy settings',
                Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                Icons.location_on,
                'India Based',
                'Data stored in India',
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryContent() {
    switch (_selectedCategory) {
      case 0:
        return _buildOverviewCategory();
      case 1:
        return _buildDataCollectionCategory();
      case 2:
        return _buildYourRightsCategory();
      case 3:
        return _buildSecurityCategory();
      case 4:
        return _buildContactCategory();
      default:
        return _buildOverviewCategory();
    }
  }

  Widget _buildOverviewCategory() {
    return Column(
      children: [
        _buildInteractiveCard(
          "Introduction",
          "SOMEET TECH SOLUTIONS PRIVATE LIMITED operates the EVER QPID mobile application. This Privacy Policy explains how we collect, use, disclose, and protect your personal information when you use our dating application.\n\n**Company Details:**\n• CIN: U62099TS2025PTC202042\n• Registered Office: 2-46, BODAMPAHAD, Shahabad, Telangana\n• Incorporation Date: 7th August 2025",
          Icons.info_outline,
          Colors.blue,
          0,
        ),
        _buildInteractiveCard(
          "What We Do",
          "We help people find meaningful connections through our dating platform. To provide this service, we collect and process certain personal information in accordance with applicable privacy laws.\n\n• We prioritize your privacy and security\n• We comply with Indian data protection laws\n• We give you control over your information\n• We're transparent about our practices",
          Icons.favorite,
          Colors.pink,
          1,
        ),
        _buildInteractiveCard(
          "Legal Compliance",
          "We comply with all applicable Indian and international privacy laws:\n\n• Information Technology Act, 2000\n• IT (Reasonable Security Practices) Rules, 2011\n• GDPR for EU users\n• CCPA for California users\n• Industry best practices for data protection",
          Icons.gavel,
          Colors.orange,
          2,
        ),
      ],
    );
  }

  Widget _buildDataCollectionCategory() {
    return Column(
      children: [
        _buildInteractiveCard(
          "Information You Provide",
          "**Account & Profile Information:**\n• Name, email, phone number, date of birth\n• Profile photos and bio\n• Preferences and interests\n• Identity verification documents\n\n**Communications:**\n• Messages with other users\n• Customer support interactions\n• Survey responses and feedback",
          Icons.person_add,
          Colors.green,
          3,
        ),
        _buildInteractiveCard(
          "Information We Collect Automatically",
          "**Device & Usage Data:**\n• Device type, operating system, unique identifiers\n• App features used, time spent, interactions\n• Location data (with your permission)\n• Log data (IP address, access times)\n\n**Media Access:**\n• Camera and photo library (with permission)\n• Contacts (with permission, for friend-finding)",
          Icons.smartphone,
          Colors.blue,
          4,
        ),
        _buildInteractiveCard(
          "Third-Party Information",
          "**From External Sources:**\n• Social media account information (if connected)\n• Identity verification services\n• Business partners and service providers\n• Publicly available information\n\n**Note:** We only collect third-party information when legally permitted and with appropriate safeguards.",
          Icons.connect_without_contact,
          Colors.purple,
          5,
        ),
      ],
    );
  }

  Widget _buildYourRightsCategory() {
    return Column(
      children: [
        _buildInteractiveCard(
          "Access & Control",
          "**Your Account Controls:**\n• View and edit your profile information\n• Download your data through app settings\n• Control who can see your profile\n• Manage notification preferences\n• Block or report other users\n\n**Privacy Settings:**\n• Control location sharing\n• Manage photo visibility\n• Set discovery preferences",
          Icons.settings,
          Colors.blue,
          6,
        ),
        _buildInteractiveCard(
          "Data Rights (Indian Law)",
          "**Under Indian Privacy Laws:**\n• Right to access your personal data\n• Right to correct inaccurate information\n• Right to delete your data (right to be forgotten)\n• Right to data portability\n• Right to withdraw consent\n• Right to lodge complaints with authorities",
          Icons.verified_user,
          Colors.green,
          7,
        ),
        _buildInteractiveCard(
          "Account Management",
          "**Account Deletion:**\n• Delete your account through app settings\n• Contact support for assistance\n• Data will be removed within 30 days\n• Some information may be retained for legal compliance\n\n**Marketing Communications:**\n• Unsubscribe from promotional emails\n• Opt out of push notifications\n• Control in-app marketing messages",
          Icons.delete_forever,
          Colors.red,
          8,
        ),
      ],
    );
  }

  Widget _buildSecurityCategory() {
    return Column(
      children: [
        _buildInteractiveCard(
          "Data Protection Measures",
          "**Security Technologies:**\n• Encryption of data in transit and at rest\n• Regular security assessments and updates\n• Access controls and authentication measures\n• Secure development practices\n• Employee training on data protection\n• Incident response procedures",
          Icons.shield,
          Colors.blue,
          9,
        ),
        _buildInteractiveCard(
          "Data Storage & Location",
          "**Data Location:**\nYour data is primarily stored on servers located in India, in compliance with Indian data localization requirements.\n\n**Retention Policy:**\n• Account data: While your account is active\n• Messages: Stored for service functionality\n• Usage data: For analytics purposes\n• Deleted data: Removed within 30 days\n• Legal compliance: As required by law",
          Icons.storage,
          Colors.green,
          10,
        ),
        _buildInteractiveCard(
          "Breach Response",
          "**In Case of Data Breach:**\n• Immediate investigation and containment\n• Notification to affected users within 72 hours\n• Reporting to relevant authorities as required\n• Implementation of corrective measures\n• Regular security audits and improvements\n\n**Your Safety:** We treat data security as our highest priority.",
          Icons.warning,
          Colors.orange,
          11,
        ),
      ],
    );
  }

  Widget _buildContactCategory() {
    return Column(
      children: [
        _buildContactCard(),
        const SizedBox(height: 20),
        _buildCompanyDetailsCard(),
        const SizedBox(height: 20),
        _buildResponseTimeCard(),
      ],
    );
  }

  Widget _buildInteractiveCard(
      String title,
      String content,
      IconData icon,
      Color color,
      int index,
      ) {
    final isExpanded = _expandedSection == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isExpanded
              ? color.withOpacity(0.3)
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: isExpanded ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? color.withOpacity(0.15)
                : Colors.black.withOpacity(0.05),
            blurRadius: isExpanded ? 20 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedSection = isExpanded ? -1 : index;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.2),
                          color.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isExpanded ? 'Tap to collapse' : 'Tap to read details',
                          style: TextStyle(
                            fontSize: 13,
                            color: color.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: color,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.05),
                      color.withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: color.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 15,
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
            duration: const Duration(milliseconds: 400),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.contact_support,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Privacy Contacts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildContactItem(Icons.privacy_tip, "Privacy Inquiries", "privacy@everqpid.com"),
          _buildContactItem(Icons.security, "Data Protection Officer", "dpo@someettech.com"),
          _buildContactItem(Icons.gavel, "Legal Department", "legal@someettech.com"),
          _buildContactItem(Icons.support_agent, "Customer Support", "support@everqpid.com"),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String contact) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.blue.withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  contact,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.blue,
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

  Widget _buildCompanyDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFA5C63B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.business,
                  color: Color(0xFFA5C63B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Company Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFA5C63B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'SOMEET TECH SOLUTIONS PRIVATE LIMITED',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '2-46, BODAMPAHAD\nShahabad (K.V.Rangareddy)\nK.V.Rangareddy - 509217\nTelangana, India',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFA5C63B).withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Corporate Details:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'CIN: U62099TS2025PTC202042\nPAN: ABQCS9305N\nTAN: HYDS88066G\nIncorporation: 7th August 2025',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseTimeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.green.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.green.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.schedule,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Response Times',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildResponseItem("Privacy Inquiries", "Within 30 days"),
          _buildResponseItem("Data Security Issues", "Within 72 hours"),
          _buildResponseItem("Account Deletion", "Within 30 days"),
          _buildResponseItem("General Support", "Within 24 hours"),
        ],
      ),
    );
  }

  Widget _buildResponseItem(String type, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartFAB() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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

        FloatingActionButton.extended(
          heroTag: "main_fab",
          onPressed: () => _showQuickActions(),
          backgroundColor: const Color(0xFFA5C63B),
          foregroundColor: Colors.white,
          label: const Text('Quick Actions'),
          icon: const Icon(Icons.security),
        ),
      ],
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _showDownloadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
            const Text(
              'Download Privacy Policy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDownloadOption(Icons.picture_as_pdf, "PDF", Colors.red),
                _buildDownloadOption(Icons.description, "Word", Colors.blue),
                _buildDownloadOption(Icons.code, "HTML", Colors.green),
                _buildDownloadOption(Icons.text_fields, "Text", Colors.orange),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadOption(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading $label version...')),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
            const Text(
              'Privacy Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildQuickActionTile(
              Icons.settings,
              'Manage Privacy Settings',
              'Control your privacy preferences',
                  () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening privacy settings...')),
                );
              },
            ),
            _buildQuickActionTile(
              Icons.delete_forever,
              'Request Data Deletion',
              'Delete your account and data',
                  () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening deletion request...')),
                );
              },
            ),
            _buildQuickActionTile(
              Icons.contact_support,
              'Contact Privacy Team',
              'Get help with privacy questions',
                  () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connecting to privacy support...')),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
      IconData icon,
      String title,
      String subtitle,
      VoidCallback onTap,
      ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFA5C63B).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFFA5C63B), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
