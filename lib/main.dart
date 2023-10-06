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
        'secondPage': (context) => SecondPage(),
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
                        MaterialPageRoute(builder: (context) => SecondPage()));

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

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final TextEditingController _applicationController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _canAdd = false;

  void _checkCanAdd() {
    setState(() {
      _canAdd = _applicationController.text.isNotEmpty &&
          _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _applicationController.addListener(_checkCanAdd);
    _usernameController.addListener(_checkCanAdd);
    _passwordController.addListener(_checkCanAdd);
  }

  @override
  void dispose() {
    _applicationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _addToFirestore() async {
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      // Lấy giá trị từ các trường nhập liệu
      String application = _applicationController.text;
      String username = _usernameController.text;
      String password = _passwordController.text;

      // Kiểm tra xem các trường có dữ liệu hay không
      if (application.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty) {
        var documentRef = FirebaseFirestore.instance.collection('fpassToken').doc(
            'd7440e379bf237113a2f30c5bbef402a1a5ce1941345442c6cb1ec0eb1a00117');
        final dataUpdate = {
          'n': application,
          'u': username,
          'p': password,
        };
        var resultUpdate = await documentRef.update({
          "pass": FieldValue.arrayUnion([dataUpdate])
        });
        //await FirebaseFirestore.instance.collection('fpassToken').add({
        //  'application': application,
        //  'username': username,
        //  'password': password,
        //});

        // Sau khi thêm dữ liệu thành công, làm sạch các trường nhập liệu
        _applicationController.clear();
        _usernameController.clear();
        _passwordController.clear();

        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dữ liệu đã được thêm vào Firestore.'),
          ),
        );

        Map<String, String> result = dataUpdate;

        Navigator.pop<Map<String, String>>(context, result);
      } else {
        // Hiển thị thông báo nếu một trong các trường nhập liệu còn trống
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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
        title: Text(
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
                              color: Colors.white,
                            ),
                          ),
                          TextFormField(
                            controller: _applicationController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Username/Email',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: _canAdd ? _addToFirestore : null,
                            child: Text(
                              'Add...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurpleAccent,
                              onPrimary: Colors.white,
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
