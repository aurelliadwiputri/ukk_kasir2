import 'package:flutter/material.dart';
import 'package:percobaan_ukk_kasir/homapage.dart';
import 'package:percobaan_ukk_kasir/penjualan/indexpenjualan.dart';
import 'package:percobaan_ukk_kasir/penjualan/insertpenjualan.dart';
import 'package:percobaan_ukk_kasir/penjualan/updatepenjualan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPenjualan extends StatefulWidget {
  final int penjualanid;

  EditPenjualan({Key? key, required this.penjualanid}) : super(key: key);

  @override
  State<EditPenjualan> createState() => _EditPenjualanState();
}

class _EditPenjualanState extends State<EditPenjualan> {
  final _tanggalpenjualan= TextEditingController();
  final _totalharga= TextEditingController();
  final _pelangganid= TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPenjualanData();
  }

  Future<void> _loadPenjualanData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await Supabase.instance.client
          .from('penjualan')
          .select()
          .eq('penjualanid', widget.penjualanid)
          .single();

      if (data == null) {
        throw Exception('Data penjualan tidak ditemukan');
      }

      setState(() {
        _tanggalpenjualan.text = data['tanggalpenjualan'] ?? '';
         _totalharga.text = (data['totalharga'] ?? 0).toString();
        _pelangganid.text = (data['pelangganid'] ?? 0).toString();
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data penjualan: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updatePenjualan() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await Supabase.instance.client.from('penjualan').update({
          'tanggalpenjualan': _tanggalpenjualan.text,
           'totalharga': int.tryParse(_totalharga.text) ?? 0, // Konversi String ke int
          'pelangganid': int.tryParse(_pelangganid.text) ?? 0,
        }).eq('penjualanid', widget.penjualanid);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data penjualan berhasil diperbarui')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data penjualan: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Edit Penjualan'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _tanggalpenjualan,
                      decoration: InputDecoration(
                        labelText: 'tanggal penjualan',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'tanggal penjualan wajib diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _totalharga,
                      decoration: InputDecoration(
                        labelText: 'totalharga',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'totalharga wajib diisi';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'totalharga hanya boleh berisi angka';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _pelangganid,
                      decoration: InputDecoration(
                        labelText: 'pelangganid',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'pelangganid wajib diisi';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'pelangganid hanya boleh berisi angka';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: updatePenjualan,
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}