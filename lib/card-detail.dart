import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String appName;
  final String username;
  final String password;
  final String secretKey2FA;

  DetailPage({
    required this.appName,
    required this.username,
    required this.password,
    required this.secretKey2FA,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController _appNameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _secretKey2FAController;

  @override
  void initState() {
    super.initState();
    _appNameController = TextEditingController(text: widget.appName);
    _usernameController = TextEditingController(text: widget.username);
    _passwordController = TextEditingController(text: widget.password);
    _secretKey2FAController = TextEditingController(text: widget.secretKey2FA);
  }

  @override
  Widget build(BuildContext context) {
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
                          onPressed: () {
                            // Lưu thông tin đã chỉnh sửa và quay lại màn hình trước
                            final editedAppName = _appNameController.text;
                            final editedUsername = _usernameController.text;
                            final editedPassword = _passwordController.text;
                            final editedSecretKey2FA =
                                _secretKey2FAController.text;

                            // Điều gì đó ở đây để lưu thông tin (ví dụ: cập nhật vào cơ sở dữ liệu)
                            // ...

                            // Quay lại màn hình trước
                            Navigator.pop(context);
                          },
                          child: const Text('Update'),
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
    // Giải phóng bộ nhớ khi không cần thiết
    _appNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _secretKey2FAController.dispose();
    super.dispose();
  }
}
