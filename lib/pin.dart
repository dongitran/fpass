import 'package:flutter/material.dart';
import 'package:fpass/main.dart';
import 'package:fpass/utils/generator.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PinPage extends StatefulWidget {
  final String title;
  final bool isCreate;
  final String? token;
  final List<dynamic>? data;

  const PinPage(
      {Key? key,
      required this.title,
      required this.isCreate,
      this.token,
      this.data})
      : super(key: key);

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  bool loadingForSavePin = false;
  OtpFieldController otpFieldController = OtpFieldController();
  bool warningWrongPasscode = false;

  @override
  void initState() {
    super.initState();

    //otpFieldController.setFocus(0);
    Future.delayed(const Duration(milliseconds: 200), () {
      try {
        otpFieldController.setFocus(0);
      } catch (error) {
        print(error);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: !loadingForSavePin
          ? Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: OTPTextField(
                        controller: otpFieldController,
                        length: 6,
                        width: MediaQuery.of(context).size.width * 0.9,
                        fieldWidth: 46,
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.amberAccent,
                        ),
                        outlineBorderRadius: 10,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        onCompleted: (pin) async {
                          print("Completed: $pin");

                          if (widget.isCreate) {
                            Navigator.pop<String>(context, pin);
                          } else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            final pinHash = prefs.getString('pin');
                            final userName = prefs.getString('userName');
                            String userNameAndPin = '$userName---fpass---$pin';
                            String pinAndUserNameMd5Hash =
                                generateMd5(userNameAndPin);

                            if (pinHash == pinAndUserNameMd5Hash) {
                              print('successful');
                              List<Map<String, String>>? dataPass;
                              final data = widget.data;
                              if (data != null) {
                                final token = widget.token;
                                final secretToEncrypt =
                                    '$token---fpass---$userName';
                                final secretToEncryptHash =
                                    generateMd5(secretToEncrypt);
                                final key =
                                    encrypt.Key.fromUtf8(secretToEncryptHash);
                                final encrypter = encrypt.Encrypter(encrypt
                                    .AES(key, mode: encrypt.AESMode.cbc));

                                dataPass =
                                    data.map<Map<String, String>>((inputMap) {
                                  final Map<String, String> outputMap = {};

                                  inputMap.forEach((key, value) {
                                    outputMap[key] = value;
                                  });

                                  final ivBase64 = outputMap?['m'];
                                  outputMap.forEach((key, value) {
                                    if (key != 'm' && ivBase64 != null) {
                                      if (value == '') {
                                        outputMap[key] = '';
                                      } else {
                                        final encrypted =
                                            encrypt.Encrypted.fromBase64(value);
                                        final ivDecrypt =
                                            encrypt.IV.fromBase64(ivBase64);
                                        outputMap[key] = encrypter
                                            .decrypt(encrypted, iv: ivDecrypt);
                                      }
                                    }
                                  });

                                  return outputMap;
                                }).toList();
                              }

                              print('dataPass $dataPass');
                              setState(() {
                                loadingForSavePin = true;
                              });

                              Future.delayed(const Duration(milliseconds: 2000),
                                  () {
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(
                                      title: 'fpass',
                                      data: dataPass,
                                      token: widget.token ?? '',
                                    ),
                                  ),
                                );
                              });
                            } else {
                              print('failedddd');

                              setState(() {
                                warningWrongPasscode = true;
                              });

                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                otpFieldController.clear();
                                otpFieldController.setFocus(0);
                              });
                            }
                          }
                        },
                        onChanged: (value) => {
                          if (warningWrongPasscode == true)
                            {
                              setState(
                                () {
                                  warningWrongPasscode = false;
                                },
                              )
                            }
                        },
                        otpFieldStyle: OtpFieldStyle(
                          backgroundColor: Colors.white12,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          warningWrongPasscode ? 'Passcode invalid..' : '',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              color: Colors.black87,
              child: Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  size: 40,
                  color: Color.fromARGB(153, 238, 226, 1),
                ),
              ),
            ),
      resizeToAvoidBottomInset: false,
    );
  }
}
