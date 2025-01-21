import 'package:flutter/material.dart';
import 'package:percobaan_ukk_kasir/pelanggan/index.dart';
import 'package:percobaan_ukk_kasir/pelanggan/insert.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(Icons.add),),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Home'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.dashboard), text: 'Detail penjual'),
              Tab(icon: Icon(Icons.shopping_cart), text: 'Produk'),
              Tab(icon: Icon(Icons.person), text: 'Costumer'),
              Tab(icon: Icon(Icons.dashboard), text: 'Penjualan'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Detail Penjual Content')),
            PelangganTab(),
            Center(child: Text('Customer Content')),
            Center(child: Text('Customer Content')),
          ],
        ),
      ),
    );
  }
}
