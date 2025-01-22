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
  final _tanggalpenjualan= TextEditingController();
  final _totalharga = TextEditingController();
  final _penjualanID = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> langgan() async {
    if (_formKey.currentState!.validate()) {
      final String tanggalpenjualan = _tanggalpenjualan.text;
      final String totalharga = _totalharga.text;
      final String penjualanID = _penjualanID.text;

      try {
        final response =
            await Supabase.instance.client.from('penjualan').insert(
          {
            'tanggalpenjualan': tanggalpenjualan,
            'totalharga': totalharga,
            'penjualanID': penjualanID
          }
        );

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal menambahkan penjualan: ${response.error!.message}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('penjualan berhasil ditambahkan')),
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
        title: Text('Tambah penjualan'),
      ),
      body: Padding(
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