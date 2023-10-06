import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'main.dart';
import 'utils/generator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool areFieldsValid = false;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(validateFields);
    passwordController.addListener(validateFields);
  }

  void validateFields() {
    final username = usernameController.text;
    final password = passwordController.text;
    setState(() {
      areFieldsValid = username.isNotEmpty && password.isNotEmpty;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.transparent, // Đặt màu nền trong suốt
        elevation: 0, // Loại bỏ đường viền
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: areFieldsValid
                      ? () async {
                          String username = usernameController.text;
                          String password = passwordController.text;

                          final DocumentSnapshot documentSnapshot =
                              await FirebaseFirestore.instance
                                  .collection('fpassToken')
                                  .doc('document_id')
                                  .get();
                          if (documentSnapshot.exists) {
                            // Lấy dữ liệu từ tài liệu
                            final data = documentSnapshot.data();
                          } else {
                            if (kDebugMode) {
                              print('Document does not exist');
                            }
                          }

                          String input = '$username---fpass---$password';
                          String md5Hash = generateMd5(input);

                          Map<String, dynamic> dataToInsert = {
                            'init': 'true',
                          };
                          await FirebaseFirestore.instance
                              .collection('fpassToken')
                              .doc(md5Hash)
                              .set(dataToInsert);

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('fpassTokenValue', md5Hash);

                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                  title: 'fpass', data: null, token: md5Hash),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
