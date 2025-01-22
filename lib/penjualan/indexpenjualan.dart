import 'package:flutter/material.dart';
import 'package:percobaan_ukk_kasir/penjualan/indexpenjualan.dart';
import 'package:percobaan_ukk_kasir/penjualan/insertpenjualan.dart';
import 'package:percobaan_ukk_kasir/penjualan/updatepenjualan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PenjualanTab extends StatefulWidget {
  @override
  _PenjualanTabState createState() => _PenjualanTabState();
}

class _PenjualanTabState extends State<PenjualanTab> {
  List<Map<String, dynamic>> Penjualan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
  }

  Future<void> fetchPenjualan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await Supabase.instance.client.from('penjualan').select();
      setState(() {
        Penjualan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching penjualan: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletepenjualan(int id) async {
    try {
      await Supabase.instance.client
          .from('penjualan')
          .delete()
          .eq('penjualanID', id);
      fetchPenjualan();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('penjualan berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting penjualan: $e')),
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
          : Penjualan.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada penjualan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  padding: EdgeInsets.all(10),
                  itemCount: Penjualan.length,
                  itemBuilder: (context, index) {
                    final langgan = Penjualan[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              langgan['tanggalpenjualan'] ??
                                  'tanggalpenjualan tidak tersedia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              langgan['totalharga'] ?? 'totalharga tidak tersedia',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              langgan['penjualanID'] ?? 'Tidak tersedia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,

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
                                    final penjualanID =
                                        langgan['penjualanID'] ?? 0;
                                    if (penjualanID != 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditPenjualan(penjualanID: penjualanID)
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'ID penjualan tidak valid')),
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
                                          title: Text('Hapus penjualan'),
                                          content: Text(
                                              'Apakah Anda yakin ingin menghapus penjualan ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deletepenjualan(
                                                    langgan['penjualanID']);
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
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPenjualan()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
