// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({
    super.key,
    required this.token,
  });

  final String token;

  @override
  _AddPasswordPageState createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  final TextEditingController _applicationController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secretKey2FAController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _applicationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _secretKey2FAController.dispose();
    super.dispose();
  }

  Future<void> _addToFirestore() async {
    try {
      // Lấy giá trị từ các trường nhập liệu
      String application = _applicationController.text;
      String username = _usernameController.text;
      String password = _passwordController.text;
      String secretKey2FA = _secretKey2FAController.text;
      print('secretKey2FA');
      print(secretKey2FA == '');

      // Kiểm tra xem các trường có dữ liệu hay không
      if (application.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty) {
        var documentRef = FirebaseFirestore.instance
            .collection('fpassToken')
            .doc(widget.token);

        final key = encrypt.Key.fromUtf8(widget.token);
        final iv = encrypt.IV.fromLength(16);
        final encrypter =
            encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

        final dataUpdateEncrypt = {
          'n': encrypter.encrypt(application, iv: iv).base64,
          'u': encrypter.encrypt(username, iv: iv).base64,
          'p': encrypter.encrypt(password, iv: iv).base64,
          's': secretKey2FA == ''
              ? ''
              : encrypter.encrypt(secretKey2FA, iv: iv).base64,
          'm': iv.base64,
        };
        await documentRef.update({
          "pass": FieldValue.arrayUnion([dataUpdateEncrypt])
        });

        // Sau khi thêm dữ liệu thành công, làm sạch các trường nhập liệu
        _applicationController.clear();
        _usernameController.clear();
        _passwordController.clear();
        _secretKey2FAController.clear();

        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dữ liệu đã được thêm thành công.'),
          ),
        );

        final dataResponse = {
          'n': application,
          'u': username,
          'p': password,
          's': secretKey2FA,
          'm': iv.base64,
        };
        Map<String, String> result = dataResponse;

        Navigator.pop<Map<String, String>>(context, result);
      } else {
        // Hiển thị thông báo nếu một trong các trường nhập liệu còn trống
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng điền đầy đủ thông tin.'),
          ),
        );
      }
    } catch (error) {
      // Xử lý lỗi nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adding Password',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Expanded(
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 2.0, 16.0, 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            controller: _applicationController,
                            decoration: const InputDecoration(
                              labelText: 'App',
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
                            controller: _usernameController,
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
                            controller: _passwordController,
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
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _secretKey2FAController,
                            decoration: const InputDecoration(
                              labelText: 'Secret key 2FA',
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
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: _addToFirestore,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.deepPurpleAccent,
                            ),
                            child: const Text(
                              'Add...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
