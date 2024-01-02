import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:manajement_keuangan/stok_barang/beli_barang.dart';
import 'package:manajement_keuangan/stok_barang/jual_barang.dart';
import 'package:manajement_keuangan/stok_barang/update_barang.dart';


import '../signpage/sign.dart';

class Stockbarang extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Stockbarang> {
  Future<void> _onLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed(LoginPage.routename);
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference db_Ref = FirebaseDatabase.instance.ref().child('barang');
    bool _isSigningOut = false;

    final double mediaquery_height = MediaQuery.of(context).size.height * 0.2;
    final double mediaquery_height_normal = MediaQuery.of(context).size.height;
    final double mediaquery_width = MediaQuery.of(context).size.width;

    return Scaffold(

      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              setState(() {
                _isSigningOut = true;
              });
              await FirebaseAuth.instance.signOut();
              setState(() {
                _isSigningOut = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          )
        ],
        centerTitle: true,
        title: Text(
          'Stock Barang',
          style: TextStyle(
            color: Colors.white,
            fontSize: mediaquery_width * 0.07,
          ),
        ),
        backgroundColor: Colors.indigo[900],
      ),
      body: FirebaseAnimatedList(
        query: db_Ref,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          Map Contact = snapshot.value as Map;
          Contact['key'] = snapshot.key;
          // print(Contact);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UpdateRecord(
                    Contact_Key: Contact['key'],
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Divider(color: Colors.grey),
                Container(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Container(
                          width: mediaquery_width * 0.1,
                          height: mediaquery_height_normal * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                Contact['url'],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          Contact['name'] ?? "No name",
                          style: TextStyle(
                            fontSize: mediaquery_width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          Contact['satuan'] + " : " + Contact['harga_barang'],
                          style: TextStyle(fontSize: mediaquery_width * 0.04),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: mediaquery_height * 0.12,
                                    width: mediaquery_width * 0.2,
                                    child: Center(
                                      child: Text(
                                        'Jual',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => JualForm(
                                          Contact_Key: Contact['key'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: mediaquery_height * 0.1,
                                ),
                                GestureDetector(
                                  child: Container(
                                    height: mediaquery_height * 0.12,
                                    width: mediaquery_width * 0.2,
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Beli',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => beliform(
                                          Contact_Key: Contact['key'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Contact'),
                                      content: Text(
                                          'Are you sure you want to delete this contact?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            db_Ref
                                                .child(Contact['key'])
                                                .remove();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Icon(LineariconsFree.trash,size: mediaquery_width * 0.08),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
