import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manajement_keuangan/tabs/sock_barang.dart';

class UpdateRecord extends StatefulWidget {
  String Contact_Key;
  UpdateRecord({required this.Contact_Key});

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  TextEditingController contactName = new TextEditingController();
  TextEditingController stock = new TextEditingController();
  TextEditingController contactsatuan = new TextEditingController();
  TextEditingController contactharga = new TextEditingController();
  var url;
  var url1;
  File? file;
  ImagePicker image = ImagePicker();
  DatabaseReference? db_Ref;

  @override
  void initState() {
    super.initState();
    db_Ref = FirebaseDatabase.instance.ref().child('barang');
    Contactt_data();
  }

  void Contactt_data() async {
    DataSnapshot snapshot = await db_Ref!.child(widget.Contact_Key).get();
    Map<dynamic, dynamic>? Contact = snapshot.value as Map?;
    if (Contact != null) {
      setState(() {
        contactName.text = Contact['name'] ?? "No name";
        contactsatuan.text = Contact['satuan'] ?? "No satuan";
        contactharga.text = Contact['harga_barang'] ?? "No harga";
        stock.text = Contact['jumlah_barang'] ?? "No jumlah";
        url = Contact['url'] ?? "No gambar";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final double mediaquery_height = MediaQuery.of(context).size.height * 0.2;
    final double mediaquery_height_normal = MediaQuery.of(context).size.height;
    final double mediaquery_width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Ubah Barang'),
        backgroundColor: Colors.indigo[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: mediaquery_height * 1,
                width: mediaquery_width * 1,
                child: url == null
                    ? file != null
                        ? MaterialButton(
                            height: mediaquery_height * 1,
                            child: Image.file(
                              file!,
                              fit: BoxFit.fill,
                            ),
                            onPressed: () {
                              getImage();
                            },
                          )
                        : MaterialButton(
                            onPressed: () {
                              getImage();
                            },
                            child: Icon(Icons.camera_alt_outlined),
                          )
                    : MaterialButton(
                        height: mediaquery_height * 1,
                        child: Image.network(url),
                        onPressed: () {
                          getImage();
                        },
                      ),
              ),
            ),
            SizedBox(
              height: mediaquery_height * 0.05,
            ),
            TextFormField(
              controller: contactName,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Name',
              ),
            ),
            SizedBox(
              height: mediaquery_height * 0.05,
            ),
            TextFormField(
              controller: contactsatuan,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: 'satuan',
              ),
            ),
            SizedBox(
              height: mediaquery_height * 0.05,
            ),
            TextFormField(
              
              controller: stock,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: 'stock',
              ),
            ),
            SizedBox(
              height: mediaquery_height * 0.05,
            ),
            TextFormField(
              controller: contactharga,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: 'harga',
              ),
              maxLength: 10,
            ),
            SizedBox(
              height: mediaquery_height * 0.05,
            ),
            ElevatedButton(
              
              onPressed: () {
                if (file != null) {
                  uploadFile();
                } else {
                  directupdate();
                }
              },
              child: Text(
                "Simpan",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      url = null;
      file = File(img!.path);
    });

    // print(file);
  }

  uploadFile() async {
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("contact_photo")
          .child("/${contactName.text}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url1 = await snapshot.ref.getDownloadURL();
      setState(() {
        url1 = url1;
      });
      if (url1 != null) {
        Map<String, String> Contact = {
          'name': contactName.text,
          'harga_barang': contactharga.text,
          'satuan': contactsatuan.text,
          'url': url1,
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
    } on Exception catch (e) {
      print(e);
    }
  }

  directupdate() {
    if (url != null) {
      Map<String, String> Contact = {
        'name': contactName.text,
        'harga_barang': contactharga.text,
        'satuan': contactsatuan.text,
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
