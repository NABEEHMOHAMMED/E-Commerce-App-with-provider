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
}
