import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:admin_dating/constants/dating_colors.dart';

import 'full_plan_post_screen.dart';
import 'full_plans_get_page.dart';
import 'subscription_plans_list_screen.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
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
                    MaterialPageRoute(builder: (context) => const FullPlansGetPage()),
                      // SubscriptionPlansListScreen
                  );
                },
              ),
            ),
           Padding(
            padding: const EdgeInsets.only(right: 16),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
              onSelected: (value) {
                if (value == 'Features') {
                  Navigator.pushNamed(context, '/adminfeatures'); // 👈 navigate to Features page
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'Features',
                  child: Text('Features'),
                ),
              ],
            ),
          )

          ],
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search By ID......',
                      prefixIcon: Icon(Icons.search, color: DatingColors.secondaryText),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.filter_alt_outlined, color: colorScheme.onSurface.withOpacity(0.7)),
                const SizedBox(width: 8),
                Icon(Icons.sort, color: colorScheme.onSurface.withOpacity(0.7)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: DatingColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: 20),
            Text("Churn Rate",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 12),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: 0.39,
                      strokeWidth: 18,
                      backgroundColor: colorScheme.onSurface.withOpacity(0.1),
                      color: DatingColors.primaryGreen,
                    ),
                  ),
                  Text("39.1%",
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _statBox(context, "BFF Customer", "500", true)),
                const SizedBox(width: 12),
                Expanded(child: _statBox(context, "Subscriptions", "126", false)),
              ],
            ),
            const SizedBox(height: 20),
            Text("Top 5 Subscriptions By Category",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 12),
            _barWithTooltip(context, "Boost", "1 Month \$5536\n3 Month \$4536\n6 Month \$5345"),
            _barWithTooltip(context, "Premium", "1 Month \$5536\n3 Month \$4536\n6 Month \$5345"),
            _barWithTooltip(context, "Premium +", "1 Month \$5536\n3 Month \$4536\n6 Month \$5345"),
            const SizedBox(height: 20),
            Text("Customer Growth",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: DatingColors.primaryGreen.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("BFF 5536",
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                  Text("New Login 126", style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
                  Text("Subscriptions 326", style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(7, (index) {
                      final barHeights = [30, 60, 20, 90, 40, 50, 30];
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: barHeights[index].toDouble(),
                          color: DatingColors.primaryGreen,
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text("Recent Subscriptions",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 12),
            _recentSubTile(context, "Denis Dias", "Feb 24, 12:00 Pm", "assets/user1.png"),
            _recentSubTile(context, "Riyas", "Jan 12, 12:00 Pm", "assets/user2.png"),
            _recentSubTile(context, "Halmud Alam", "Jan 2, 12:00 Pm", "assets/user3.png"),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }

  Widget _statBox(BuildContext context, String title, String value, bool gradient) {
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
          Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _barWithTooltip(BuildContext context, String label, String tooltipText) {
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
                gradient: LinearGradient(colors: [DatingColors.primaryGreen, Colors.white]),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: tooltipText,
              child: Icon(Icons.info_outline, size: 18, color: theme.colorScheme.onSurface),
            )
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _recentSubTile(BuildContext context, String name, String dateTime, String imagePath) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      color: theme.colorScheme.surface,
      child: ListTile(
        leading: CircleAvatar(backgroundImage: AssetImage(imagePath)),
        title: Text(name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(dateTime, style: theme.textTheme.bodyMedium),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.list_alt, color: DatingColors.accentTeal),
            const SizedBox(width: 8),
            Icon(Icons.edit, color: DatingColors.warningOrange),
            const SizedBox(width: 8),
            Icon(Icons.delete, color: DatingColors.errorRed),
          ],
        ),
      ),
    );
  }
}
