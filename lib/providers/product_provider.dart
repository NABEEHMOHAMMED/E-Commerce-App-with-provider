import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';

class ProductProvider extends ChangeNotifier {
  // الفئات المتاحة لتبدو تماماً كالصورة
  final List<Category> _categories = [
    Category(id: 'electronics', name: 'Electronics', icon: '🔌', imageUrl: '', productCount: 6),
    Category(id: 'fashion', name: 'Men Fashion', icon: '👕', imageUrl: '', productCount: 6),
    Category(id: 'sports', name: 'Sports', icon: '🎾', imageUrl: '', productCount: 6),
    Category(id: 'beauty', name: 'Perfumes', icon: '🧴', imageUrl: '', productCount: 6),
    Category(id: 'stationery', name: 'Stationery', icon: '📏', imageUrl: '', productCount: 6),
    Category(id: 'furniture', name: 'Furniture', icon: '🛋️', imageUrl: '', productCount: 6),
    Category(id: 'toys', name: 'Toys', icon: '🧸', imageUrl: '', productCount: 6),
    Category(id: 'others', name: 'Others', icon: '📚', imageUrl: '', productCount: 6),
  ];

  // جميع المنتجات
  final List<Product> _allProducts = [
    // Electronics
    Product(id: 'e1', name: 'Gaming Laptop', categoryId: 'electronics', price: 1299.99, imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=400&q=80', description: 'High performance gaming laptop.', rating: 4.9),
    Product(id: 'e2', name: 'Smartphone Pro', categoryId: 'electronics', price: 899.99, imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=400&q=80', description: 'Latest flagship smartphone.', rating: 4.8),
    Product(id: 'e3', name: 'Wireless Headphones', categoryId: 'electronics', price: 199.99, imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=400&q=80', description: 'Noise cancelling headphones.', rating: 4.7),
    Product(id: 'e4', name: 'Digital Camera', categoryId: 'electronics', price: 450.00, imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=400&q=80', description: 'Professional digital camera.', rating: 4.6),
    Product(id: 'e5', name: 'Smart Watch', categoryId: 'electronics', price: 250.00, imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=400&q=80', description: 'Fitness and health tracker.', rating: 4.5),
    Product(id: 'e6', name: 'Bluetooth Speaker', categoryId: 'electronics', price: 89.99, imageUrl: 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=400&q=80', description: 'Portable waterproof speaker.', rating: 4.8),

    // Fashion (Men's only)
    Product(id: 'f1', name: 'Men Leather Jacket', categoryId: 'fashion', price: 120.00, imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=400&q=80', description: 'Classic leather jacket for men.', rating: 4.8),
    Product(id: 'f2', name: 'Running Sneakers', categoryId: 'fashion', price: 75.00, imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=400&q=80', description: 'Comfortable sports sneakers.', rating: 4.6),
    Product(id: 'f3', name: 'Men Wristwatch', categoryId: 'fashion', price: 150.00, imageUrl: 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&w=400&q=80', description: 'Elegant analog wristwatch.', rating: 4.9),
    Product(id: 'f4', name: 'Leather Wallet', categoryId: 'fashion', price: 45.00, imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?auto=format&fit=crop&w=400&q=80', description: 'Genuine leather wallet.', rating: 4.7),
    Product(id: 'f5', name: 'Cotton T-Shirt', categoryId: 'fashion', price: 20.00, imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=400&q=80', description: 'Basic cotton t-shirt.', rating: 4.5),
    Product(id: 'f6', name: 'Denim Jeans', categoryId: 'fashion', price: 55.00, imageUrl: 'https://images.unsplash.com/photo-1542272604-784c46ce5be3?auto=format&fit=crop&w=400&q=80', description: 'Classic blue denim jeans.', rating: 4.6),

    // Sports
    Product(id: 's1', name: 'Soccer Ball', categoryId: 'sports', price: 25.00, imageUrl: 'https://images.unsplash.com/photo-1614632537197-38a17061c2bd?auto=format&fit=crop&w=400&q=80', description: 'Professional soccer ball.', rating: 4.8),
    Product(id: 's2', name: 'Gym Dumbbell', categoryId: 'sports', price: 45.00, imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?auto=format&fit=crop&w=400&q=80', description: 'Adjustable dumbbell set.', rating: 4.7),
    Product(id: 's3', name: 'Tennis Racket', categoryId: 'sports', price: 110.00, imageUrl: 'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=400&q=80', description: 'Lightweight tennis racket.', rating: 4.9),
    Product(id: 's4', name: 'Basketball', categoryId: 'sports', price: 30.00, imageUrl: 'https://images.unsplash.com/photo-1519861531473-9200262188bf?auto=format&fit=crop&w=400&q=80', description: 'Official size basketball.', rating: 4.6),
    Product(id: 's5', name: 'Yoga Mat', categoryId: 'sports', price: 20.00, imageUrl: 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?auto=format&fit=crop&w=400&q=80', description: 'Non-slip exercise mat.', rating: 4.8),
    Product(id: 's6', name: 'Boxing Gloves', categoryId: 'sports', price: 55.00, imageUrl: 'https://images.unsplash.com/photo-1549719386-74dfcbf7dbed?auto=format&fit=crop&w=400&q=80', description: 'Training boxing gloves.', rating: 4.7),

    // Perfumes
    Product(id: 'b1', name: 'Oud Perfume', categoryId: 'beauty', price: 85.00, imageUrl: 'https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=400&q=80', description: 'Luxury oriental perfume.', rating: 4.9),
    Product(id: 'b2', name: 'Men Cologne', categoryId: 'beauty', price: 65.00, imageUrl: 'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?auto=format&fit=crop&w=400&q=80', description: 'Fresh scent for men.', rating: 4.7),
    Product(id: 'b3', name: 'Shampoo Bottle', categoryId: 'beauty', price: 15.00, imageUrl: 'https://images.unsplash.com/photo-1585232351009-19597cfa55eb?auto=format&fit=crop&w=400&q=80', description: 'Nourishing daily shampoo.', rating: 4.5),
    Product(id: 'b4', name: 'Natural Soap', categoryId: 'beauty', price: 8.00, imageUrl: 'https://images.unsplash.com/photo-1600857062241-98e5dba7f214?auto=format&fit=crop&w=400&q=80', description: 'Organic handmade soap.', rating: 4.8),
    Product(id: 'b5', name: 'Skincare Lotion', categoryId: 'beauty', price: 35.00, imageUrl: 'https://images.unsplash.com/photo-1611077544629-9e8cbb6c243a?auto=format&fit=crop&w=400&q=80', description: 'Hydrating body lotion.', rating: 4.6),
    Product(id: 'b6', name: 'Beard Oil', categoryId: 'beauty', price: 22.00, imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?auto=format&fit=crop&w=400&q=80', description: 'Premium beard care oil.', rating: 4.7),

    // Stationery
    Product(id: 'st1', name: 'Scientific Calculator', categoryId: 'stationery', price: 25.00, imageUrl: 'https://images.unsplash.com/photo-1587145820266-a5951ee6f620?auto=format&fit=crop&w=400&q=80', description: 'Advanced math calculator.', rating: 4.8),
    Product(id: 'st2', name: 'Lined Notebook', categoryId: 'stationery', price: 10.00, imageUrl: 'https://images.unsplash.com/photo-1531346878377-a544f1225573?auto=format&fit=crop&w=400&q=80', description: 'High quality paper notebook.', rating: 4.6),
    Product(id: 'st3', name: 'Stapler', categoryId: 'stationery', price: 12.00, imageUrl: 'https://images.unsplash.com/photo-1563200057-0a370bcf4273?auto=format&fit=crop&w=400&q=80', description: 'Heavy duty office stapler.', rating: 4.5),
    Product(id: 'st4', name: 'Pen Set', categoryId: 'stationery', price: 8.00, imageUrl: 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?auto=format&fit=crop&w=400&q=80', description: 'Set of 5 gel pens.', rating: 4.7),
    Product(id: 'st5', name: 'Desk Organizer', categoryId: 'stationery', price: 18.00, imageUrl: 'https://images.unsplash.com/photo-1497219055493-eb502426466f?auto=format&fit=crop&w=400&q=80', description: 'Wooden desk organizer.', rating: 4.8),
    Product(id: 'st6', name: 'Sticky Notes', categoryId: 'stationery', price: 5.00, imageUrl: 'https://images.unsplash.com/photo-1586075010923-2dd4570fb338?auto=format&fit=crop&w=400&q=80', description: 'Colorful sticky notes pad.', rating: 4.4),

    // Furniture
    Product(id: 'fr1', name: 'Living Room Sofa', categoryId: 'furniture', price: 450.00, imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', description: 'Comfortable modern sofa.', rating: 4.9),
    Product(id: 'fr2', name: 'Office Chair', categoryId: 'furniture', price: 120.00, imageUrl: 'https://images.unsplash.com/photo-1505843490538-5133c6c7d0e1?auto=format&fit=crop&w=400&q=80', description: 'Ergonomic office chair.', rating: 4.7),
    Product(id: 'fr3', name: 'Desk Lamp', categoryId: 'furniture', price: 35.00, imageUrl: 'https://images.unsplash.com/photo-1507473884815-46f9037c35bd?auto=format&fit=crop&w=400&q=80', description: 'LED adjustable desk lamp.', rating: 4.8),
    Product(id: 'fr4', name: 'Coffee Table', categoryId: 'furniture', price: 85.00, imageUrl: 'https://images.unsplash.com/photo-1533090481720-856c6e3c1fdc?auto=format&fit=crop&w=400&q=80', description: 'Wooden living room table.', rating: 4.6),
    Product(id: 'fr5', name: 'Bookshelf', categoryId: 'furniture', price: 150.00, imageUrl: 'https://images.unsplash.com/photo-1598306441546-241fa02b37bd?auto=format&fit=crop&w=400&q=80', description: 'Tall wooden bookshelf.', rating: 4.7),
    Product(id: 'fr6', name: 'Wall Clock', categoryId: 'furniture', price: 25.00, imageUrl: 'https://images.unsplash.com/photo-1563861826100-9cb868fd1a14?auto=format&fit=crop&w=400&q=80', description: 'Minimalist wall clock.', rating: 4.5),

    // Toys
    Product(id: 't1', name: 'Toy Car', categoryId: 'toys', price: 15.00, imageUrl: 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=400&q=80', description: 'Die-cast metal toy car.', rating: 4.8),
    Product(id: 't2', name: 'Building Blocks', categoryId: 'toys', price: 45.00, imageUrl: 'https://images.unsplash.com/photo-1587655311006-2c6d7a469796?auto=format&fit=crop&w=400&q=80', description: 'Creative building blocks set.', rating: 4.9),
    Product(id: 't3', name: 'Action Figure', categoryId: 'toys', price: 20.00, imageUrl: 'https://images.unsplash.com/photo-1608226463990-23058f8bdf9b?auto=format&fit=crop&w=400&q=80', description: 'Superhero action figure.', rating: 4.7),
    Product(id: 't4', name: 'Board Game', categoryId: 'toys', price: 35.00, imageUrl: 'https://images.unsplash.com/photo-1610890716171-60a69d2d0c24?auto=format&fit=crop&w=400&q=80', description: 'Family strategy board game.', rating: 4.8),
    Product(id: 't5', name: 'Puzzle 1000 Pcs', categoryId: 'toys', price: 18.00, imageUrl: 'https://images.unsplash.com/photo-1589139851609-bcdd85786b6a?auto=format&fit=crop&w=400&q=80', description: 'Challenging landscape puzzle.', rating: 4.6),
    Product(id: 't6', name: 'Remote Control Car', categoryId: 'toys', price: 55.00, imageUrl: 'https://images.unsplash.com/photo-1587590227264-0ac64b38d387?auto=format&fit=crop&w=400&q=80', description: 'Fast remote control buggy.', rating: 4.7),

    // Others
    Product(id: 'o1', name: 'Coffee Maker', categoryId: 'others', price: 80.00, imageUrl: 'https://images.unsplash.com/photo-1517668808822-9844a1717c18?auto=format&fit=crop&w=400&q=80', description: 'Automatic drip coffee maker.', rating: 4.8),
    Product(id: 'o2', name: 'Ceramic Mug', categoryId: 'others', price: 12.00, imageUrl: 'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?auto=format&fit=crop&w=400&q=80', description: 'Handcrafted tea and coffee mug.', rating: 4.6),
    Product(id: 'o3', name: 'Water Bottle', categoryId: 'others', price: 20.00, imageUrl: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?auto=format&fit=crop&w=400&q=80', description: 'Stainless steel insulated bottle.', rating: 4.7),
    Product(id: 'o4', name: 'Umbrella', categoryId: 'others', price: 15.00, imageUrl: 'https://images.unsplash.com/photo-1515599818818-db8971fce81a?auto=format&fit=crop&w=400&q=80', description: 'Compact folding umbrella.', rating: 4.5),
    Product(id: 'o5', name: 'Backpack', categoryId: 'others', price: 40.00, imageUrl: 'https://images.unsplash.com/photo-1553062407912-220b335352c3?auto=format&fit=crop&w=400&q=80', description: 'Durable travel backpack.', rating: 4.8),
    Product(id: 'o6', name: 'Sunglasses', categoryId: 'others', price: 35.00, imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=400&q=80', description: 'UV protection sunglasses.', rating: 4.7),
  ];

  List<Category> get categories => _categories;
  List<Product> get allProducts => _allProducts;

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
