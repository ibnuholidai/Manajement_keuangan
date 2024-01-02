import 'dart:core';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../tabs/sock_barang.dart';

class beliform extends StatefulWidget {
  beliform({required this.Contact_Key});

  String Contact_Key;

  @override
  _beliFormState createState() => _beliFormState();
}

class _beliFormState extends State<beliform> {
  DatabaseReference? db_Ref;
  DatabaseReference? db_Ref2;
  int jumlah_akhir = 0;
  String jumlah_awal = "0";
  String nama_barang = "";
  var url;
  var url1;
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  int _totalHarga = 0;
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0);

  @override
  void initState() {
    _jumlahController.addListener(_hitungTotalHarga);
    _hargaController.addListener(_hitungTotalHarga);
    db_Ref = FirebaseDatabase.instance.ref().child('barang');
    db_Ref2 = FirebaseDatabase.instance.ref().child('transaksi');
    super.initState();
    Contactt_data();
  }

  void Contactt_data() async {
    DataSnapshot snapshot = await db_Ref!.child(widget.Contact_Key).get();
    Map Contact = snapshot.value as Map;
    jumlah_awal = Contact['jumlah_barang'] ?? "not found";

    setState(() {
      nama_barang = Contact['name'] ?? "nama not found";
    });
  }

  void updateContact() async {
    int? jumlah1 = int.tryParse(jumlah_awal);
    int jumlah2 = int.parse(_jumlahController.text);
    jumlah_akhir = (jumlah1! + jumlah2);
    String jumlah_akhir2 = jumlah_akhir.toString();
    DateTime datetimeNow = DateTime.now();
    String tanggal = DateFormat('yyyy-MM-dd').format(datetimeNow).toString();

    try {
      Map<String, String> Contact = {
        'jumlah_barang': jumlah_akhir2,
      };

      Map<String, String> transaksi = {
        'pengeluaran': _totalHarga.toString(),
        'created': tanggal.toString(),
        'nama': nama_barang,
        'harga': _hargaController.text,
        'jumlah': _jumlahController.text,
      };

      db_Ref!.child(widget.Contact_Key).update(Contact).whenComplete(() {
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (_) => Stockbarang(),
          ),
        );
      });

      db_Ref2!.push().set(transaksi).whenComplete(() {});
    } on Exception catch (e) {
      print(e);
    }
  }

  void _hitungTotalHarga() {
    int jumlah = int.tryParse(_jumlahController.text) ?? 0;
    int harga = int.tryParse(_hargaController.text) ?? 0;

    setState(() {
      _totalHarga = jumlah * harga;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedtotalharga = formatCurrency.format(_totalHarga);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Beli Barang"),
        backgroundColor: Colors.indigo[900],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text("$nama_barang",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _jumlahController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixText: "stock : $jumlah_awal",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Jumlah Barang',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _hargaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Harga Barang',
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Total Harga: $formattedtotalharga',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: updateContact,
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
