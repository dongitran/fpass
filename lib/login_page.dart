import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Ẩn nút "Back"
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Xử lý đăng nhập ở đây
                String username = _usernameController.text;
                String password = _passwordController.text;

                // Thực hiện kiểm tra tên người dùng và mật khẩu ở đây
                // Để minh họa, chúng ta sẽ sử dụng một tên người dùng và mật khẩu cố định

                if (username == 'your_username' && password == 'your_password') {
                  // Nếu đăng nhập thành công, lưu trạng thái đăng nhập
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', true);

                  // Sau đó điều hướng đến trang chính
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomePage(), // Thay thế trang hiện tại bằng trang chính
                  ));
                } else {
                  // Xử lý khi đăng nhập không thành công (thông báo lỗi, v.v.)
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Đăng nhập không thành công. Vui lòng thử lại!'),
                  ));
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Chào mừng bạn đã đăng nhập!'),
      ),
    );
  }
}
