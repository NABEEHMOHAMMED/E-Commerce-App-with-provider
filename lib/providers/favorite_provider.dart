import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  FavoriteProvider() {
    // تحميل البيانات في الخلفية
    Future.microtask(() => _loadFromDisk());
  }

  bool isFavorite(Product product) {
    return _favorites.any((item) => item.id == product.id);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      _favorites.removeWhere((item) => item.id == product.id);
      product.isFavorite = false;
    } else {
      _favorites.add(product);
      product.isFavorite = true;
    }
    notifyListeners();
    // حفظ البيانات فوراً عند التغيير (Exercise 2)
    _saveToDisk();
  }

  void removeFromFavorites(String productId) {
    _favorites.removeWhere((item) => item.id == productId);
    notifyListeners();
    // حفظ البيانات فوراً عند التغيير (Exercise 2)
    _saveToDisk();
  }

  // ─── عمليات التخزين المحلي (Exercise 2) ─────────────────────────────

  /// الحصول على مسار الملف المخزن على الجهاز
  Future<File> _getFavoritesFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/favorites.json');
  }

  /// حفظ قائمة المفضلات بصيغة JSON
  Future<void> _saveToDisk() async {
    try {
      final file = await _getFavoritesFile();
      
      // تحويل قائمة الكائنات إلى JSON (Encoding)
      // نكتفي بالبيانات الأساسية فقط كما هو مطلوب
      final String jsonString = json.encode(
        _favorites.map((p) => p.toJson()).toList(),
      );
      
      await file.writeAsString(jsonString);
      debugPrint('Favorites saved successfully to: ${file.path}');
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  /// تحميل قائمة المفضلات من الجهاز عند تشغيل التطبيق
  Future<void> _loadFromDisk() async {
    try {
      final file = await _getFavoritesFile();
      
      if (await file.exists()) {
        final String jsonString = await file.readAsString();
        
        // تحويل JSON إلى قائمة كائنات (Decoding)
        final List<dynamic> jsonList = json.decode(jsonString);
        
        _favorites = jsonList.map((item) {
          final product = Product.fromJson(item);
          product.isFavorite = true; // تأكيد أنها مفضلة
          return product;
        }).toList();
        
        notifyListeners();
        debugPrint('Favorites loaded successfully. Count: ${_favorites.length}');
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      // التعامل مع الأخطاء بهدوء كما هو مطلوب
    }
  }
}
