class Product {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final double? oldPrice;        // السعر القديم (مشطوب)
  final int? discountPercentage; // نسبة الخصم مثل 40
  final String? timeLeft;        // الوقت المتبقي مثل "2h 28m left"
  final String imageUrl;
  final String description;
  final double rating;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    this.oldPrice,
    this.discountPercentage,
    this.timeLeft,
    required this.imageUrl,
    this.description = '',
    this.rating = 4.5,
    this.isFavorite = false,
  });

  /// Converts product to JSON for local storage (Exercise 2)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'price': price,
      'image': imageUrl,
      'category': categoryId,
      'oldPrice': oldPrice,
      'discountPercentage': discountPercentage,
      'timeLeft': timeLeft,
      'description': description,
      'rating': rating,
      'isFavorite': isFavorite,
    };
  }

  /// Creates Product from JSON (for loading from cache)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['title'] ?? json['name'] ?? 'Unknown Product',
      categoryId: json['category'] ?? 'others',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 
          (json['rating'] is Map ? (json['rating']['rate'] as num?)?.toDouble() : 4.5) ?? 
          4.5,
      oldPrice: json['oldPrice'] != null ? (json['oldPrice'] as num).toDouble() : null,
      discountPercentage: json['discountPercentage'] as int?,
      timeLeft: json['timeLeft'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
