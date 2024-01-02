import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manajement_keuangan/tabs/sock_barang.dart';

class ccreate extends StatefulWidget {
  @override
  State<ccreate> createState() => ccreateState();
}

class ccreateState extends State<ccreate> {
  TextEditingController name = TextEditingController();
  TextEditingController satuan = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController stock = TextEditingController();
  String jumlah_barang = "0";
  File? file;
  ImagePicker image = ImagePicker();
  var url;
  DatabaseReference? dbRef;
  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('barang');
  }

  @override
  Widget build(BuildContext context) {

    final double mediaquery_height = MediaQuery.of(context).size.height * 0.2;
    final double mediaquery_height_normal = MediaQuery.of(context).size.height;
    final double mediaquery_width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tambah Barang',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.indigo[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                  height: mediaquery_height * 0.8,
                  width: mediaquery_height * 0.8,
                  child: file == null
                      ? IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            size: mediaquery_width * 0.1,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          onPressed: () {
                            getImage();
                          },
                        )
                      : MaterialButton(
                          height: mediaquery_height * 0.1,
                          child: Image.file(
                            file!,
                            fit: BoxFit.fill,
                          ),
                          onPressed: () {
                            getImage();
                          },
                        )),
            ),
            SizedBox(
              height: mediaquery_height * 0.05,
            ),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Name',
              ),
            ),
            SizedBox(
              height:  mediaquery_height * 0.05,
            ),
            TextFormField(
              controller: satuan,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Satuan',
              ),
            ),
            SizedBox(
              height:  mediaquery_height * 0.05,
            ),
            TextFormField(
              controller: stock,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
                labelText: 'stock',
              ),
            ),
            SizedBox(
              height:  mediaquery_height * 0.05,
            ),
            TextFormField(
              controller: number,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Harga jual',
              ),
              maxLength: 10,
            ),
            SizedBox(
              height:  mediaquery_height * 0.05,
            ),
            MaterialButton(
              height: mediaquery_height * 0.2,
              onPressed: () {
                // getImage();

                if (file != null) {
                  uploadFile();
                }
              },
              child: Text(
                "Add",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: mediaquery_width * 0.07,
                ),
              ),
              color: Colors.indigo[900],
            ),
          ],
        ),
      ),
    );
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });

    // print(file);
  }

  uploadFile() async {
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("contact_photo")
          .child("/${name.text}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
      if (url != null) {
        Map<String, String> Contact = {
          'name': name.text,
          'harga_barang': number.text,
          'satuan': satuan.text,
          'jumlah_barang': stock.text,
          'url': url,
        };

        dbRef!.push().set(Contact).whenComplete(() {
          Navigator.pop(
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
}
