import 'package:flutter/material.dart';
import 'package:percobaan_ukk_kasir/produk/insertproduk.dart';
import 'package:percobaan_ukk_kasir/produk/indexproduk.dart';
import 'package:percobaan_ukk_kasir/produk/updateproduk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProdukTab extends StatefulWidget {
  @override
  _ProdukTabState createState() => _ProdukTabState();
}

class _ProdukTabState extends State<ProdukTab> {
  List<Map<String, dynamic>> produk = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('Produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching produk: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteProduk(int id) async {
    try {
      final response = await Supabase.instance.client
          .from('Produk')
          .delete()
          .eq('produkid', id)
          .select();
          
      fetchProduk();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting produk: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : produk.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  padding: EdgeInsets.all(3),
                  itemCount: produk.length,
                  itemBuilder: (context, index) {
                    final langgan = produk[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: SizedBox(
                        height: 150,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                langgan['namaproduk']?.toString() ??
                                    'Nama produk tidak tersedia',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                langgan['harga']?.toString() ??
                                    'Harga tidak tersedia',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(height: 8),
                              Text(
                                langgan['stok']?.toString() ??
                                    'Stok tidak tersedia',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Colors.blueAccent),
                                    onPressed: () {
                                      final produkid =
                                          langgan['produkid'] ?? 0;
                                      if (produkid != 0) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditProduk(produkid: produkid)
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'ID produk tidak valid'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Hapus Produk'),
                                            content: Text(
                                                'Apakah Anda yakin ingin menghapus produk ini?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Batal'),
                                              ),
                                              TextButton(
                                              onPressed: () {
                                                deleteProduk(
                                                    langgan['produkid']);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Hapus'),
                                            ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduk()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
