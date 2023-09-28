import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './models/token.dart';

import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Future.delayed(const Duration(seconds: 2));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Xử lý trường hợp đang kiểm tra trạng thái đăng nhập
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            // Xử lý trường hợp có lỗi
            return Text('Error: ${snapshot.error}');
          } else {
            // Xử lý trường hợp hoàn thành kiểm tra trạng thái đăng nhập
            final isLoggedIn = snapshot.data ?? false;

            return isLoggedIn
                ? const MyHomePage(title: 'Flutter Demo Home Page')
                : const LoginPage();
          }
        },
      ),
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final fpassTokenValue = prefs.getString('fpassTokenValue');
    print('fpassTokenValue $fpassTokenValue');
    if (fpassTokenValue != null) {
      final result = await FirebaseFirestore.instance
          .collection('fpassToken')
          .doc(fpassTokenValue)
          .get();

      if (result.exists) {
        final data = result.data();
        print('data: ${data}');
        return true; // Đã đăng nhập thành công
      }
    }

    return false; // Chưa đăng nhập
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
