import 'package:flutter/material.dart';

class CreditCardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildCreditCard(
                color: Color(0xFF264653),
                username: "dongtran",
                password:
                    "kosjrku78sjdksdfsfdswhbjskkosjrku78sjdksdfsfdswhbjsk",
                appName: "TPBank"),
            SizedBox(
              height: 15,
            ),
            _buildCreditCard(
                color: Color(0xFF2b2d42),
                username: "dongtran",
                password: "dsfdfhe444ddasfa",
                appName: "VPBank"),
            SizedBox(
              height: 15,
            ),
            _buildCreditCard(
                color: Color(0xFF403d39),
                username: "dongtran",
                password: "s05kc93jcd",
                appName: "Standard Chartered"),
            SizedBox(
              height: 15,
            ),
            _buildCreditCard(
                color: Color(0xFF1c2541),
                username: "thiendong.iuh@gmail.com",
                password: "09k6jfhe8jjks9958s",
                appName: "Gmail"),
          ],
        ),
      ),
    );
  }

  // Build the credit card widget
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

// Build Column containing the cardholder and expiration information
  Column _buildDetailsBlockName(
      {required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'UserName',
          style: TextStyle(
              color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Column _buildDetailsBlockValue(
      {required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$label',
          style: TextStyle(
              color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
        ),
        Text(
          '$value',
          style: TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.normal),
        )
      ],
    );
  }
}
