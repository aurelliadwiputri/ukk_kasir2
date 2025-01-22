import 'package:flutter/material.dart';
import 'package:percobaan_ukk_kasir/pelanggan/update.dart';
import 'package:percobaan_ukk_kasir/penjualan/indexpenjualan.dart';
import 'package:percobaan_ukk_kasir/penjualan/insertpenjualan.dart';
import 'package:percobaan_ukk_kasir/penjualan/updatepenjualan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPenjualan extends StatefulWidget {
  final int penjualanID;

  EditPenjualan({Key? key, required this.penjualanID}) : super(key: key);

  @override
  State<EditPenjualan> createState() => _EditPenjualanState();
}

class _EditPenjualanState extends State<EditPenjualan> {
  final _tanggalpenjualan = TextEditingController();
  final _totalharga = TextEditingController();
  final _penjualanID= TextEditingController();
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
          .eq('penjualanID', widget.penjualanID)
          .single();

      if (data == null) {
        throw Exception('Data penjualan tidak ditemukan');
      }

      setState(() {
        _tanggalpenjualan.text = data['tanggalpenjualan'] ?? '';
        _totalharga.text = data['totalharga'] ?? '';
        _penjualanID.text = data['penjualanID'] ?? '';
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
          'totalharga': _totalharga.text,
          'penjualanID': _penjualanID.text,
        }).eq('penjualanID', widget.penjualanID);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data penjualan berhasil diperbarui')),
        );
        Navigator.pop(context, true);
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
                        labelText: 'tanggal Penjualan',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'tanggal wajib diisi';
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
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _penjualanID,
                      decoration: InputDecoration(
                        labelText: 'penjualanID',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'penjualanID wajib diisi';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'penjualanID hanya boleh berisi angka';
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