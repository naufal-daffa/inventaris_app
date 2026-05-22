import 'dart:convert';
import 'dart:io';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
import 'package:image_picker/image_picker.dart';
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

  // Future<void> postItem(dynamic name, stock, image) async {
  //   final url = Uri.parse("${ApiConfig.baseUrl}items");
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString("token");
  //   // final headers = await _getHeaders();
  //   try {
  //     var request = http.MultipartRequest("POST", url);
  //     request.headers["Authorization"] = 'Bearer $token';

  //     request.fields['name'] = name;
  //     request.fields['stock'] = stock;

  //     if (image != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath("image", image.path),
  //       );
  //     }

  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return;
  //     } else {
  //       throw Exception("Failed to load items: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Failed to fetch items: $e");
  //     throw Exception("Failed to load items: $e");
  //   }
  // }

  Future<ItemModel> createItem({
    required String name,
    required String stock,
    XFile? imageFile,
  }) async {
    // Hit Endpoint API
    final url = Uri.parse("${ApiConfig.baseUrl}items");
    var request = http.MultipartRequest("POST", url);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    // method yang digunakan

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    request.fields['stock'] = stock;
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      request.files.add(
        await http.MultipartFile.fromBytes(
          "image",
          bytes,
          filename: imageFile.name,
        ),
      );
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return ItemModel.fromJson(responseData['data']);
      } else {
        throw Exception("Gagal Menyimpan Data : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan $e");
    }
  }

  Future<ItemModel> updateItem({
    required int id,
    required String name,
    required String stock,
    XFile? newImageFile,
  }) async {
    // Hit Endpoint API
    final url = Uri.parse('${ApiConfig.baseUrl}items/$id');
    var request = http.MultipartRequest("PUT", url);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    // method yang digunakan

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    request.fields['stock'] = stock;
    if (newImageFile != null) {
      final bytes = await newImageFile.readAsBytes();
      request.files.add(
        await http.MultipartFile.fromBytes(
          "image",
          bytes,
          filename: newImageFile.name,
        ),
      );
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return ItemModel.fromJson(responseData['data']);
      } else {
        throw Exception("Gagal Mengubah Data : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan $e");
    }
  }

  Future<bool> deleteItem(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}items/$id');
    final headers = await _getHeaders();
    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete item.');
      }
    } catch (e) {
      throw Exception("Terjadi Kesalahan $e");
    }
  }
}
