import 'package:flutter/material.dart';
import 'package:login/bt_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //  Chạy ứng dụng
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: BtHomePage());
  }
}
