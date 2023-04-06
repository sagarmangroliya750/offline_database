
// ignore_for_file: camel_case_types, non_constant_identifier_names, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:offline_database/db_query.dart';

class db_showtable extends StatefulWidget {
  const db_showtable({Key? key}) : super(key: key);

  @override
  State<db_showtable> createState() => _db_showtableState();
}

class _db_showtableState extends State<db_showtable> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
  }

  String qry = "";
  List<Map> list = [];
  List user = [];
  List password = [];
  String delete = "";

  get_data() async {
    qry = "SELECT * FROM datatable";
    list = await db_query.database!.rawQuery(qry);
    for(int i = 0 ; i<list.length; i++)
    {
      user.add(list[i]['user']);
      password.add(list[i]['password']);
    }
  }
  delete_data(index)
  async {
    delete = "DELETE FROM datatable WHERE id = ${list[index]['id']}";
    int status = await db_query.database!.rawDelete(delete);
    return status;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All Data"),
        ),
        body: FutureBuilder(future: get_data(),
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if(snapshot.connectionState==ConnectionState.done)
              {
                return SlidableAutoCloseBehavior(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin:EdgeInsets.all(10),elevation:5,
                        child: Slidable(
                          endActionPane: ActionPane(extentRatio: 0.3,motion: ScrollMotion(),
                              children: [
                                SlidableAction(onPressed: (context) async {
                                  await delete_data(index);
                                  setState(() {});
                                },icon: Icons.delete,
                                  backgroundColor: Colors.red,
                                ),
                                SlidableAction(onPressed: (context) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return db_query(list[index]['user'], list[index]['password'], list[index]['id']);
                                  },));
                                  print(list[index]['user']);
                                  builder: (context) => db_query(
                                    list[index]['user'],
                                    list[index]['password'],
                                    list[index]['id'],
                                  );
                                  setState(() {
                                  });
                                },icon: Icons.edit,
                                  backgroundColor: Colors.green,
                                )
                              ]),
                          child: ListTile(
                            title: Text("${list[index]['user']}"),
                            subtitle: Text("${list[index]['password']}"),
                          ),
                        ),
                      );
                    },),
                );
              }else
              {
                return Center(child: CircularProgressIndicator(),);
              }
            }
        )
    );
  }
}

