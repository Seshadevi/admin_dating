import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutCompanyPage extends ConsumerStatefulWidget {
  const AboutCompanyPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AboutCompanyPage> createState() => _AboutCompanyPageState();
}

class _AboutCompanyPageState extends ConsumerState<AboutCompanyPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  bool _showScrollProgress = false;
  double _scrollProgress = 0.0;
  int _expandedSection = -1;
  int _selectedTab = 0;

  final List<String> _tabTitles = [
    'Company',
    'Technology',
    'Values',
    'Contact'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);

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
    _pulseController.dispose();
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
          'About EVER QPID',
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
            onPressed: () => _showShareSheet(),
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
            // Tab Navigation
            Container(
              margin: const EdgeInsets.fromLTRB(16, 120, 16, 0),
              child: _buildTabNavigation(),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced Header with Hero Animation
                    _buildHeroHeader(),

                    const SizedBox(height: 32),

                    // Tab Content
                    _buildTabContent(),
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

  Widget _buildTabNavigation() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: _tabTitles.asMap().entries.map((entry) {
          int index = entry.key;
          String title = entry.value;
          bool isSelected = _selectedTab == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFA5C63B)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHeroHeader() {
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
          // Animated Logo with Pulse Effect
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFA5C63B),
                        const Color(0xFFA5C63B).withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFA5C63B).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Animated Title
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1500),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: const Text(
                    'EVER QPID',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFA5C63B),
                      letterSpacing: 2.5,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          Text(
            'Where Hearts Connect Forever',
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
                  Icons.business,
                  size: 18,
                  color: const Color(0xFFA5C63B),
                ),
                const SizedBox(width: 8),
                const Text(
                  'SOMEET TECH SOLUTIONS PVT LTD',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFA5C63B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Stats Row
          _buildQuickStats(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem("2025", "Founded", Icons.calendar_today),
        Container(width: 1, height: 30, color: const Color(0xFFA5C63B).withOpacity(0.3)),
        _buildStatItem("10K+", "Users", Icons.people),
        Container(width: 1, height: 30, color: const Color(0xFFA5C63B).withOpacity(0.3)),
        _buildStatItem("500+", "Matches", Icons.favorite),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFFA5C63B)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFFA5C63B),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildCompanyTab();
      case 1:
        return _buildTechnologyTab();
      case 2:
        return _buildValuesTab();
      case 3:
        return _buildContactTab();
      default:
        return _buildCompanyTab();
    }
  }

  Widget _buildCompanyTab() {
    return Column(
      children: [
        _buildInteractiveCard(
          "Company Information",
          "**SOMEET TECH SOLUTIONS PRIVATE LIMITED**\n\nSOMEET TECH SOLUTIONS is the innovative technology company behind EVER QPID, India's premier dating application. Incorporated on 7th August 2025 under the Companies Act, 2013.\n\n**Registration Details:**\n• CIN: U62099TS2025PTC202042\n• PAN: ABQCS9305N\n• TAN: HYDS88066G\n• Registered State: Telangana, India",
          Icons.business,
          Colors.blue,
          0,
        ),
        _buildInteractiveCard(
          "Our Mission",
          "To revolutionize online dating by creating a safe, inclusive, and meaningful platform where genuine connections flourish. We believe that finding love should be an empowering journey.\n\n• Fostering authentic relationships\n• Promoting respectful interactions\n• Ensuring user safety and privacy\n• Celebrating diversity and inclusion",
          Icons.macro_off_outlined,
          Colors.green,
          1,
        ),
        _buildInteractiveCard(
          "Our Vision",
          "To become India's most trusted platform for meaningful relationships, where every person can find their perfect match regardless of their background, preferences, or location.\n\n• Technology enhances human connection\n• Safe and respectful online dating\n• Indian values meet modern convenience",
          Icons.visibility,
          Colors.purple,
          2,
        ),
        _buildInteractiveCard(
          "Legal & Compliance",
          "SOMEET TECH SOLUTIONS operates in full compliance with Indian laws:\n\n• Companies Act, 2013 compliance\n• IT Act, 2000 data protection\n• Regular statutory filings\n• Corporate governance standards\n• Tax compliance (PAN & TAN registered)",
          Icons.gavel,
          Colors.orange,
          3,
        ),
      ],
    );
  }

  Widget _buildTechnologyTab() {
    return Column(
      children: [
        _buildInteractiveCard(
          "Mobile Development",
          "• Flutter for cross-platform development\n• Native iOS and Android optimization\n• Real-time messaging and video calling\n• Advanced UI/UX design\n• Progressive Web App support\n• Offline functionality",
          Icons.phone_android,
          Colors.blue,
          4,
        ),
        _buildInteractiveCard(
          "Backend & Infrastructure",
          "• Node.js backend architecture\n• Cloud-based scalable infrastructure\n• Real-time database management\n• Advanced security protocols\n• API-first development\n• Microservices architecture",
          Icons.dns,
          Colors.indigo,
          5,
        ),
        _buildInteractiveCard(
          "AI & Machine Learning",
          "• Smart matching algorithms\n• Behavioral analysis for compatibility\n• Content moderation systems\n• Personalized user experiences\n• Predictive analytics\n• Natural language processing",
          Icons.psychology,
          Colors.cyan,
          6,
        ),
      ],
    );
  }

  Widget _buildValuesTab() {
    return Column(
      children: [
        _buildInteractiveCard(
          "Authenticity",
          "We promote genuine interactions and real connections. No fake profiles, no deception – just real people looking for real love.\n\n• Profile verification systems\n• Real photo requirements\n• Identity confirmation processes",
          Icons.verified_user,
          Colors.green,
          7,
        ),
        _buildInteractiveCard(
          "Safety First",
          "User safety is our top priority. We implement robust security measures and moderation systems.\n\n• 24/7 content moderation\n• Advanced reporting tools\n• Background verification\n• Safe meeting guidelines",
          Icons.shield,
          Colors.red,
          8,
        ),
        _buildInteractiveCard(
          "Cultural Respect",
          "Respecting Indian traditions while embracing modern dating, honoring family values and cultural diversity.\n\n• Cultural compatibility matching\n• Family-friendly features\n• Regional language support\n• Festival celebrations",
          Icons.people,
          Colors.amber,
          9,
        ),
        _buildInteractiveCard(
          "Innovation",
          "Continuously evolving our platform using the latest technology to improve user experience.\n\n• Regular feature updates\n• User feedback integration\n• Cutting-edge technology adoption\n• Industry trend analysis",
          Icons.lightbulb,
          Colors.purple,
          10,
        ),
      ],
    );
  }

  Widget _buildContactTab() {
    return Column(
      children: [
        _buildContactCard(),
        const SizedBox(height: 20),
        _buildOfficeLocationCard(),
        const SizedBox(height: 20),
        _buildSocialMediaCard(),
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
                          isExpanded ? 'Tap to collapse' : 'Tap to expand',
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
            const Color(0xFFA5C63B).withOpacity(0.1),
            const Color(0xFFA5C63B).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFA5C63B).withOpacity(0.2),
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
                  color: const Color(0xFFA5C63B),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.contact_phone,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFA5C63B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildContactItem(Icons.email, "General Inquiries", "info@someettech.com"),
          _buildContactItem(Icons.support_agent, "Customer Support", "support@everqpid.com"),
          _buildContactItem(Icons.business_center, "Business Inquiries", "business@everqpid.com"),
          _buildContactItem(Icons.build, "Technical Support", "tech@everqpid.com"),
          _buildContactItem(Icons.gavel, "Legal & Compliance", "legal@someettech.com"),
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
            color: const Color(0xFFA5C63B).withOpacity(0.7),
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
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFFA5C63B),
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

  Widget _buildOfficeLocationCard() {
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
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Registered Office',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
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
              color: Colors.blue.withOpacity(0.05),
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
                  'CIN: U62099TS2025PTC202042\nPAN: ABQCS9305N\nTAN: HYDS88066G',
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

  Widget _buildSocialMediaCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.purple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purple.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Connect With Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(Icons.language, "Website", Colors.blue),
              _buildSocialButton(Icons.facebook, "Facebook", Colors.blue.shade800),
              _buildSocialButton(Icons.alternate_email, "Twitter", Colors.lightBlue),
              _buildSocialButton(Icons.video_library, "YouTube", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $label...')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
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
          icon: const Icon(Icons.apps),
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

  void _showShareSheet() {
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
              'Share EVER QPID',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.link, "Copy Link", Colors.blue),
                _buildShareOption(Icons.share, "Share App", Colors.green),
                _buildShareOption(Icons.email, "Email", Colors.orange),
                _buildShareOption(Icons.message, "Message", Colors.purple),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label feature coming soon!')),
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
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildQuickActionTile(
              Icons.download,
              'Download Company Profile',
              'Get PDF version',
                  () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Download starting...')),
                );
              },
            ),
            _buildQuickActionTile(
              Icons.contact_phone,
              'Contact Support',
              'Get help or ask questions',
                  () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening support...')),
                );
              },
            ),
            _buildQuickActionTile(
              Icons.feedback,
              'Send Feedback',
              'Share your thoughts',
                  () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feedback form opening...')),
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
