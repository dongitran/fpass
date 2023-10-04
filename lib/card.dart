import 'package:flutter/material.dart';
import 'dart:async';

class CardsPage extends StatefulWidget {
  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  bool _obscurePassword = true;

  List<Map<String, String>> cardData = [
    {
      'color': '0xFF264653',
      'username': 'dongtran',
      'password': 'kosjrku78sjdksdfsfdswhbjskkosjrku78sjdksdfsfdswhbjsk',
      'appName': 'TPBank',
    },
    {
      'color': '0xFF2b2d42',
      'username': 'dongtran',
      'password': 'dsfdfhe444ddasfa',
      'appName': 'VPBank',
    },
    {
      'color': '0xFF403d39',
      'username': 'dongtran',
      'password': 's05kc93jcd',
      'appName': 'Standard Chartered',
    },
    {
      'color': '0xFF1c2541',
      'username': 'thiendong.iuh@gmail.com',
      'password': '09k6jfhe8jjks9958s',
      'appName': 'Gmail',
    },
    // Add more card data here
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var data in cardData)
              Column(
                children: [
                  _buildCreditCard(
                    color: Color(int.parse(data['color']!)),
                    username: data['username']!,
                    password: data['password']!,
                    appName: data['appName']!,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Card _buildCreditCard(
      {required Color color,
      required String appName,
      required String username,
      required String password}) {
    return Card(
      elevation: 4.0,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Container(
        height: 120,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
              child: Text(
                '$appName',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: 'CourrierPrime'),
              ),
            ),
            Container(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'UserName',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Password',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '$username',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '$password',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
