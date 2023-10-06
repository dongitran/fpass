// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './models/token.dart';
import 'login_page.dart';
import 'card.dart';
import 'add-password.dart';

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
      title: 'fpass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
        useMaterial3: true,
      ),
      routes: {
        'secondPage': (context) => AddPasswordPage(),
      },
      home: FutureBuilder<DocumentSnapshot?>(
        future: getDataFirebase(),
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
            var isLoggedIn = false;
            var data;
            if (snapshot.hasData && snapshot.data!.exists) {
              isLoggedIn = true;

              data = snapshot.data?.data() as Map<String, dynamic>?;
            }
            var dataPass = null;
            if (data != null && data["pass"] != null) {
              List<Map<String, String>> outputList = [];
              data["pass"].forEach((inputMap) {
                Map<String, String> outputMap = {};

                inputMap.forEach((key, value) {
                  outputMap[key] =
                      value.toString(); // Sử dụng toString() để chuyển đổi
                });

                outputList.add(outputMap);
              });

              dataPass = outputList;
            }

            return isLoggedIn
                ? MyHomePage(title: 'fpass', data: dataPass)
                : const LoginPage();
          }
        },
      ),
    );
  }

  Future<DocumentSnapshot?> getDataFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final fpassTokenValue = prefs.getString('fpassTokenValue');
    if (fpassTokenValue != null) {
      try {
        final result = await FirebaseFirestore.instance
            .collection('fpassToken')
            .doc(
                'd7440e379bf237113a2f30c5bbef402a1a5ce1941345442c6cb1ec0eb1a00117')
            .get();

        //final result1 =
        //    await FirebaseFirestore.instance.collection('fpassToken').get();
        //result1.docs.forEach((doc) {
        //  print(doc
        //      .data()); // In dữ liệu của từng tài liệu trong bộ sưu tập 'fpassToken'
        //});
        //print(result1.docs);

        return result;
      } catch (error) {
        print(error);
      }

      return null;
    }

    return null;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.data});

  final String title;
  final List<Map<String, String>>? data;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, String>>? _data;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _data = widget.data!;
    } else {
      _data = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CardsPage(data: _data),
              Container(
                margin: const EdgeInsets.only(top: 1.0),
                alignment: Alignment.center,
                child: FloatingActionButton(
                  elevation: 6.0,
                  onPressed: () async {
                    final result = await Navigator.push<Map<String, String>>(
                        context,
                        MaterialPageRoute(builder: (context) => AddPasswordPage()));

                    if (result != null && result is Map<String, String>) {
                      // Cập nhật dữ liệu trong _data bằng setState
                      setState(() {
                        if (_data != null) {
                          _data!.add(result);
                        } else {
                          _data = [result];
                        }
                      });
                    }
                  },
                  backgroundColor: Colors.white,
                  mini: false,
                  child: Icon(Icons.add),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
