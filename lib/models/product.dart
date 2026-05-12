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

  /// Factory constructor to parse JSON from the FakeStore API
  /// API Response format:
  /// {
  ///   "id": 1,
  ///   "title": "Product Name",
  ///   "price": 109.95,
  ///   "description": "Description text...",
  ///   "category": "men's clothing",
  ///   "image": "https://fakestoreapi.com/img/...",
  ///   "rating": { "rate": 3.9, "count": 120 }
  /// }
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? 'Unknown Product',
      categoryId: json['category'] ?? 'others',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image'] ?? '',
      description: json['description'] ?? '',
      rating: json['rating'] != null
          ? (json['rating']['rate'] as num).toDouble()
          : 4.5,
    );
  }

  /// Converts product to JSON for local storage (Exercise 2)
  /// Stores only essential data: ID, name, price, and image.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'price': price,
      'image': imageUrl,
      'category': categoryId,
    };
  }
}
