import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    if (kIsWeb) {
      // Configuração para Web
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDdC-N-Gek0-zrTVNdj7l-x8rzLvgppf90",
          authDomain: "igreja-pv-mobile.firebaseapp.com",
          projectId: "igreja-pv-mobile",
          storageBucket: "igreja-pv-mobile.firebasestorage.app",
          messagingSenderId: "243931898220",
          appId: "1:243931898220:web:38bd6794b334ae12ce1349",
        ),
      );
    } else {
      // Configuração para Android/iOS
      // O arquivo google-services.json (Android) e GoogleService-Info.plist (iOS)
      // devem ser adicionados aos respectivos diretórios
      await Firebase.initializeApp();
    }
  }
}
