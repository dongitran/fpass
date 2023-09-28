// ignore_for_file: prefer_const_constructors

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
      routes: {
        'secondPage': (context) => SecondPage(),
      },
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
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
        return true;
      }
    }

    return false;
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
      body: Container(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: Center(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
              context, 'secondPage'); // Điều hướng đến trang mới
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adding password'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 2.0, 16.0, 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            'Application',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white), // Màu văn bản trắng
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              border:
                                  OutlineInputBorder(), // Viền cho TextField
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Username/Email',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Password',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              // Xử lý khi nút hoàn thành được nhấn
                            },
                            child: Text('Add...'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.amber, // Màu nền cho nút
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
