import 'package:flutter/material.dart';
import 'dart:async';

class CardsPage extends StatefulWidget {
  final List<Map<String, String>>? data;

  const CardsPage({super.key, this.data});

  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  var cardDataColors = [
    '0xFF264653',
    '0xFF2b2d42',
    '0xFF403d39',
    '0xFF1c2541',
    '0xFF7f5539',
    '0xFF4a5759',
    '0xFF240046',
    '0xFF003049',
  ];

  // List to track the visibility of passwords for each card
  List<bool> _passwordVisible = List.generate(4, (index) => false);
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var i = 0; i < widget.data!.length; i++)
              Column(
                children: [
                  Stack(
                    children: [
                      _buildCreditCard(
                        color: getColorOrDefault(i),
                        username: widget.data![i]['u']!,
                        password: widget.data![i]['p']!,
                        appName: widget.data![i]['n']!,
                        isPasswordVisible: _passwordVisible[i],
                      ),
                      Positioned(
                        top: 8.0, // Điều chỉnh vị trí theo y
                        right: 8.0, // Điều chỉnh vị trí theo x
                        child: IconButton(
                          icon: Icon(
                            _passwordVisible[i]
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            // Check and reset timer
                            if (_timer != null && _timer!.isActive) {
                              _timer!.cancel();
                            }

                            _passwordVisible.fillRange(0, i, false);
                            _passwordVisible.fillRange(
                                i + 1, _passwordVisible.length, false);
                            _passwordVisible[i] = !_passwordVisible[i];
                            setState(() {
                              _passwordVisible;
                            });

                            // Set timer for hide password
                            if (_passwordVisible[i]) {
                              _timer = Timer(const Duration(seconds: 3), () {
                                setState(() {
                                  _passwordVisible[i] = false;
                                });
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Card _buildCreditCard({
    required Color color,
    required String appName,
    required String username,
    required String password,
    required bool isPasswordVisible,
  }) {
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
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: 'CourrierPrime'),
              ),
            ),
            Container(
              child: Column(children: [
                const Row(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        username,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        isPasswordVisible ? '$password' : '******',
                        style: const TextStyle(
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

  Color getColorOrDefault(int index) {
    if (cardDataColors == null || index >= cardDataColors.length) {
      return Colors.deepPurple; // Thay thế bằng màu mặc định của bạn
    } else {
      final colorString = cardDataColors[index];
      if (colorString == null || colorString.isEmpty) {
        return Colors.deepPurple; // Thay thế bằng màu mặc định của bạn
      } else {
        return Color(int.parse(colorString));
      }
    }
  }
}
