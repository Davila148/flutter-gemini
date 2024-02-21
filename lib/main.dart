import 'package:flutter/material.dart';
import 'package:flutter_gemini_app/generate_content_provider.dart';
import 'package:flutter_gemini_app/home_page.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GenerateContentProvider(
      model: configurarModelo(),
      modelProvision: configurarModeloVision(),
      child: MaterialApp(
        title: 'Flutter Gemini Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

GenerativeModel configurarModelo() {
  const apiKey = 'AIzaSyBfnoICQgSAMLRe50YZfv4dyAB0udCwhGE';
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  return model;
}

GenerativeModel configurarModeloVision() {
  const apiKey = 'AIzaSyBfnoICQgSAMLRe50YZfv4dyAB0udCwhGE';
  final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
  return model;
}
