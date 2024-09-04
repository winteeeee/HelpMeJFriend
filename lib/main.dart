import 'package:flutter/material.dart';
import 'package:help_me_j_friend/route/main_route.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MaterialApp(home: MainRoute()));
}