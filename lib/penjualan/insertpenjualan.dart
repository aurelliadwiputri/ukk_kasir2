import 'package:flutter/material.dart';
import 'package:percobaan_ukk_kasir/homapage.dart';
import 'package:percobaan_ukk_kasir/penjualan/indexpenjualan.dart';
import 'package:percobaan_ukk_kasir/penjualan/insertpenjualan.dart';
import 'package:percobaan_ukk_kasir/penjualan/updatepenjualan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPenjualan extends StatefulWidget {
  AddPenjualan({super.key});

  @override
  State<AddPenjualan> createState() => _AddPenjualanState();
}

class _AddPenjualanState extends State<AddPenjualan> {
  // final _penjualanid = TextEditingController();
  final _totalharga = TextEditingController();
  final _pelangganid = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> langgan() async {
    if (_formKey.currentState!.validate()) {
      // final String penjualanid = _penjualanid.text;
      
      final double totalharga = double.parse(_totalharga.text); // Konversi ke double
      final int pelangganid = int.parse(_pelangganid.text); // Konversi ke int

      try {
        final response = await Supabase.instance.client.from('penjualan').insert({
          // 'penjualanid': penjualanid,
          
          'totalharga': totalharga,
          'pelangganid': pelangganid,
        });

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal menambahkan penjualan: ${response.error!.message}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Penjualan berhasil ditambahkan')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Tambah Penjualan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
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
                  if (double.tryParse(value) == null) {
                    return 'Harus berupa angka';
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
                  if (double.tryParse(value) == null) {
                    return 'Harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: langgan,
                child: Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
