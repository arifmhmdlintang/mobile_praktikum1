import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const Color kGold = Color(0xFFD4AF37);
const Color kBackground = Color(0xFF0F0F14);
const Color kCard = Color(0xFF1C1C24);
const Color kTextMuted = Color(0xFF9E9E9E);

final List<Map<String, String>> travelData = [
  {
    'title': 'Raja Ampat',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRiM2b4ud8AN6PjYG-jq180YFGthwPBiGzg5X_eN6lJYQ&s=10',
    'lokasi': 'Papua Barat Daya',
    'rating': '4.9',
    'deskripsi':
        'Surga bawah laut dengan gugusan pulau karst dan terumbu karang yang memukau. Cocok untuk diving, snorkeling, dan menikmati sunset di atas bukit.',
  },
  {
    'title': 'Bromo',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWb7vDRUojMd2j3v3VJwL2OF9Vv-lknh49x3RMmp9T_Q&s=10',
    'lokasi': 'Jawa Timur',
    'rating': '4.7',
    'deskripsi':
        'Gunung berapi aktif dengan panorama matahari terbit dan lautan pasir yang megah. Pengunjung biasanya memulai perjalanan sebelum fajar.',
  },
  {
    'title': 'Danau Toba',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjWY462enRI59GePvckmk6kBWzxZwTQW0I7iYjukHqkA&s=10',
    'lokasi': 'Sumatera Utara',
    'rating': '4.8',
    'deskripsi':
        'Danau vulkanik terbesar di Asia Tenggara dengan Pulau Samosir di tengahnya. Udara sejuk dan budaya Batak yang kental menjadi daya tarik utama.',
  },
  {
    'title': 'Borobudur',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJ6I6Et7_uJRn8UNDR-nJimeuDFVzWg-LG92mUzszVbQ&s=10',
    'lokasi': 'Jawa Tengah',
    'rating': '4.9',
    'deskripsi':
        'Candi Buddha terbesar di dunia yang dibangun pada abad ke-9. Dikenal dengan relief-reliefnya dan pemandangan saat matahari terbit.',
  },
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katalog Wisata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBackground,
        colorScheme: const ColorScheme.dark(primary: kGold, surface: kCard),
        appBarTheme: const AppBarTheme(
          backgroundColor: kBackground,
          foregroundColor: kGold,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: kGold,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Katalog Wisata'),
          bottom: TabBar(
            labelColor: kGold,
            unselectedLabelColor: kTextMuted,
            indicatorColor: kGold,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.list), text: 'List View'),
              Tab(icon: Icon(Icons.grid_on), text: 'Grid View'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildListView(context),
            buildGridView(context),
          ],
        ),
      ),
    );
  }
}

Widget wisataImage(String url, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
  return Image.network(
    url,
    width: width,
    height: height,
    fit: fit,
    loadingBuilder: (context, child, progress) {
      if (progress == null) return child;
      return Container(
        width: width,
        height: height,
        color: kCard,
        child: const Center(
          child: CircularProgressIndicator(color: kGold, strokeWidth: 2),
        ),
      );
    },
    errorBuilder: (context, error, stack) => Container(
      width: width,
      height: height,
      color: kCard,
      child: const Icon(Icons.landscape, color: kGold, size: 48),
    ),
  );
}

void openDetail(BuildContext context, Map<String, String> item) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => DetailPage(item: item)),
  );
}

Widget buildListView(BuildContext context) {
  return ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 8),
    itemCount: travelData.length,
    itemBuilder: (context, index) {
      final item = travelData[index];
      return Card(
        color: kCard,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: kGold.withOpacity(0.25)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: wisataImage(item['image']!, width: 90, height: 70),
          ),
          title: Text(
            item['title']!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          subtitle: Text(
            item['lokasi']!,
            style: const TextStyle(color: kTextMuted),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: kGold, size: 18),
              const SizedBox(width: 4),
              Text(
                item['rating']!,
                style: const TextStyle(
                  color: kGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          onTap: () => openDetail(context, item),
        ),
      );
    },
  );
}

Widget buildGridView(BuildContext context) {
  return GridView.builder(
    padding: const EdgeInsets.all(12),
    itemCount: travelData.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.85,
    ),
    itemBuilder: (context, index) {
      final item = travelData[index];
      return Card(
        color: kCard,
        elevation: 6,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: kGold.withOpacity(0.25)),
        ),
        child: InkWell(
          onTap: () => openDetail(context, item),
          child: Stack(
            fit: StackFit.expand,
            children: [
              wisataImage(item['image']!),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star, color: kGold, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            item['rating']!,
                            style: const TextStyle(
                              color: kGold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class DetailPage extends StatelessWidget {
  final Map<String, String> item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item['title']!)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            wisataImage(item['image']!, width: double.infinity, height: 280),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: kTextMuted, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        item['lokasi']!,
                        style: const TextStyle(color: kTextMuted, fontSize: 15),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: kGold),
                      const SizedBox(width: 4),
                      Text(
                        item['rating']!,
                        style: const TextStyle(
                          color: kGold,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 32),
                  const Text(
                    'Tentang Destinasi',
                    style: TextStyle(
                      color: kGold,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['deskripsi']!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGold,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: kCard,
                            content: Text(
                              '${item['title']!} ditambahkan ke favorit',
                              style: const TextStyle(color: kGold),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Tambah ke Favorit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}