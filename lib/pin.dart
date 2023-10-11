import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class PinPage extends StatefulWidget {
  const PinPage({Key? key}) : super(key: key);

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool areFieldsValid = false;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(validateFields);
    passwordController.addListener(validateFields);
  }

  void validateFields() {
    final username = usernameController.text;
    final password = passwordController.text;
    setState(() {
      areFieldsValid = username.isNotEmpty && password.isNotEmpty;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PIN",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: const Text(
                    "Enter your passcode",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: OTPTextField(
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
                  onCompleted: (pin) {
                    print("Completed: $pin");
                  },
                  otpFieldStyle: OtpFieldStyle
                  (
                    backgroundColor: Colors.white12,
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
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
