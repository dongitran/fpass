import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './models/token.dart';

import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = false;
    final fpassTokenValue = prefs.getString('fpassTokenValue');
    print(fpassTokenValue);
    if(fpassTokenValue != null){
      final fpassTokenModel = FirebaseFirestore.instance
      .collection('fpassToken')
      .withConverter<Token>(
        fromFirestore: (snapshots, _) => Token.fromJson(snapshots.data()!),
        toFirestore: (token, _) => token.toJson(),
      );

      final tokens = await fpassTokenModel
                          .where('token', isEqualTo: fpassTokenValue)
                          .limit(1)
                          .get();

      for (final token in tokens.docs) {
        final tokenValue = token.data();
        print('Token: ${tokenValue.token}');
      }
    }

    setState(() {
      isLoggedIn = loggedIn;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const MyHomePage(title: 'Flutter Demo Home Page') : LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print(isLoggedIn);
  }

  void _navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LoginPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: _navigateToLogin,
          child: Text('Go to Login'),
        ),
      ),
    );
  }
}


