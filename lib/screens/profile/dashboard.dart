  // import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart';
  // import 'package:flutter/material.dart';
  // import 'package:fl_chart/fl_chart.dart';
  //
  // class DashboardScreen extends StatelessWidget {
  //   const DashboardScreen({super.key});
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       backgroundColor: const Color(0xFFF9F7F8),
  //       body: SafeArea(
  //         child: Column(
  //           children: [
  //             _buildHeader(),
  //             _buildSearchBar(),
  //             const SizedBox(height: 8),
  //             Expanded(
  //               child: ListView(
  //                 padding: const EdgeInsets.symmetric(horizontal: 16),
  //                 children: List.generate(8, (index) {
  //                   return Padding(
  //                     padding: const EdgeInsets.only(bottom: 16),
  //                     child: _chartCard(
  //                       _labelFor(index),
  //                       _subLabelFor(index),
  //                       _chartFor(index),
  //                     ),
  //                   );
  //                 }),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       bottomNavigationBar: CustomBottomNavBar(currentIndex: 0,
  //       ),
  //     );
  //   }
  //
  //   Widget _buildHeader() {
  //     return Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
  //       decoration: const BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           const Text(
  //             'Dashboard',
  //             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //           ),
  //           Row(
  //             children: [
  //               IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
  //               IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
  //             ],
  //           )
  //         ],
  //       ),
  //     );
  //   }
  //
  //   Widget _buildSearchBar() {
  //     return Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       child: TextField(
  //         decoration: InputDecoration(
  //           hintText: 'Search',
  //           prefixIcon: const Icon(Icons.search),
  //           filled: true,
  //           fillColor: Colors.white,
  //           contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(20),
  //             borderSide: BorderSide.none,
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //
  //   String _labelFor(int i) {
  //     return [
  //       'User Analytics',
  //       'User Retention',
  //       'Session Duration',
  //       'Monthly Overview',
  //       'Churn Rate',
  //       'Daily Engagement',
  //       'Revenue Growth',
  //       'User Device Activity',
  //     ][i];
  //   }
  //
  //   String _subLabelFor(int i) {
  //     return [
  //       'Active users over time',
  //       'Returning users vs new',
  //       'Avg session in minutes',
  //       'Month-wise overview',
  //       'Drop-off analysis',
  //       'Engagement by weekday',
  //       'Earnings trend',
  //       'Devices used by users',
  //     ][i];
  //   }
  //
  //   Widget _chartCard(String title, String subtitle, Widget chart) {
  //     return Container(
  //       padding: const EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(18),
  //         boxShadow: const [
  //           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(title,
  //               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //           const SizedBox(height: 4),
  //           Text(subtitle, style: const TextStyle(color: Colors.black54)),
  //           const SizedBox(height: 12),
  //           SizedBox(height: 200, child: chart),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   Widget _chartFor(int i) {
  //     if (i < 3) return _areaLineChart();
  //     if (i == 3) return _pointedLineChart();
  //     if (i >= 4 && i < 7) return _barChart();
  //     return _deviceActivityChart();
  //   }
  //
  //   Widget _areaLineChart() {
  //     return LineChart(LineChartData(
  //       gridData: FlGridData(show: true, drawVerticalLine: true),
  //       titlesData: FlTitlesData(
  //         bottomTitles: AxisTitles(
  //           sideTitles: SideTitles(
  //             showTitles: true,
  //             interval: 1,
  //             getTitlesWidget: (value, _) {
  //               const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
  //               return Text(months[value.toInt() % months.length]);
  //             },
  //           ),
  //         ),
  //         leftTitles: AxisTitles(
  //           sideTitles: SideTitles(showTitles: true, interval: 1),
  //         ),
  //         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //       ),
  //       borderData: FlBorderData(show: false),
  //       lineBarsData: [
  //         LineChartBarData(
  //           isCurved: true,
  //           color: const Color(0xFFB6D430),
  //           barWidth: 3,
  //           belowBarData: BarAreaData(
  //             show: true,
  //             color: const Color(0xFFB6D430).withOpacity(0.3),
  //           ),
  //           spots: const [
  //             FlSpot(0, 2),
  //             FlSpot(1, 3),
  //             FlSpot(2, 2.8),
  //             FlSpot(3, 3.5),
  //             FlSpot(4, 3.2),
  //             FlSpot(5, 4),
  //             FlSpot(6, 3.8),
  //           ],
  //         ),
  //       ],
  //     ));
  //   }
  //
  //   Widget _pointedLineChart() {
  //     return LineChart(LineChartData(
  //       gridData: FlGridData(show: true),
  //       titlesData: FlTitlesData(
  //         bottomTitles: AxisTitles(
  //           sideTitles: SideTitles(
  //             showTitles: true,
  //             getTitlesWidget: (value, _) {
  //               const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
  //               return Text(labels[value.toInt() % labels.length]);
  //             },
  //           ),
  //         ),
  //         leftTitles: AxisTitles(
  //           sideTitles: SideTitles(showTitles: true, interval: 1),
  //         ),
  //         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //       ),
  //       borderData: FlBorderData(show: false),
  //       lineBarsData: [
  //         LineChartBarData(
  //           isCurved: false,
  //           color: const Color(0xFFB6D430),
  //           barWidth: 3,
  //           dotData: FlDotData(show: true),
  //           belowBarData: BarAreaData(
  //               show: true, color: const Color(0xFFB6D430).withOpacity(0.3)),
  //           spots: const [
  //             FlSpot(0, 1),
  //             FlSpot(1, 4),
  //             FlSpot(2, 2),
  //             FlSpot(3, 5),
  //             FlSpot(4, 3),
  //           ],
  //         )
  //       ],
  //     ));
  //   }
  //
  //   Widget _barChart() {
  //     return BarChart(BarChartData(
  //       gridData: FlGridData(show: true),
  //       titlesData: FlTitlesData(
  //         leftTitles: AxisTitles(
  //           sideTitles: SideTitles(showTitles: true, interval: 2),
  //         ),
  //         bottomTitles: AxisTitles(
  //           sideTitles: SideTitles(
  //             showTitles: true,
  //             getTitlesWidget: (value, _) {
  //               const days = ['M', 'T', 'W', 'T', 'F', 'S'];
  //               return Text(days[value.toInt() % days.length]);
  //             },
  //           ),
  //         ),
  //         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //       ),
  //       borderData: FlBorderData(show: false),
  //       barGroups: List.generate(6, (i) {
  //         return BarChartGroupData(x: i, barRods: [
  //           BarChartRodData(
  //               toY: (i + 2) * 1.2,
  //               color: const Color(0xFFB6D430),
  //               width: 14,
  //               borderRadius: BorderRadius.circular(6))
  //         ]);
  //       }),
  //     ));
  //   }
  //
  //   Widget _deviceActivityChart() {
  //     return LineChart(LineChartData(
  //       gridData: FlGridData(show: true),
  //       titlesData: FlTitlesData(
  //         bottomTitles: AxisTitles(
  //           sideTitles: SideTitles(
  //             showTitles: true,
  //             getTitlesWidget: (value, _) {
  //               const labels = ['Mon', 'Tue', 'Wed', 'Thu'];
  //               return Text(labels[value.toInt() % labels.length]);
  //             },
  //           ),
  //         ),
  //         leftTitles: AxisTitles(
  //           sideTitles: SideTitles(showTitles: true, interval: 1),
  //         ),
  //         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //       ),
  //       borderData: FlBorderData(show: false),
  //       lineBarsData: [
  //         LineChartBarData(
  //             isCurved: true,
  //             color: Colors.red,
  //             barWidth: 2,
  //             spots: const [FlSpot(0, 1), FlSpot(1, 2), FlSpot(2, 1.5), FlSpot(3, 3)]),
  //         LineChartBarData(
  //             isCurved: true,
  //             color: Colors.blue,
  //             barWidth: 2,
  //             spots: const [FlSpot(0, 2), FlSpot(1, 1.5), FlSpot(2, 2.5), FlSpot(3, 2)]),
  //         LineChartBarData(
  //             isCurved: true,
  //             color: const Color(0xFFB6D430),
  //             barWidth: 2,
  //             spots: const [FlSpot(0, 1.8), FlSpot(1, 2.2), FlSpot(2, 2), FlSpot(3, 3.2)]),
  //       ],
  //     ));
  //   }
  // }

  import 'package:flutter/material.dart';
  import 'package:fl_chart/fl_chart.dart';
  import 'package:admin_dating/screens/bottomnavbar/bottomnavbar.dart'; // Your custom nav bar

  // Ensure you import DatingColors and AppThemes from theme_provider.dart

  class DashboardScreen extends StatelessWidget {
    const DashboardScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildSearchBar(context),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 8,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _chartCard(
                      context,
                      _labelFor(index),
                      _subLabelFor(index),
                      _chartFor(index, context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
      );
    }

    Widget _buildHeader(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ],
            )
          ],
        ),
      );
    }

    Widget _buildSearchBar(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
    }

    String _labelFor(int i) {
      return [
        'User Analytics',
        'User Retention',
        'Session Duration',
        'Monthly Overview',
        'Churn Rate',
        'Daily Engagement',
        'Revenue Growth',
        'User Device Activity',
      ][i];
    }

    String _subLabelFor(int i) {
      return [
        'Active users over time',
        'Returning users vs new',
        'Avg session in minutes',
        'Month-wise overview',
        'Drop-off analysis',
        'Engagement by weekday',
        'Earnings trend',
        'Devices used by users',
      ][i];
    }

    Widget _chartCard(BuildContext context, String title, String subtitle, Widget chart) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.10),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(height: 200, child: chart),
          ],
        ),
      );
    }

    // Utility for picking the chart color from your theme
    Color getPrimary(BuildContext context) => Theme.of(context).colorScheme.primary;

    Widget _chartFor(int i, BuildContext context) {
      final primary = getPrimary(context);
      if (i < 3) return _areaLineChart(primary);
      if (i == 3) return _pointedLineChart(primary);
      if (i >= 4 && i < 7) return _barChart(primary);
      return _deviceActivityChart(primary, context);
    }

    Widget _areaLineChart(Color chartColor) {
      return LineChart(LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
                return Text(months[value.toInt() % months.length]);
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 1),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: chartColor,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: chartColor.withOpacity(0.3),
            ),
            spots: const [
              FlSpot(0, 2),
              FlSpot(1, 3),
              FlSpot(2, 2.8),
              FlSpot(3, 3.5),
              FlSpot(4, 3.2),
              FlSpot(5, 4),
              FlSpot(6, 3.8),
            ],
          ),
        ],
      ));
    }

    Widget _pointedLineChart(Color chartColor) {
      return LineChart(LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
                return Text(labels[value.toInt() % labels.length]);
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 1),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: false,
            color: chartColor,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
                show: true, color: chartColor.withOpacity(0.3)
            ),
            spots: const [
              FlSpot(0, 1),
              FlSpot(1, 4),
              FlSpot(2, 2),
              FlSpot(3, 5),
              FlSpot(4, 3),
            ],
          )
        ],
      ));
    }

    Widget _barChart(Color chartColor) {
      return BarChart(BarChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 2),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const days = ['M', 'T', 'W', 'T', 'F', 'S'];
                return Text(days[value.toInt() % days.length]);
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(6, (i) {
          return BarChartGroupData(x: i, barRods: [
            BarChartRodData(
              toY: (i + 2) * 1.2,
              color: chartColor,
              width: 14,
              borderRadius: BorderRadius.circular(6),
            )
          ]);
        }),
      ));
    }

    Widget _deviceActivityChart(Color chartColor, BuildContext context) {
      return LineChart(LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const labels = ['Mon', 'Tue', 'Wed', 'Thu'];
                return Text(labels[value.toInt() % labels.length]);
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 1),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.red,
            barWidth: 2,
            spots: const [FlSpot(0, 1), FlSpot(1, 2), FlSpot(2, 1.5), FlSpot(3, 3)],
          ),
          LineChartBarData(
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            spots: const [FlSpot(0, 2), FlSpot(1, 1.5), FlSpot(2, 2.5), FlSpot(3, 2)],
          ),
          LineChartBarData(
            isCurved: true,
            color: chartColor,
            barWidth: 2,
            spots: const [FlSpot(0, 1.8), FlSpot(1, 2.2), FlSpot(2, 2), FlSpot(3, 3.2)],
          ),
        ],
      ));
    }
  }
