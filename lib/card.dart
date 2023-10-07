import 'package:flutter/material.dart';
import 'dart:async';
import 'card-detail.dart';

class CardsPage extends StatefulWidget {
  final List<Map<String, String>>? data;
  final String token;

  const CardsPage({Key? key, this.data, required this.token}) : super(key: key);

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
  final List<bool> _passwordVisible = List.generate(32, (index) => false);
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>>? dataRender = widget.data;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (dataRender != null)
              for (var i = 0; i < dataRender!.length; i++)
                Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // Khi thẻ được nhấn, chuyển đến trang chi tiết và truyền dữ liệu
                            final result = await Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return DetailPage(
                                    secretKey2FA: '',
                                    token: widget.token,
                                    data: dataRender,
                                    index: i,
                                  );
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);
                                  return SlideTransition(
                                      position: offsetAnimation, child: child);
                                },
                              ),
                            );

                            // Cập nhật widget.data với giá trị mới
                            if (result != null) {
                              setState(() {
                                dataRender = result;
                              });
                            }
                          },
                          child: _buildCreditCard(
                            color: getColorOrDefault(i),
                            username: dataRender![i]['u']!,
                            password: dataRender![i]['p']!,
                            appName: dataRender![i]['n']!,
                            isPasswordVisible: _passwordVisible[i],
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          right: 8.0,
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
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                appName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: 'CourrierPrime'),
              ),
            ),
            // ignore: avoid_unnecessary_containers
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
                        isPasswordVisible ? password : '******',
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
    if (index >= cardDataColors.length) {
      return Colors.deepPurple; // Thay thế bằng màu mặc định của bạn
    } else {
      final colorString = cardDataColors[index];
      if (colorString.isEmpty) {
        return Colors.deepPurple; // Thay thế bằng màu mặc định của bạn
      } else {
        return Color(int.parse(colorString));
      }
    }
  }
}
