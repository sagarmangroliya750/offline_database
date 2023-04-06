
// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, prefer_const_constructors, must_be_immutable, depend_on_referenced_packages, avoid_print
import 'package:flutter/material.dart';
import 'package:offline_database/db__showtable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class db_query extends StatefulWidget {

  static Database ? database;
  String user;
  String password;
  int id;
  db_query(this.user,this.password,this.id);

  @override
  State<db_query> createState() => _db_queryState();
}

class _db_queryState extends State<db_query> {
  TextEditingController tuser = TextEditingController();
  TextEditingController tpassword = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    create_data();
    tuser.text = widget.user;
    tpassword.text = widget.password;
  }

  create_data() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'datatable.db');

    db_query.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute('CREATE TABLE datatable (id INTEGER PRIMARY KEY AUTOINCREMENT, user TEXT, password TEXT)');
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Database"),centerTitle:true,
      ),
      body: Container(
        width: 405,
        height: 500,margin:EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: ListView(
          children: [
            const SizedBox(height:20),
            Container(
              width: 150, height: 30,
              margin: const EdgeInsets.all(10),
              child: const Text("Username 👤", style: TextStyle(fontSize:27,letterSpacing:1.5),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller:tuser,decoration:InputDecoration(contentPadding:EdgeInsets.all(17),
                  border:OutlineInputBorder(borderRadius:BorderRadius.circular(30)),
                  hintText:"Enter username",prefixIcon:Icon(Icons.supervised_user_circle)),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 150, height: 30,
              margin: EdgeInsets.all(10),
              //   color: Colors.indigo,
              child: Text("Password 🔑",style: TextStyle(fontSize: 27,letterSpacing:1.5)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller:tpassword,decoration:InputDecoration(contentPadding:EdgeInsets.all(17),
                  border:OutlineInputBorder(borderRadius:BorderRadius.circular(30)),
                  hintText:"Enter password",prefixIcon:Icon(Icons.password)),
              ),
            ),
            Column(
              children: [
                SizedBox(height:30),
                ElevatedButton(style:ElevatedButton.styleFrom(shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(15)),
                    fixedSize: Size(180,42)),
                    onPressed: () {
                      if(tuser.text=="" && tpassword.text=="")
                      {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text("Please"),
                          );
                        },);
                      }else {
                        if (widget.id == 0) {
                          String user = tuser.text;
                          String password = tpassword.text;
                          String query = "INSERT INTO datatable VALUES(NULL, '$user' , '$password')";
                          db_query.database!.rawInsert(query).then((value) {
                            print(value);
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => db_showtable(),));
                        }
                        else {
                          String update = "UPDATE datatable SET user = '${tuser
                              .text}' , password = '${tpassword
                              .text}' WHERE id = ${widget.id}";
                          db_query.database!.rawUpdate(update);
                          setState(() {});
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => db_showtable(),));
                        }
                      }
                    }, child:Text((widget.id==0) ? "Submit Data":"Update Data",style:TextStyle(fontSize:15,letterSpacing:1.5))),

                SizedBox(height:10),
                ElevatedButton(style:ElevatedButton.styleFrom(shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(15)),
                    fixedSize: Size(180,42)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return db_showtable();
                      },));
                    }, child:Text("View Data",style:TextStyle(fontSize:15,letterSpacing:1.5))),

                SizedBox(height:20),
                ElevatedButton(style:ElevatedButton.styleFrom(primary:Colors.red.shade300,
                    shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(15)),
                    fixedSize: Size(140,42)),
                    onPressed: () {
                      setState(() {
                        tuser.text = ""; tpassword.text = "";
                      });
                    }, child:Text("Clear Texts",style:TextStyle(fontSize:15,letterSpacing:1.5))),
              ],
            )
          ],
        ),
      ),
    );
  }
}