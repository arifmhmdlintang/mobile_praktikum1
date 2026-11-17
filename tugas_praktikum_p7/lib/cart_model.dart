import 'package:flutter/foundation.dart';

class Product {
  final String name, imageUrl;

  Product(this.name, this.imageUrl);
}

class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, this.quantity);
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => _items.isEmpty;

  void add(Product product) {
    final index = _indexOf(product);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product, 1));
    }

    notifyListeners();
  }

  void increase(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrease(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  int remove(CartItem item) {
    final index = _items.indexOf(item);
    _items.removeAt(index);
    notifyListeners();
    return index;
  }

  void restore(CartItem item, int index) {
    _items.insert(index.clamp(0, _items.length), item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int _indexOf(Product product) =>
      _items.indexWhere((item) => item.product.name == product.name);
}