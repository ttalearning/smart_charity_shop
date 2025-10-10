import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get lineTotal => product.gia * quantity;

  Map<String, dynamic> toJson() => {
    'product': {
      'id': product.id,
      'tenSanPham': product.tenSanPham,
      'gia': product.gia,
      'moTa': product.moTa,
      'anhChinh': product.anhChinh,
      'loaiId': product.loaiId,
      'tenLoai': product.tenLoai,
    },
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final p = json['product'] as Map<String, dynamic>;
    return CartItem(
      product: Product.fromJson(p),
      quantity: json['quantity'] ?? 1,
    );
  }
}

class CartProvider with ChangeNotifier {
  static const _storageKey = 'smart_charity_cart_v1';

  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  double get subTotal => _items.fold(0.0, (sum, it) => sum + it.lineTotal);

  double get donation10 => subTotal * 0.10;

  int get totalQuantity => _items.fold(0, (sum, it) => sum + it.quantity);

  void add(Product p, {int quantity = 1}) {
    final idx = _items.indexWhere((e) => e.product.id == p.id);
    if (idx >= 0) {
      _items[idx].quantity += quantity;
    } else {
      _items.add(CartItem(product: p, quantity: quantity));
    }
    _persist();
    notifyListeners();
  }

  void remove(int productId) {
    _items.removeWhere((e) => e.product.id == productId);
    _persist();
    notifyListeners();
  }

  void setQuantity(int productId, int q) {
    final idx = _items.indexWhere((e) => e.product.id == productId);
    if (idx >= 0) {
      _items[idx].quantity = q.clamp(1, 999);
      _persist();
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    _persist();
    notifyListeners();
  }

  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_storageKey);
    if (raw == null) return;
    final List list = jsonDecode(raw);
    _items
      ..clear()
      ..addAll(list.map((e) => CartItem.fromJson(e)));
    notifyListeners();
  }

  Future<void> _persist() async {
    final sp = await SharedPreferences.getInstance();
    final jsonList = _items.map((e) => e.toJson()).toList();
    await sp.setString(_storageKey, jsonEncode(jsonList));
  }
}
