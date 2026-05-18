import 'dart:io';
import 'dart:convert';
import 'package:inventory_apps/config/api_config.dart';
import 'package:inventory_apps/models/item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ItemService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  Future<List<ItemModel>> getItems() async {
    final url = Uri.parse("${ApiConfig.baseUrl}items");
    final headers = await _getHeaders();
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> dataList = responseData['data'];
        return dataList.map((json) => ItemModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load items: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to fetch items: $e");
      throw Exception("Failed to load items: $e");
    }
  }
}