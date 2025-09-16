// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../provider/subscriptions/full_plans_get_provider.dart';
//
// // Make sure FullPlan model is correct per your response.
//
// class FullPlansGetPage extends ConsumerStatefulWidget {
//   const FullPlansGetPage({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<FullPlansGetPage> createState() => _FullPlansGetPageState();
// }
//
// class _FullPlansGetPageState extends ConsumerState<FullPlansGetPage> {
//   String? selectedType;
//   int? selectedDuration;
//
//   List<String> _getUniqueTypes(List plans) =>
//       plans.map((e) => e.planType.planName as String).toSet().toList();
//
//   List<int> _getDurations(List plans, String? type) {
//     final durations = plans
//         .where((e) => type == null || e.planType.planName == type)
//         .map((e) => e.durationDays)
//         .whereType<int>()
//         .toSet()
//         .toList();
//     durations.sort();
//     return durations;
//   }
//
//   List<dynamic> _getFilteredPlans(List plans, String? type, int? duration) =>
//       plans.where((e) {
//         final matchesType = type == null || e.planType.planName == type;
//         final matchesDuration = duration == null || e.durationDays == duration;
//         return matchesType && matchesDuration;
//       }).toList();
//
//   @override
//   Widget build(BuildContext context) {
//     final plansAsync = ref.watch(fullPlansProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("All Subscription Plans"),
//         backgroundColor: Colors.teal,
//         elevation: 4,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(14),
//         child: plansAsync.when(
//           loading: () => const Center(child: CircularProgressIndicator()),
//           error: (err, stack) => Center(child: Text('$err')),
//           data: (plans) {
//             final types = _getUniqueTypes(plans);
//             final durations = _getDurations(plans, selectedType);
//             final filteredPlans =
//             _getFilteredPlans(plans, selectedType, selectedDuration);
//
//             return Column(
//               children: [
//                 Card(
//                   elevation: 2,
//                   color: Colors.blue.shade50,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Padding(
//                     padding:
//                     const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: DropdownButtonFormField<String?>(
//                             decoration: const InputDecoration(
//                               labelText: "Plan Type",
//                               border: OutlineInputBorder(),
//                             ),
//                             value: selectedType,
//                             items: <DropdownMenuItem<String?>>[
//                               const DropdownMenuItem(
//                                   value: null, child: Text("All Types")),
//                               ...types
//                                   .map((t) => DropdownMenuItem<String?>(
//                                 value: t,
//                                 child: Text(
//                                   t,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold
//                                   ),
//                                 ),
//                               ))
//                                   .toList()
//                             ],
//                             onChanged: (val) {
//                               setState(() {
//                                 selectedType = val;
//                                 selectedDuration = null;
//                               });
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: DropdownButtonFormField<int?>(
//                             decoration: const InputDecoration(
//                               labelText: "Duration",
//                               border: OutlineInputBorder(),
//                             ),
//                             value: selectedDuration,
//                             items: <DropdownMenuItem<int?>>[
//                               const DropdownMenuItem(
//                                   value: null, child: Text("All Durations")),
//                               ...durations
//                                   .map((d) => DropdownMenuItem<int?>(
//                                 value: d,
//                                 child: Text("$d days"),
//                               ))
//                                   .toList()
//                             ],
//                             onChanged: (val) => setState(() => selectedDuration = val),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: filteredPlans.isEmpty
//                       ? Center(
//                     child: Text(
//                       "No plans match your filters.",
//                       style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey.shade600,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   )
//                       : ListView.separated(
//                     itemCount: filteredPlans.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 14),
//                     itemBuilder: (_, idx) {
//                       final plan = filteredPlans[idx];
//                       return Card(
//                         elevation: 5,
//                         color: idx % 2 == 0 ? Colors.white : Colors.teal.shade50,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.fromLTRB(20, 18, 20, 13),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(plan.title,
//                                   style: const TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.teal)),
//                               const SizedBox(height: 7),
//                               Row(
//                                 children: [
//                                   const Text("Type: ",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w600)),
//                                   Text(plan.planType.planName,
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.w500)),
//                                   const SizedBox(width: 25),
//                                   if (plan.durationDays != null)
//                                     Text("${plan.durationDays} days",
//                                         style: TextStyle(
//                                             fontSize: 13,
//                                             color: Colors.teal.shade700)),
//                                 ],
//                               ),
//                               const SizedBox(height: 6),
//                               Text("Price: ₹${plan.price}",
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green,
//                                       fontSize: 15)),
//                               if (plan.quantity != null)
//                                 Text(
//                                   "Quantity: ${plan.quantity}",
//                                   style: const TextStyle(fontSize: 13),
//                                 ),
//                               const SizedBox(height: 10),
//                               Text(
//                                 plan.planType.description,
//                                 style: const TextStyle(
//                                     fontSize: 14, color: Colors.grey),
//                               ),
//                               if (plan.planType.features.isNotEmpty) ...[
//                                 const SizedBox(height: 10),
//                                 Wrap(
//                                   spacing: 10,
//                                   runSpacing: 6,
//                                   children: plan.planType.features
//                                       .map((feat) => Chip(
//                                     label: Text(feat.featureName),
//                                     backgroundColor:
//                                     Colors.purple.shade50,
//                                     labelStyle: const TextStyle(
//                                         color: Colors.purple),
//                                     elevation: 2,
//                                   ))
//                                       .toList(),
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/subscriptions/full_plans_get_provider.dart';

