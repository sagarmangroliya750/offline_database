import 'package:flutter/material.dart';

import 'db_query.dart';

void main() {
  runApp(MaterialApp(
      home: db_query("", "", 0), debugShowCheckedModeBanner: false));
}
