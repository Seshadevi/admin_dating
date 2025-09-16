import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../models/supscription/full_plans_get_modal.dart';


final fullPlansProvider = FutureProvider<List<FullPlan>>((ref) async {
  final url = Uri.parse('http://97.74.93.26:6100/admin/plans/full');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final Map<String, dynamic> resp = json.decode(response.body);
    final List dataList = resp['data'];
    return dataList.map((plan) => FullPlan.fromJson(plan)).toList();
  } else {
    throw Exception('Failed to load full plans');
  }
});
