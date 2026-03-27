import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../models/saree.dart';
import '../constants.dart';

class ApiService {
  static const String apiUrl = AppConstants.apiUrl;

  static Future<List<Saree>> getSarees() async {
    final response = await http.get(Uri.parse('$apiUrl/sarees'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Saree.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sarees');
    }
  }

  static Future<Saree> uploadSaree({
    required String name,
    required String price,
    required String fabric,
    required String color,
    required String stock,
    required String category,
    required File image,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/sarees'));
    
    request.fields['name'] = name;
    request.fields['price'] = price;
    request.fields['fabric'] = fabric;
    request.fields['color'] = color;
    request.fields['stock'] = stock;
    request.fields['category'] = category;

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image.path,
        filename: basename(image.path),
      ),
    );

    var response = await request.send();

    if (response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      return Saree.fromJson(json.decode(responseData));
    } else {
      throw Exception('Failed to upload saree');
    }
  }
}
