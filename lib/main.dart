import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'utils/firebase-options.dart';
import 'login-page.dart';
import 'card.dart';
import 'add-password.dart';
import 'dart:async';
import 'pin.dart';

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
      home: FutureBuilder<Map<String, dynamic>?>(
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
            final isLoggedIn =
                snapshot.hasData && snapshot.data?['token'] != null;
            final data = isLoggedIn && snapshot.data != null
                ? snapshot.data!['result'].data() as Map<String, dynamic>?
                : null;
            List<Map<String, String>>? dataPass;

            return isLoggedIn
                ? PinPage(
                    title: 'Enter your passcode',
                    isCreate: false,
                    token: snapshot.data?['token'],
                    data: data?['pass'],
                  )
                : const LoginPage();
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> getDataFirebase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final fpassTokenValue = prefs.getString('fpassTokenValue');

    if (fpassTokenValue != null) {
      try {
        final result = await FirebaseFirestore.instance
            .collection('fpassToken')
            .doc(fpassTokenValue)
            .get();

        final dataMap = {
          'token': fpassTokenValue,
          'result': result,
        };

        return dataMap;
      } catch (error) {
        if (kDebugMode) {
          print(error);
        }
        return null;
      }
    }

    return null;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.token,
      required this.data});

  final String title;
  final String token;
  final List<Map<String, String>>? data;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, String>>? _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          widget.title,
          style: const TextStyle(
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
              CardsPage(data: _data, token: widget.token),
              Container(
                margin: const EdgeInsets.only(top: 1.0),
                alignment: Alignment.center,
                child: FloatingActionButton(
                  elevation: 6.0,
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return AddPasswordPage(token: widget.token);
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                              position: offsetAnimation, child: child);
                        },
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        _data = _data != null ? [..._data!, result] : [result];
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
