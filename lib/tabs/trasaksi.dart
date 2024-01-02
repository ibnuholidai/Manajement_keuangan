import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RiwayatTransaksi extends StatefulWidget {
  @override
  _RiwayatTransaksiState createState() => _RiwayatTransaksiState();
}

class _RiwayatTransaksiState extends State<RiwayatTransaksi> {
  DatabaseReference? db_Ref;
  DateTime _tanggalFilter = DateTime.now();

  double pengeluaran_akhir = 0;
  double pemasukan_akhir = 0;
  bool isButtonEnabled = false;

  void _openDatePicker() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _tanggalFilter,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        // Panggil fungsi _tanggalFilterChanged untuk mengupdate tanggalFilter
        _tanggalFilterChanged(value);
      }
    });
    ;

    if (newDate != null) {
      setState(() {
        _tanggalFilter = newDate;
      });
    }
  }

  void _tanggalFilterChanged(DateTime value) {
    setState(() {
      // Update tanggalFilter dengan tanggal yang baru
      _tanggalFilter = value;
      // Set pengeluaran_akhir dan pemasukan_akhir ke 0
      pengeluaran_akhir = 0;
      pemasukan_akhir = 0;
    });
  }

  void hitung() {
    setState(() {
      pengeluaran_akhir;
      pemasukan_akhir;
      isButtonEnabled = false;
    });
  }

  void _refreshData() {
    setState(() {
      pengeluaran_akhir = 0;
      pemasukan_akhir = 0;
      isButtonEnabled = true;
    });
  }

  @override
  void initState() {
    db_Ref = FirebaseDatabase.instance.ref().child('transaksi');
    pengeluaran_akhir = 0;
    pemasukan_akhir = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double mediaquery_height = MediaQuery.of(context).size.height * 0.2;
    final double mediaquery_height_normal = MediaQuery.of(context).size.height;
    final double mediaquery_width = MediaQuery.of(context).size.width;
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0);

    String formattedPengeluaran = formatCurrency.format(pengeluaran_akhir);
    String formattedPemasukan = formatCurrency.format(pemasukan_akhir);

    DatabaseReference db_Ref2 =
        FirebaseDatabase.instance.ref().child('transaksi');
    DatabaseReference db_Ref = FirebaseDatabase.instance.ref().child('barang');
    String formattedDate = DateFormat('yyyy-MM-dd').format(_tanggalFilter);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Riwayat Transaksi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo[900],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: mediaquery_height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Filter tanggal:'),
                SizedBox(width: mediaquery_width * 0.03),
                GestureDetector(
                  onTap: _openDatePicker,
                  child: Row(
                    children: [
                      Text(
                        '${_tanggalFilter.day}/${_tanggalFilter.month}/${_tanggalFilter.year}',
                        style: TextStyle(fontSize: mediaquery_width * 0.04),
                      ),
                      SizedBox(width: mediaquery_width * 0.05),
                      Icon(Icons.edit_calendar_outlined),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    height: mediaquery_height * 0.5,
                    width: mediaquery_width * 0.4,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("pengeluaran"),
                          Text("$formattedPengeluaran"),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    height: mediaquery_height * 0.5,
                    width: mediaquery_width * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("pemasukan"),
                        Text("$formattedPemasukan"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: isButtonEnabled ? hitung : null,
                child: Text("Hitung"),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Container(
                    height: mediaquery_height * 0.2,
                    width: mediaquery_width,
                    decoration: BoxDecoration(
                        color: Colors.indigo[900],
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "Riwayat Transaksi",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),
            Container(
              height: mediaquery_height * 2.55,
              child: ListView(children: [
                FirebaseAnimatedList(
                  key: ValueKey(_tanggalFilter),
                  controller: ScrollController(),
                  query: db_Ref2.orderByChild('created').equalTo(formattedDate),
                  shrinkWrap: true,
                  itemBuilder: (context, snapshot, animation, index) {
                    Map Contact = snapshot.value as Map;
                    Contact['key'] = snapshot.key;
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(_tanggalFilter);
                    String createdDate = Contact['created'];
                    DateTime dateTime = DateTime.parse(createdDate);
                    String tanggal = DateFormat('yyyy-MM-dd').format(dateTime);
                    String created =
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

                    double pemasukan =
                        double.tryParse(Contact['pemasukan'] ?? '0') ?? 0;
                    double pengeluaran =
                        double.tryParse(Contact['pengeluaran'] ?? '0') ?? 0;
                    pengeluaran_akhir += pengeluaran;
                    pemasukan_akhir += pemasukan;

                    return Container(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Contact["pengeluaran"] == null
                                ? CircleAvatar(
                                    child: Image.asset(
                                        "assets/images/transaksi-masuk.png"),
                                  )
                                : CircleAvatar(
                                    child: Image.asset(
                                        "assets/images/transaksi-keluar.png"),
                                  ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Contact['nama'] ?? "No name",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Harga: " + (Contact['harga'] ?? ""),
                                ),
                                Text(
                                  "Jumlah: " + (Contact['jumlah'] ?? ""),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              "Created: " + (Contact['created'] ?? ""),
                            ),
                            trailing: Contact["pengeluaran"] == null
                                ? Text(
                                    "+ " +
                                        formatCurrency.format(int.parse(
                                            Contact['pemasukan'] ?? "0")),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: mediaquery_width * 0.045,
                                    ),
                                  )
                                : Text(
                                    "- " +
                                        formatCurrency.format(int.parse(
                                            Contact['pengeluaran'] ?? "0")),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: mediaquery_width * 0.045,
                                    ),
                                  ),
                          )),
                    );
                    // :
                    // SizedBox();
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
