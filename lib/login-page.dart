import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fpass/pin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  bool loadingForSavePin = false;

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
        backgroundColor: Colors.black87, // Đặt màu nền trong suốt
        elevation: 0, // Loại bỏ đường viền
      ),
      body: !loadingForSavePin
          ? Container(
              decoration: const BoxDecoration(
                color: Colors.black87,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'fpass',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.bold),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white38,
                                    width: 3.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white10,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.bold),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white38,
                                    width: 3.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white10,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 32.0),
                            ElevatedButton(
                              style: ButtonStyle(),
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

                                      print('asdf');
                                      // ignore: use_build_context_synchronously
                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => MyHomePage(
                                      //         title: 'fpass', data: null, token: md5Hash),
                                      //   ),
                                      // );
                                      final pin =
                                          await Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return PinPage(
                                              title: 'Create your passcode',
                                            );
                                          },
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            const begin = Offset(1.0, 0.0);
                                            const end = Offset.zero;
                                            const curve = Curves.easeInOut;
                                            var tween = Tween(
                                                    begin: begin, end: end)
                                                .chain(
                                                    CurveTween(curve: curve));
                                            var offsetAnimation =
                                                animation.drive(tween);
                                            return SlideTransition(
                                                position: offsetAnimation,
                                                child: child);
                                          },
                                        ),
                                      );

                                      print('paosdflakjdf');
                                      print(pin);

                                      setState(() {
                                        loadingForSavePin = true;
                                      });

                                      String input =
                                          '$username---fpass---$password';
                                      String md5Hash = generateMd5(input);

                                      Map<String, dynamic> dataToInsert = {
                                        'init': 'true',
                                        'pin': generateMd5(pin),
                                      };
                                      await FirebaseFirestore.instance
                                          .collection('fpassToken')
                                          .doc(md5Hash)
                                          .set(dataToInsert);
                                      
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          'fpassTokenValue', md5Hash);
                                      prefs.setString(
                                          'pin', md5Hash);
                                    }
                                  : null,
                              child: const Text('Login'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Container(
              color: Colors.black87,
              child: Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  size: 40,
                  color: Color.fromARGB(153, 238, 226, 1),
                ),
              ),
            ),
      resizeToAvoidBottomInset: false,
    );
  }
}
