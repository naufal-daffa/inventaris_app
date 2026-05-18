import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:5000/";
    } else {
      return "http://15.15.5.243:5000";
    }
  }
}
