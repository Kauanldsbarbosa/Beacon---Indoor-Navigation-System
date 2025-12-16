import 'package:flutter_tts/flutter_tts.dart';

class AppVoice {
  static final FlutterTts _flutterTts = FlutterTts();

  static Future<void> setupTts() async {
    await _flutterTts.setLanguage("pt-BR");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  static Future<void> speak(String text) async {
    await _flutterTts.stop();
    if (text.isEmpty) return;
    await _flutterTts.speak(text);
  }
  static Future<void> stop() async {
    await _flutterTts.stop();
  }
}