import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';

const _primary = Color(0xFF4F46E5);
const _accent = Color(0xFFEC4899);

const _headerGradient = LinearGradient(
  colors: [Color(0xFF4F46E5), Color(0xFF9333EA), Color(0xFFEC4899)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => CartModel(),
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Lintang Store',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: _primary, secondary: _accent),
      scaffoldBackgroundColor: const Color(0xFFF3F4FB),
      useMaterial3: true,
    ),
    home: const ProductPage(),
  );
}

final products = [
  Product('Laptop',
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=600'),
  Product('Mouse',
      'https://images.unsplash.com/photo-1527814050087-3793815479db?w=600'),
  Product('Keyboard',
      'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600'),
  Product('Headphone',
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600'),
];

PreferredSizeWidget _appBar(String title, {List<Widget>? actions}) => AppBar(
  title: Text(
    title,
    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  ),
  elevation: 0,
  iconTheme: const IconThemeData(color: Colors.white),
  flexibleSpace: Container(
    decoration: const BoxDecoration(gradient: _headerGradient),
  ),
  actions: actions,
);

Widget productImage(String url, {double? width, double? height}) => ClipRRect(
  borderRadius: BorderRadius.circular(14),
  child: SizedBox(
    width: width,
    height: height,
    child: Image.network(
      url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
      errorBuilder: (context, error, stack) => Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      ),
    ),
  ),
);

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: _appBar(
      'Lintang Store',
      actions: [
        Consumer<CartModel>(
          builder: (context, cart, _) => IconButton(
            tooltip: 'Keranjang',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            ),
            icon: Badge(
              label: Text('${cart.totalItems}'),
              isLabelVisible: cart.totalItems > 0,
              backgroundColor: _accent,
              child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
      
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: _headerGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang di',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 4),
                Text(
                  'Lintang Store',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Grid produk
          Expanded(
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) =>
                  _ProductCard(product: products[index]),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: _primary.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: productImage(product.imageUrl),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: () => context.read<CartModel>().add(product),
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text('Tambah'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  void _hapus(BuildContext context, CartModel cart, CartItem item) {
    final index = cart.remove(item);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${item.product.name} dihapus dari keranjang'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'BATALKAN',
            textColor: Colors.amberAccent,
            onPressed: () => cart.restore(item, index),
          ),
        ),
      );
  }

  Future<void> _konfirmasiKosongkan(BuildContext context, CartModel cart) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kosongkan keranjang?'),
        content: const Text('Semua barang di keranjang akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (ok == true) cart.clear();
  }

  @override
  Widget build(BuildContext context) => Consumer<CartModel>(
    builder: (context, cart, _) => Scaffold(
      appBar: _appBar(
        'Keranjang Saya',
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: () => _konfirmasiKosongkan(context, cart),
              child: const Text(
                'Kosongkan',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: cart.isEmpty
          ? const _KeranjangKosong()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];

                return Dismissible(
                  key: ObjectKey(item),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _hapus(context, cart, item),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF43F5E), Color(0xFFEF4444)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  child: _CartItemCard(
                    item: item,
                    cart: cart,
                    onHapus: () => _hapus(context, cart, item),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : _Ringkasan(
              totalItems: cart.totalItems,
              onCheckout: () {
                cart.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pesanan berhasil dibuat'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
    ),
  );
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final CartModel cart;
  final VoidCallback onHapus;

  const _CartItemCard({
    required this.item,
    required this.cart,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: _primary.withOpacity(0.08),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      children: [
        productImage(item.product.imageUrl, width: 85, height: 85),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _TombolJumlah(
                    icon: Icons.remove,
                    onTap: () => cart.decrease(item),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  _TombolJumlah(
                    icon: Icons.add,
                    onTap: () => cart.increase(item),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Hapus',
          onPressed: onHapus,
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFFEE2E2),
          ),
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
      ],
    ),
  );
}

class _TombolJumlah extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TombolJumlah({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18, color: _primary),
    ),
  );
}

class _KeranjangKosong extends StatelessWidget {
  const _KeranjangKosong();

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: const BoxDecoration(
            gradient: _headerGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            size: 56,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Keranjang masih kosong',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Yuk, tambahkan produk favoritmu',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

class _Ringkasan extends StatelessWidget {
  final int totalItems;
  final VoidCallback onCheckout;

  const _Ringkasan({required this.totalItems, required this.onCheckout});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      boxShadow: [
        BoxShadow(
          color: _primary.withOpacity(0.12),
          blurRadius: 18,
          offset: const Offset(0, -4),
        ),
      ],
    ),
    child: SafeArea(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Total barang', style: TextStyle(color: Colors.grey)),
              Text(
                '$totalItems item',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: _primary,
                ),
              ),
            ],
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: onCheckout,
            style: FilledButton.styleFrom(
              backgroundColor: _primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.payment),
            label: const Text('Checkout'),
          ),
        ],
      ),
    ),
  );
}