import 'package:admin_dating/screens/users/add_proffile_screen.dart';
import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<bool> _isSelected = [true, false, false];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 1,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      "Users",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
      
              // Top Filters
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB3B367),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text("Bff",
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF9ACD32),
                        shape: BoxShape.rectangle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(10),
                      selectedColor: Colors.white,
                      fillColor: const Color(0xFF12123C),
                      color: Colors.black,
                      isSelected: _isSelected,
                      onPressed: (index) {
                        setState(() {
                          for (int i = 0; i < _isSelected.length; i++) {
                            _isSelected[i] = i == index;
                          }
                        });
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('daily'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('weekly'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Annually'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      
              const SizedBox(height: 16),
      
              // Statistics Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text("Statistics",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Text("Total User",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF12123C))),
                  ],
                ),
              ),
      
              const SizedBox(height: 8),
      
              // Circular Chart & Time
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Expanded(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: MultiLayerCircle(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SingleChildScrollView(
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("7 Hr 32m",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            _buildStatItem(const Color(0xFFB2D12E), "+2.98%",
                                "Vs Previous Day", Colors.green),
                            const SizedBox(height: 12),
                            _buildStatItem(const Color(0xFF676A44), "-28.02%",
                                "Vs Previous Day", Colors.red),
                            const SizedBox(height: 12),
                            _buildStatItem(const Color(0xFFBCC682), "-38.02%",
                                "Vs Previous Day", Colors.red),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
      
              const SizedBox(height: 20),
      
              // Search and Filters
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search By ID......',
                          prefixIcon: const Icon(Icons.search),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide:
                                const BorderSide(color: Color(0xFFB2D12E)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB2B367),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text('All', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD5D6B1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Text('Sort By'),
                          Icon(Icons.swap_vert),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                   GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                     '/addprofilescreen',
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9ACD32),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                )
      
                  ],
                ),
              ),
      
              const SizedBox(height: 16),
      
              // Tabs
              TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFFB2D12E),
                labelColor: const Color(0xFF12123C),
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Active'),
                  Tab(text: 'Banned'),
                  Tab(text: 'Pending'),
                ],
              ),
      
              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildUserList(),
                    _buildUserList(),
                    _buildUserList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
      Color dotColor, String value, String label, Color textColor) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(value,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _iconButton(IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: Colors.white),
    );
  }

  Widget _buildUserList() {
  final List<Map<String, dynamic>> users = [
    {
      'name': 'Sangar Jayaram',
      'status': 'Verified',
      'time': '11:20 AM',
      'date': '15 Feb',
      'image': 'assets/images/profile_insights_tab1.png',
      'isVerified': true,
    },
    {
      'name': 'Olivia Williams',
      'status': 'Verified',
      'time': '07:20 PM',
      'date': '14 Feb',
      'image': 'assets/images/profile_insights_tab1.png',
      'isVerified': true,
    },
    {
      'name': 'John Davis',
      'status': 'Un Verified',
      'time': '06:20 PM',
      'date': '13 Feb',
      'image': 'assets/images/profile_insights_tab1.png',
      'isVerified': false,
    },
  ];

  return ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    itemCount: users.length,
    separatorBuilder: (context, index) => const Divider(
      thickness: 2,
      color: Color(0xFFB2D12E),
    ),
    itemBuilder: (context, index) {
      final user = users[index];
      final String name = user['name'] as String;
      final String status = user['status'] as String;
      final String time = user['time'] as String;
      final String date = user['date'] as String;
      final String image = user['image'] as String;
      final bool isVerified = user['isVerified'] as bool;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Name + Status + Action Buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Verified
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Icon(
                          isVerified ? Icons.verified : Icons.error,
                          size: 16,
                          color:
                              isVerified ? Color(0xFF9ACD32) : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isVerified ? Color(0xFF9ACD32) : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 8),

                // Action Buttons
                Row(
                  children: [
                    _iconButton(Icons.list, const Color(0xFF4AC3F1)),
                    const SizedBox(width: 8),
                    _iconButton(Icons.edit, const Color(0xFF8DE28F)),
                    const SizedBox(width: 8),
                    _iconButton(Icons.close, const Color(0xFFFDA67E)),
                  ],
                )
              ],
            ),
          ),

          // Date + Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          )
        ],
      );
    },
  );
}

}

class MultiLayerCircle extends StatelessWidget {
  const MultiLayerCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(150, 150),
      painter: CircleGraphPainter(),
    );
  }
}

class CircleGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final strokeWidths = [10.0, 10.0, 10.0];
    final colors = [
      const Color(0xFFB2D12E),
      const Color(0xFF676A44),
      const Color(0xFFBCC682),
    ];
    final percentages = [0.75, 0.55, 0.3];

    for (int i = 0; i < 3; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidths[i]
        ..strokeCap = StrokeCap.round;

      final adjustedRadius = radius - (i * 14);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: adjustedRadius),
        -3.14 / 2,
        2 * 3.14 * percentages[i],
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
