import 'package:flutter/material.dart';

@immutable
class Token {
  Token({
    required this.token,
  });

  Token.fromJson(Map<String, Object?> json)
      : this(
          token: json['token']! as String,
        );

  final String token;

  Map<String, Object?> toJson() {
    return {
      'token': token,
    };
  }
}
