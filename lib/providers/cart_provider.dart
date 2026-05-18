import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal {
    return _items.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  double get totalPrice => subtotal;

  StreamSubscription<User?>? _authSubscription;
  String? _currentUserId;

  CartProvider() {
    // ─── Listen to Authentication changes to isolate cart ───────────
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _currentUserId = user.uid;
        _loadFromDisk();
      } else {
        _currentUserId = null;
        _items = [];
        notifyListeners();
      }
    });
  }

  void addToCart(Product product) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
    _saveToDisk(); // حفظ التغيير
  }

  void increaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
      _saveToDisk();
    }
  }

  void decreaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
      _saveToDisk();
    }
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
    _saveToDisk();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveToDisk();
  }

  // ─── منطق التخزين المحلي (Persistence) ───────────────────────────────

  Future<File> _getCartFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final suffix = _currentUserId != null ? '_$_currentUserId' : '';
    return File('${directory.path}/cart$suffix.json');
  }

  Future<void> _saveToDisk() async {
    try {
      final file = await _getCartFile();
      final String jsonString = json.encode(
        _items.map((item) => item.toJson()).toList(),
      );
      await file.writeAsString(jsonString);
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  Future<void> _loadFromDisk() async {
    try {
      final file = await _getCartFile();
      if (await file.exists()) {
        final String jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        
        _items = jsonList.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