class FullPlansGetPage extends ConsumerStatefulWidget {
  const FullPlansGetPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FullPlansGetPage> createState() => _FullPlansGetPageState();
}

class _FullPlansGetPageState extends ConsumerState<FullPlansGetPage> {
  String? selectedType;
  int? selectedDuration;

  List<String> _getUniqueTypes(List plans) =>
      plans.map((e) => e.planType.planName as String).toSet().toList();

  List<int> _getDurations(List plans, String? type) {
    final durations = plans
        .where((e) => type == null || e.planType.planName == type)
        .map((e) => e.durationDays)
        .whereType<int>()
        .toSet()
        .toList();
    durations.sort();
    return durations;
  }

  List<dynamic> _getFilteredPlans(List plans, String? type, int? duration) =>
      plans.where((e) {
        final matchesType = type == null || e.planType.planName == type;
        final matchesDuration = duration == null || e.durationDays == duration;
        return matchesType && matchesDuration;
      }).toList();

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(fullPlansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Subscription Plans"),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: plansAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('$err')),
          data: (plans) {
            final types = _getUniqueTypes(plans);
            final durations = _getDurations(plans, selectedType);
            final filteredPlans =
            _getFilteredPlans(plans, selectedType, selectedDuration);

            return Column(
              children: [
                Card(
                  elevation: 2,
                  color: Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String?>(
                            decoration: const InputDecoration(
                              labelText: "Plan Type",
                              border: OutlineInputBorder(),
                            ),
                            value: selectedType,
                            items: <DropdownMenuItem<String?>>[
                              const DropdownMenuItem(
                                  value: null, child: Text("All Types")),
                              ...types
                                  .map((t) => DropdownMenuItem<String?>(
                                value: t,
                                child: Text(
                                  t,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                                  .toList()
                            ],
                            onChanged: (val) {
                              setState(() {
                                selectedType = val;
                                selectedDuration = null;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<int?>(
                            decoration: const InputDecoration(
                              labelText: "Duration",
                              border: OutlineInputBorder(),
                            ),
                            value: selectedDuration,
                            items: <DropdownMenuItem<int?>>[
                              const DropdownMenuItem(
                                  value: null, child: Text("All Durations")),
                              ...durations
                                  .map((d) => DropdownMenuItem<int?>(
                                value: d,
                                child: Text("$d days"),
                              ))
                                  .toList()
                            ],
                            onChanged: (val) =>
                                setState(() => selectedDuration = val),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: filteredPlans.isEmpty
                      ? Center(
                    child: Text(
                      "No plans match your filters.",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                      : ListView.separated(
                    itemCount: filteredPlans.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 14),
                    itemBuilder: (_, idx) {
                      final plan = filteredPlans[idx];
                      final features = (plan.planType.features as List?) ?? [];

                      return Card(
                        elevation: 5,
                        color: idx % 2 == 0
                            ? Colors.white
                            : Colors.teal.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              20, 18, 20, 13),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(plan.title,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal)),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  const Text("Type: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text(plan.planType.planName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 25),
                                  if (plan.durationDays != null)
                                    Text("${plan.durationDays} days",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.teal.shade700)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text("Price: ₹${plan.price}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 15)),
                              if (plan.quantity != null)
                                Text(
                                  "Quantity: ${plan.quantity}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                              const SizedBox(height: 10),
                              Text(
                                plan.planType.description,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              if (features.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 6,
                                  children: features
                                      .map<Widget>(
                                        (feat) => Chip(
                                      label: Text(feat.featureName),
                                      backgroundColor:
                                      Colors.purple.shade50,
                                      labelStyle: const TextStyle(
                                          color: Colors.purple),
                                      elevation: 2,
                                    ),
                                  )
                                      .toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
