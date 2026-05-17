import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../services/web_storage.dart';

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
    'smartphones': '📱',
    'watches': '⌚',
    'shoes': '👟',
    'furniture': '🪑',
    'beauty': '💄',
    'toys': '🧸',
    'sports': '⚽',
    'groceries': '🛒',
    'accessories': '🕶️',
    'gaming': '🎮',
  };

  // ─── Constructor ─────────────────────────────────────────────────────
  ProductProvider() {
    Future.microtask(() => _initializeData());
  }

  Future<void> _initializeData() async {
    _isLoading = true;
    // Don't notify yet to avoid empty screen flicker

    try {
      await _loadFromDisk(); // Load cached data first
      _addMockProductsNoNotify(); // Add mock data without notifying
      _buildCategoriesFromProducts(); // Build categories

      await _initConnectivity();
    } catch (e) {
      debugPrint('Error in ProductProvider init: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Single notification after everything is ready

      // Attempt background update from API if online
      if (_isConnected) {
        fetchProducts(showOfflineMessage: false);
      }
    }
  }

  void _addMockProductsNoNotify() {
    final mockData = [
      Product(
        id: 'm1',
        name: 'iPhone 15 Pro Max',
        categoryId: 'smartphones',
        price: 1199.99,
        oldPrice: 1299.99,
        discountPercentage: 8,
        imageUrl:
            'https://images.unsplash.com/photo-1696446701796-da61225697cc?w=500',
        description: 'Latest Apple iPhone with Titanium design.',
        rating: 4.9,
      ),
      Product(
        id: 'm2',
        name: 'Samsung Galaxy S24 Ultra',
        categoryId: 'smartphones',
        price: 1099.99,
        imageUrl:
            'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=500',
        description: 'Advanced AI smartphone with S-Pen.',
        rating: 4.8,
      ),
      Product(
        id: 'm3',
        name: 'Rolex Submariner',
        categoryId: 'watches',
        price: 8500.00,
        imageUrl:
            'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?w=500',
        description: 'Classic luxury diver watch.',
        rating: 5.0,
      ),
      Product(
        id: 'm4',
        name: 'Apple Watch Ultra 2',
        categoryId: 'watches',
        price: 799.00,
        imageUrl:
            'https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?w=500',
        description: 'The most rugged and capable Apple Watch.',
        rating: 4.7,
      ),
      Product(
        id: 'm5',
        name: 'Air Jordan 1 Retro',
        categoryId: 'shoes',
        price: 180.00,
        oldPrice: 220.00,
        discountPercentage: 18,
        imageUrl:
            'https://images.unsplash.com/photo-1584735175315-9d5df23860e6?w=500',
        description: 'Iconic basketball sneakers.',
        rating: 4.9,
      ),
      Product(
        id: 'm6',
        name: 'Nike Air Max 270',
        categoryId: 'shoes',
        price: 150.00,
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
        description: 'Comfortable lifestyle sneakers.',
        rating: 4.6,
      ),
      Product(
        id: 'm7',
        name: 'Modern Velvet Sofa',
        categoryId: 'furniture',
        price: 899.00,
        imageUrl:
            'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500',
        description: 'Luxury velvet sofa for your living room.',
        rating: 4.5,
      ),
      Product(
        id: 'm8',
        name: 'Ergonomic Office Chair',
        categoryId: 'furniture',
        price: 299.00,
        imageUrl:
            'https://images.unsplash.com/photo-1505797149-43b0069ec26b?w=500',
        description: 'Work in comfort with this ergonomic chair.',
        rating: 4.7,
      ),
      Product(
        id: 'm9',
        name: 'Sony PlayStation 5',
        categoryId: 'gaming',
        price: 499.00,
        imageUrl:
            'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=500',
        description: 'Next-gen gaming console.',
        rating: 4.9,
      ),
      Product(
        id: 'm10',
        name: 'Gaming Mechanical Keyboard',
        categoryId: 'gaming',
        price: 120.00,
        imageUrl:
            'https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?w=500',
        description: 'RGB Backlit mechanical keyboard.',
        rating: 4.5,
      ),
    ];

    for (var product in mockData) {
      if (!_allProducts.any((p) => p.id == product.id)) {
        _allProducts.add(product);
      }
    }
  }

  // ─── Initialize Connectivity Listener ───────────────────────────────
  Future<void> _initConnectivity() async {
    try {
      final dynamic result = await Connectivity().checkConnectivity();
      final List<ConnectivityResult> results = result is List
          ? List<ConnectivityResult>.from(result)
          : [result as ConnectivityResult];
      _isConnected = !results.contains(ConnectivityResult.none);
    } catch (e) {
      _isConnected = true; // افتراض الاتصال إذا فشل التحقق
    }
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
      final dynamic result = await Connectivity().checkConnectivity();
      final List<ConnectivityResult> results = result is List
          ? List<ConnectivityResult>.from(result)
          : [result as ConnectivityResult];
      _isConnected = !results.contains(ConnectivityResult.none);

      if (_isConnected) {
        // Online: fetch from API and cache the response
        final fetchedProducts = await ApiService.fetchProducts();
        if (fetchedProducts.isNotEmpty) {
          _allProducts = fetchedProducts;
          // Note: Mock data is replaced by API data when online
          await _saveToDisk();
          _buildCategoriesFromProducts();
        }
        debugPrint(
          ' Products fetched from API and cached. Count: ${_allProducts.length}',
        );
      } else {
        // Offline: load from cache
        await _loadFromDisk();
        if (showOfflineMessage) {
          _errorMessage = 'Offline mode: Showing cached data';
        }
        debugPrint(
          ' Offline mode: loaded from cache. Count: ${_allProducts.length}',
        );
      }
    } catch (e) {
      debugPrint(' API Error: $e');
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
      if (kIsWeb) {
        final String jsonString = json.encode(
          _allProducts.map((p) => p.toJson()).toList(),
        );
        saveToWebStorage('products_cache', jsonString);
        debugPrint('Products cached successfully to localStorage');
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/products_cache.json');

        final String jsonString = json.encode(
          _allProducts.map((p) => p.toJson()).toList(),
        );

        await file.writeAsString(jsonString);
        debugPrint('Products cached successfully to: ${file.path}');
      }
    } catch (e) {
      debugPrint('Error caching products: $e');
    }
  }

  // ─── Load Products from Local File (Offline Fallback) ─────────────────
  Future<void> _loadFromDisk() async {
    try {
      if (kIsWeb) {
        final String? jsonString = loadFromWebStorage('products_cache');
        if (jsonString != null) {
          final List<dynamic> jsonList = json.decode(jsonString);

          _allProducts = jsonList
              .map((item) => Product.fromJson(item))
              .toList();
          debugPrint(
            'Products loaded from cache. Count: ${_allProducts.length}',
          );
        } else {
          debugPrint('No cached data available in localStorage.');
        }
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/products_cache.json');

        if (await file.exists()) {
          final String jsonString = await file.readAsString();
          final List<dynamic> jsonList = json.decode(jsonString);

          _allProducts = jsonList
              .map((item) => Product.fromJson(item))
              .toList();
          debugPrint(
            'Products loaded from cache. Count: ${_allProducts.length}',
          );
        } else {
          // _errorMessage = 'No cached data available. Showing default items.';
          // debugPrint('No cache file found.');
        }
      }

      // Always ensure mock products are present
      _addMockProductsNoNotify();
      _buildCategoriesFromProducts();
    } catch (e) {
      debugPrint('Error loading products from cache: $e');
      // _errorMessage = 'Failed to load cached data.';
      _addMockProductsNoNotify();
      _buildCategoriesFromProducts();
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

    // إضافة فئات إضافية لملء التطبيق (Mock Categories)
    final extraCategories = [
      'smartphones',
      'watches',
      'shoes',
      'furniture',
      'beauty',
      'toys',
      'sports',
      'groceries',
      'accessories',
      'gaming',
    ];
    for (var catId in extraCategories) {
      if (!_categories.any((c) => c.id == catId)) {
        _categories.add(
          Category(
            id: catId,
            name: _formatCategoryName(catId),
            icon: _categoryIcons[catId] ?? '📦',
            imageUrl: '',
            productCount: 0,
          ),
        );
      }
    }
  }

  /// Formats raw category ID into a display-friendly name.
  String _formatCategoryName(String categoryId) {
    return categoryId
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
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
