import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  // ─── Loading & Error State ──────────────────────────────────────────
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ─── Connection Status ──────────────────────────────────────────────
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  // ─── Products List (fetched from API or loaded from cache) ──────────
  List<Product> _allProducts = [];
  List<Product> get allProducts => _allProducts;

  // ─── Categories ─────────────────────────────────────────────────────
  List<Category> _categories = [];
  List<Category> get categories => _categories;

  // ─── Category icon mapping ─────────────────────────────────────────
  static const Map<String, String> _categoryIcons = {
    'electronics': '🔌',
    "men's clothing": '👕',
    "women's clothing": '👗',
    'jewelery': '💍',
  };

  // ─── Constructor ─────────────────────────────────────────────────────
  ProductProvider() {
    _initConnectivity();
    fetchProducts();
  }

  // ─── Initialize Connectivity Listener ───────────────────────────────
  Future<void> _initConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _isConnected = connectivityResult != ConnectivityResult.none;

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _isConnected = result != ConnectivityResult.none;
      notifyListeners();
    });
  }

  // ─── Fetch Products from API or Load from Cache ─────────────────────
  /// Fetches products from FakeStore API if online.
  /// If offline or API fails, loads products from local cache.
  Future<void> fetchProducts({bool showOfflineMessage = true}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check connectivity first
      final connectivityResult = await Connectivity().checkConnectivity();
      _isConnected = connectivityResult != ConnectivityResult.none;

      if (_isConnected) {
        // Online: fetch from API and cache the response
        _allProducts = await ApiService.fetchProducts();
        await _saveToDisk();
        _buildCategoriesFromProducts();
        debugPrint('✅ Products fetched from API and cached. Count: ${_allProducts.length}');
      } else {
        // Offline: load from cache
        await _loadFromDisk();
        if (showOfflineMessage) {
          _errorMessage = 'Offline mode: Showing cached data';
        }
        debugPrint('📱 Offline mode: loaded from cache. Count: ${_allProducts.length}');
      }
    } catch (e) {
      // Network error occurred: try loading from cache
      debugPrint('❌ API Error: $e');
      await _loadFromDisk();
      if (showOfflineMessage) {
        _errorMessage = 'Offline mode: Showing cached data';
      }
      debugPrint('📱 Fallback to cache. Count: ${_allProducts.length}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Save Products to Local File (Caching) ───────────────────────────
  Future<void> _saveToDisk() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/products_cache.json');

      final String jsonString = json.encode(
        _allProducts.map((p) => p.toJson()).toList(),
      );

      await file.writeAsString(jsonString);
      debugPrint('💾 Products cached successfully to: ${file.path}');
    } catch (e) {
      debugPrint('Error caching products: $e');
    }
  }

  // ─── Load Products from Local File (Offline Fallback) ─────────────────
  Future<void> _loadFromDisk() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/products_cache.json');

      if (await file.exists()) {
        final String jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);

        _allProducts = jsonList
            .map((item) => Product.fromJson(item))
            .toList();

        _buildCategoriesFromProducts();
        debugPrint('📂 Products loaded from cache. Count: ${_allProducts.length}');
      } else {
        _errorMessage = 'No cached data available. Please connect to internet.';
        _allProducts = [];
        _categories = [];
        debugPrint('⚠️ No cache file found.');
      }
    } catch (e) {
      debugPrint('Error loading products from cache: $e');
      _errorMessage = 'Failed to load cached data.';
      _allProducts = [];
      _categories = [];
    }
  }

  // ─── Build Categories Dynamically ────────────────────────────────────
  void _buildCategoriesFromProducts() {
    final Map<String, int> categoryCounts = {};
    for (final product in _allProducts) {
      categoryCounts[product.categoryId] =
          (categoryCounts[product.categoryId] ?? 0) + 1;
    }

    _categories = categoryCounts.entries.map((entry) {
      return Category(
        id: entry.key,
        name: _formatCategoryName(entry.key),
        icon: _categoryIcons[entry.key] ?? '📦',
        imageUrl: '',
        productCount: entry.value,
      );
    }).toList();
  }

  /// Formats raw category ID into a display-friendly name.
  String _formatCategoryName(String categoryId) {
    return categoryId
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  // ─── Existing Methods ────────────────────────────────────────────────

  List<Product> getProductsByCategory(String categoryId) {
    return _allProducts
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  Product? getProductById(String id) {
    try {
      return _allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  void toggleFavorite(Product product) {
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }
}
