import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class DetailPage extends StatefulWidget {
  final String secretKey2FA;
  final String token;
  final List<Map<String, String>>? data;
  final int index;

  DetailPage({
    required this.secretKey2FA,
    required this.token,
    required this.index,
    required this.data,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController _appNameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _secretKey2FAController;

  bool isDataChanged = false;

  @override
  void initState() {
    super.initState();
    _appNameController =
        TextEditingController(text: widget.data![widget.index]['n']);
    _usernameController =
        TextEditingController(text: widget.data![widget.index]['u']);
    _passwordController =
        TextEditingController(text: widget.data![widget.index]['p']);
    _secretKey2FAController =
        TextEditingController(text: widget.data![widget.index]['s']);

    // Theo dõi sự thay đổi trong các trường dữ liệu và cập nhật biến isDataChanged
    _appNameController.addListener(handleDataChange);
    _usernameController.addListener(handleDataChange);
    _passwordController.addListener(handleDataChange);
    _secretKey2FAController.addListener(handleDataChange);
  }

  void handleDataChange() {
    // Kiểm tra xem bất kỳ trường dữ liệu nào có thay đổi hay không
    if (_appNameController.text != widget.data![widget.index]['n'] ||
        _usernameController.text != widget.data![widget.index]['u'] ||
        _passwordController.text != widget.data![widget.index]['p'] ||
        _secretKey2FAController.text != widget.data![widget.index]['s']) {
      setState(() {
        isDataChanged = true; // Đánh dấu là có sự thay đổi
      });
    } else {
      setState(() {
        isDataChanged = false; // Đánh dấu là không có sự thay đổi
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentContext = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          'Detail',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.black87, // Đặt màu nền cho Container
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                // Sử dụng SingleChildScrollView để làm cho nội dung cuộn khi bàn phím hiện lên
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _appNameController,
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
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            // Kiểm tra xem có sự thay đổi trong dữ liệu hay không
                            if (isDataChanged) {
                              final editedAppName = _appNameController.text;
                              final editedUsername = _usernameController.text;
                              final editedPassword = _passwordController.text;
                              final editedSecretKey2FA =
                                  _secretKey2FAController.text;

                              var dataUpdate =
                                  List<Map<String, String>>.from(widget.data!);
                              final key = encrypt.Key.fromUtf8(widget.token);
                              final encrypter = encrypt.Encrypter(
                                  encrypt.AES(key, mode: encrypt.AESMode.cbc));

                              dataUpdate?[widget.index]['n'] = editedAppName;
                              dataUpdate?[widget.index]['u'] = editedUsername;
                              dataUpdate?[widget.index]['p'] = editedPassword;
                              dataUpdate?[widget.index]['s'] =
                                  editedSecretKey2FA;

                              var newData = [];
                              for (int i = 0; i < dataUpdate!.length; i++) {
                                var iv =
                                    encrypt.IV.fromBase64(dataUpdate[i]['m']!);
                                final n = encrypter
                                    .encrypt(dataUpdate[i]['n']!, iv: iv)
                                    .base64;
                                final u = encrypter
                                    .encrypt(dataUpdate[i]['u']!, iv: iv)
                                    .base64;
                                final p = encrypter
                                    .encrypt(dataUpdate[i]['p']!, iv: iv)
                                    .base64;
                                final s = encrypter
                                    .encrypt(dataUpdate[i]['s']!, iv: iv)
                                    .base64;
                                var encryptedData = {
                                  'n': n,
                                  'u': u,
                                  'p': p,
                                  's': s,
                                  'm': dataUpdate[i]['m'],
                                };

                                // Thêm đối tượng Map mới vào danh sách newData
                                newData.add(encryptedData);
                              }

                              var documentRef = FirebaseFirestore.instance
                                  .collection('fpassToken')
                                  .doc(widget.token);
                              await documentRef.update({"pass": newData});

                              // ignore: use_build_context_synchronously
                              Navigator.pop<List<Map<String, String>>?>(
                                  currentContext, dataUpdate);

                              return;
                            }

                            // Quay lại màn hình trước
                            // ignore: use_build_context_synchronously
                            Navigator.pop<List<Map<String, String>>?>(
                                currentContext, widget.data);
                          },
                          child: const Text('Update'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Xóa dữ liệu khỏi Firestore và response về một danh sách trống
                            var documentRef = FirebaseFirestore.instance
                                .collection('fpassToken')
                                .doc(widget.token);

                            var dataUpdate =
                                List<Map<String, String>>.from(widget.data!);
                            final key = encrypt.Key.fromUtf8(widget.token);
                            final encrypter = encrypt.Encrypter(
                                encrypt.AES(key, mode: encrypt.AESMode.cbc));

                            var newData = List<Map<String, String>>.from([]);
                            for (int i = 0; i < dataUpdate!.length; i++) {
                              if (i != widget.index) {
                                var dataNoEncrypt = {
                                  'n': dataUpdate[i]['n'] ?? '',
                                  'u': dataUpdate[i]['u'] ?? '',
                                  'p': dataUpdate[i]['p'] ?? '',
                                  's': dataUpdate[i]['s'] ?? '',
                                  'm': dataUpdate[i]['m'] ?? '',
                                };
                                newData.add(dataNoEncrypt);
                              }
                            }

                            var newDataEncrypt = [];
                            for (int i = 0; i < newData!.length; i++) {
                              var iv = encrypt.IV.fromBase64(newData[i]['m']!);
                              final n = encrypter
                                  .encrypt(newData[i]['n']!, iv: iv)
                                  .base64;
                              final u = encrypter
                                  .encrypt(newData[i]['u']!, iv: iv)
                                  .base64;
                              final p = encrypter
                                  .encrypt(newData[i]['p']!, iv: iv)
                                  .base64;
                              final s = encrypter
                                  .encrypt(newData[i]['s']!, iv: iv)
                                  .base64;

                              // Thêm đối tượng Map mới vào danh sách newData
                              newDataEncrypt.add({
                                'n': n,
                                'u': u,
                                'p': p,
                                's': s,
                                'm': newData[i]['m'] ?? '',
                              });
                            }

                            print(newData);

                            await documentRef.update({"pass": newDataEncrypt});

                            // ignore: use_build_context_synchronously
                            Navigator.pop<List<Map<String, String>>?>(
                                currentContext, newData);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Màu nút Delete là đỏ
                          ),
                          child: const Text('Delete'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi không cần thiết và loại bỏ các lắng nghe sự thay đổi
    _appNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _secretKey2FAController.dispose();
    super.dispose();
  }
}
