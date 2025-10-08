import 'package:admin_dating/models/supscription/subscriptions_model.dart';
import 'package:admin_dating/provider/subscriptions/subscription_stats_provider.dart';
import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'package:admin_dating/screens/subscriptions/full_plans_get_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:admin_dating/constants/dating_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionsScreen extends ConsumerStatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  ConsumerState<SubscriptionsScreen> createState() =>
      _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends ConsumerState<SubscriptionsScreen> {
  DateTime? _lastPressedAt;

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastPressedAt == null ||
        now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
      _lastPressedAt = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Press back again to exit")),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ✅ Listen to WebSocket subscription stats
    final subscriptionStats = ref.watch(subscriptionStatsProvider);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
            backgroundColor: colorScheme.surface,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              'Subscriptions',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  color: DatingColors.primaryGreen,
                  tooltip: 'Add Subscription Plan',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FullPlansGetPage()),
                      // Or push to your add plan screen if available
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.filter_alt_outlined,
                  color: colorScheme.onSurface.withOpacity(0.7)),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
                  onSelected: (value) {
                    if (value == 'Features') {
                      Navigator.pushNamed(context, '/adminfeatures');
                    }
                    if (value == 'Plan') {
                      Navigator.pushNamed(context,
                          '/SubscriptionPlansListScreen'); // Your own plan page route
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Plan',
                      child: Text('Plan'),
                    ),
                    const PopupMenuItem(
                      value: 'Features',
                      child: Text('Features'),
                    ),
                  ],
                ),
              ),
            ]),
        body: subscriptionStats.when(
          data: (data) => _buildBody(context, data),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('❌ Error: $e')),
        ),
        // bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SubscriptionsModel data) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Plan Distribution",
            style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 12),

          // ✅ Dynamic pie chart showing top plans
          if (data.topPlans != null && data.topPlans!.isNotEmpty)
            PlanPercentagePieChart(
              topPlans: data.topPlans!,
              totalPercentage:
                  data.percentageOfUsersWithActivePlan, // from your model
            ),

          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _statBox(
                      context, "Customers", "${data.totalUsers ?? 0}", true)),
              const SizedBox(width: 12),
              Expanded(
                  child: _statBox(context, "Subscriptions",
                      "${data.totalActivePurchases ?? 0}", false)),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Top Subscriptions",
            style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 12),

          // ✅ Display top plans dynamically as bars
          if (data.topPlans != null && data.topPlans!.isNotEmpty)
            ...data.topPlans!.map((plan) => _barWithTooltip(
                context,
                plan.title ?? "Plan",
                "${plan.durationDays ?? 0} Days \$${plan.price ?? "0"}\nPurchased: ${plan.purchaseCount ?? 0}")),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _statBox(
      BuildContext context, String title, String value, bool gradient) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient
            ? LinearGradient(
                colors: [DatingColors.primaryGreen, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DatingColors.primaryGreen, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value,
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _barWithTooltip(
      BuildContext context, String label, String tooltipText) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              height: 20,
              width: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [DatingColors.primaryGreen, Colors.white]),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: tooltipText,
              child: Icon(Icons.info_outline,
                  size: 18, color: theme.colorScheme.onSurface),
            )
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class PlanPercentagePieChart extends StatelessWidget {
  final List<TopPlans> topPlans;
  final int? totalPercentage; // ✅ new field

  const PlanPercentagePieChart({
    super.key,
    required this.topPlans,
    this.totalPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.yellow,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sections: List.generate(topPlans.length, (i) {
                    final plan = topPlans[i];
                    final value = plan.percentageOfPurchases?.toDouble() ?? 0;

                    return PieChartSectionData(
                      color: colors[i % colors.length],
                      value: value,
                      title: '${value.toStringAsFixed(1)}%',
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      radius: 55,
                    );
                  }),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),

              // ✅ Show total percentage in the center
              Text(
                "${totalPercentage ?? 0}%",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ✅ Legend for individual plans
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: List.generate(topPlans.length, (i) {
            final plan = topPlans[i];
            final color = colors[i % colors.length];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "${plan.title ?? "Plan"} (${plan.percentageOfPurchases?.toStringAsFixed(1) ?? "0"}%)",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}



// import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
// import 'package:flutter/material.dart';
// import 'package:admin_dating/constants/dating_colors.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'full_plan_post_screen.dart';
// import 'full_plans_get_page.dart';
// import 'subscription_plans_list_screen.dart';

// class SubscriptionsScreen extends ConsumerStatefulWidget {

//   const SubscriptionsScreen({Key? key}) : super(key: key);
//   @override
//   ConsumerState<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
// }

// class _SubscriptionsScreenState extends ConsumerState<SubscriptionsScreen> {
  
//   DateTime? _lastPressedAt;
// Future<bool> _onWillPop() async {
//     final now = DateTime.now();
//     if (_lastPressedAt == null || now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
//       _lastPressedAt = now;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Press back again to exit")),
//       );
//       return false; // don’t exit
//     }
//     return true; // exit app
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: colorScheme.background,
//           appBar: AppBar(
//             backgroundColor: colorScheme.surface,
//             elevation: 0,
//             automaticallyImplyLeading: false,
//             title: Text(
//               'Subscriptions',
//               style: theme.textTheme.headlineSmall?.copyWith(
//                 color: colorScheme.onSurface,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 12),
//                   child: IconButton(
//                     icon: const Icon(Icons.add),
//                     color: DatingColors.primaryGreen,
//                     tooltip: 'Add Subscription Plan',
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const FullPlansGetPage()),
//                         // Or push to your add plan screen if available
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                   Icon(Icons.filter_alt_outlined, color: colorScheme.onSurface.withOpacity(0.7)),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 16),
//                   child: PopupMenuButton<String>(
//                     icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
//                     onSelected: (value) {
//                       if (value == 'Features') {
//                         Navigator.pushNamed(context, '/adminfeatures');
//                       }
//                       if (value == 'Plan') {
//                         Navigator.pushNamed(context, '/SubscriptionPlansListScreen'); // Your own plan page route
//                       }
//                     },
//                     itemBuilder: (context) => [
//                       const PopupMenuItem(
//                         value: 'Plan',
//                         child: Text('Plan'),
//                       ),
//                       const PopupMenuItem(
//                         value: 'Features',
//                         child: Text('Features'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ]
      
//           ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
                        
//               Text("Churn Rate",
//                   style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
//               const SizedBox(height: 12),
//               Center(
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     SizedBox(
//                       width: 150,
//                       height: 150,
//                       child: CircularProgressIndicator(
//                         value: 0.39,
//                         strokeWidth: 18,
//                         backgroundColor: colorScheme.onSurface.withOpacity(0.1),
//                         color: DatingColors.primaryGreen,
//                       ),
//                     ),
//                     Text("39.1%",
//                         style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(child: _statBox(context, "BFF Customer", "500", true)),
//                   const SizedBox(width: 12),
//                   Expanded(child: _statBox(context, "Subscriptions", "126", false)),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Text("Top 5 Subscriptions By Category",
//                   style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
//               const SizedBox(height: 12),
//               _barWithTooltip(context, "Boost", "1 Month \$5536\n3 Month \$4536\n6 Month \$5345"),
//               _barWithTooltip(context, "Premium", "1 Month \$5536\n3 Month \$4536\n6 Month \$5345"),
//               _barWithTooltip(context, "Premium +", "1 Month \$5536\n3 Month \$4536\n6 Month \$5345"),
//               const SizedBox(height: 20),
              
              
//               const SizedBox(height: 20),
//               // Text("Recent Subscriptions",
//               //     style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
//               // const SizedBox(height: 12),
//               // _recentSubTile(context, "Denis Dias", "Feb 24, 12:00 Pm", "assets/user1.png"),
//               // _recentSubTile(context, "Riyas", "Jan 12, 12:00 Pm", "assets/user2.png"),
//               // _recentSubTile(context, "Halmud Alam", "Jan 2, 12:00 Pm", "assets/user3.png"),
//               // const SizedBox(height: 80),
//             ],
//           ),
//         ),
//         bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
//       ),
//     );
//   }

//   Widget _statBox(BuildContext context, String title, String value, bool gradient) {
//     final theme = Theme.of(context);
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: gradient
//             ? LinearGradient(
//           colors: [DatingColors.primaryGreen, Colors.white],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         )
//             : null,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: DatingColors.primaryGreen, width: 1.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Text(value, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   Widget _barWithTooltip(BuildContext context, String label, String tooltipText) {
//     final theme = Theme.of(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: theme.textTheme.bodyMedium),
//         const SizedBox(height: 4),
//         Row(
//           children: [
//             Container(
//               height: 20,
//               width: 180,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(colors: [DatingColors.primaryGreen, Colors.white]),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Tooltip(
//               message: tooltipText,
//               child: Icon(Icons.info_outline, size: 18, color: theme.colorScheme.onSurface),
//             )
//           ],
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   Widget _recentSubTile(BuildContext context, String name, String dateTime, String imagePath) {
//     final theme = Theme.of(context);
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 10),
//       color: theme.colorScheme.surface,
//       child: ListTile(
//         leading: CircleAvatar(backgroundImage: AssetImage(imagePath)),
//         title: Text(name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
//         subtitle: Text(dateTime, style: theme.textTheme.bodyMedium),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.list_alt, color: DatingColors.accentTeal),
//             const SizedBox(width: 8),
//             Icon(Icons.edit, color: DatingColors.warningOrange),
//             const SizedBox(width: 8),
//             Icon(Icons.delete, color: DatingColors.errorRed),
//           ],
//         ),
//       ),
//     );
//   }
// }
