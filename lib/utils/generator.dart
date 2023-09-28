import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateMd5(String input) {
  var bytes = utf8.encode(input); // Chuyển đổi chuỗi thành mảng byte UTF-8
  var md5Hash = md5.convert(bytes); // Tạo mã MD5 từ mảng byte
  return md5Hash.toString(); // Chuyển đổi mã MD5 thành chuỗi hex
}


// Hàm để tạo mã SHA-256 từ một chuỗi
String generateSha256(String input) {
  var bytes = utf8.encode(input); // Chuyển đổi chuỗi thành mảng byte UTF-8
  var sha256Hash = sha256.convert(bytes); // Tạo mã SHA-256 từ mảng byte
  return sha256Hash.toString(); // Chuyển đổi mã SHA-256 thành chuỗi hex
}