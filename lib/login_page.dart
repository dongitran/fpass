import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'main.dart';
import 'utils/generator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
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
        title: Text('Login'),
        backgroundColor: Colors.transparent, // Đặt màu nền trong suốt
        elevation: 0, // Loại bỏ đường viền
      ),
      body: Container(
        decoration: BoxDecoration(
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
                SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 32.0),
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
                            // data là một Map chứa dữ liệu từ tài liệu
                            print('Data: $data');
                          } else {
                            print('Document does not exist');
                          }

                          String input = '$username---fpass---$password';
                          print(input);
                          String md5Hash = generateSha256(input);
                          print('MD5 Hash: $md5Hash');

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

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                  title: 'Flutter Demo Home Page', data: null),
                            ),
                          );
                        }
                      : null,
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
