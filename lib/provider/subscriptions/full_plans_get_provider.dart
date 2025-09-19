import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/supscription/full_plans_get_modal.dart';
import '../loginprovider.dart';
const String apiUrl = 'http://97.74.93.26:6100/admin/plans/full';

final fullPlansProvider = FutureProvider<List<FullPlan>>((ref) async {
  // Read the token from loginProvider here
  final loginState = ref.read(loginProvider);
  final String? accessToken =
  loginState.data != null && loginState.data!.isNotEmpty
      ? loginState.data![0].accessToken
      : null;

  if (accessToken == null) {
    throw Exception("No access token found");
  }

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      "Authorization": "Bearer $accessToken",
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final jsonBody = json.decode(response.body);
    final List<dynamic> data = jsonBody['data'];
    return data.map((e) => FullPlan.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load plans');
  }
});
