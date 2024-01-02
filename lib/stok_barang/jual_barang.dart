import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../tabs/sock_barang.dart';

class JualForm extends StatefulWidget {
  String Contact_Key;
  JualForm({required this.Contact_Key});

  @override
  _JualFormState createState() => _JualFormState();
}

class _JualFormState extends State<JualForm> {
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  int _totalHarga = 0;
  DatabaseReference? db_Ref;
  DatabaseReference? db_Ref2;
  var url;
  var url1;
  String jumlah_awal = "0";
  String stock = "0";
  int jumlah_akhir = 0;
  String nama_barang = "";
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
      stock = Contact['jumlah_barang'] ?? "not found";
      nama_barang = Contact['name'] ?? "nama not found";
      _hargaController.text = Contact['harga_barang'] ?? "harga not found";
    });
  }

  void _hitungTotalHarga() {
    int jumlah = int.tryParse(_jumlahController.text) ?? 0;
    int harga = int.tryParse(_hargaController.text) ?? 0;

    setState(() {
      _totalHarga = (jumlah * harga) ;
    });
  }

  void getTotalPengeluaran() async {
    double totalPengeluaran = 0;
    final snapshot =
        await FirebaseDatabase.instance.ref().child('transaksi').once();
    final DataSnapshot data = snapshot as DataSnapshot;

    Map<dynamic, dynamic>? values = data.value as Map?;
    if (values != null) {
      values.forEach((key, value) {
        totalPengeluaran += double.parse(value['pengeluaran']);
      });
    }
    print('Total Pengeluaran: $totalPengeluaran');
  }

  @override
  Widget build(BuildContext context) {
    String formattedtotalharga = formatCurrency.format(_totalHarga);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("jual Barang"),
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
              suffixText: "stock = $stock",
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
            onPressed: () {
              int input = int.tryParse(_jumlahController.text) ?? 0;
              int? jumlah1 = int.tryParse(jumlah_awal);
              if (input > jumlah1!) {
                // Tampilkan pesan error jika input melebihi stok
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Input melebihi stok'),
                  backgroundColor: Colors.red,
                ));
              } else {
                // Lakukan aksi jika input valid
                // Contoh: kurangi stok dengan jumlah input
                setState(() {
                  updateContact();
                });
                _jumlahController.clear();
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void updateContact() async {
    
    int? jumlah1 = int.tryParse(jumlah_awal);
    int jumlah2 = int.parse(_jumlahController.text);
    jumlah_akhir = (jumlah1! - jumlah2);
    String jumlah_akhir2 = jumlah_akhir.toString();
    DateTime datetimeNow = DateTime.now();
    String tanggal = DateFormat('yyyy-MM-dd').format(datetimeNow).toString();

    try {
      Map<String, String> Contact = {
        'jumlah_barang': jumlah_akhir2,
      };

      Map<String, String> transaksi = {
        'pemasukan': _totalHarga.toString(),
        'created': tanggal.toString(),
        'nama': nama_barang,
        'jumlah': _jumlahController.text,
        'harga': _hargaController.text,
      };

      db_Ref2!.push().set(transaksi).whenComplete(() {});

      db_Ref!.child(widget.Contact_Key).update(Contact).whenComplete(() {
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (_) => Stockbarang(),
          ),
        );
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  directupdate() {
    if (url != null) {
      Map<String, String> Contact = {
        'jumlah_harga': _jumlahController.text,
        'url': url,
      };

      db_Ref!.child(widget.Contact_Key).update(Contact).whenComplete(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Stockbarang(),
          ),
        );
      });
    }
  }
}
