import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/saree.dart';
import '../services/api_service.dart';

class SareeProvider with ChangeNotifier {
  List<Saree> _sarees = [];
  bool _isLoading = false;
  String _error = '';

  List<Saree> get sarees => _sarees;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchSarees() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _sarees = await ApiService.getSarees();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSaree({
    required String name,
    required String price,
    required String fabric,
    required String color,
    required String stock,
    required String category,
    required File image,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final newSaree = await ApiService.uploadSaree(
        name: name,
        price: price,
        fabric: fabric,
        color: color,
        stock: stock,
        category: category,
        image: image,
      );
      _sarees.insert(0, newSaree);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
