import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const InsurancePredictApp());
}

class InsurancePredictApp extends StatelessWidget {
  const InsurancePredictApp({Key? key}) : super(key: key);

  // API base URL is chosen at runtime so the same build works on Android
  // emulator (uses 10.0.2.2) and on iOS/macOS (uses localhost / 127.0.0.1).
  // If you deploy the FastAPI service, replace with the public URL.
  static String get apiBaseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    } catch (_) {
      // Platform may throw on some targets; fallthrough to localhost
    }
    return 'http://127.0.0.1:8000';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance Predictor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: HomePage(apiBaseUrl: apiBaseUrl),
    );
  }
}
