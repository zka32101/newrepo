import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'dummy_web_api_key',
    appId: 'dummy_web_app_id',
    messagingSenderId: 'dummy_web_messaging_sender_id',
    projectId: 'dummy_web_project_id',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'dummy_android_api_key',
    appId: 'dummy_android_app_id',
    messagingSenderId: 'dummy_android_messaging_sender_id',
    projectId: 'dummy_android_project_id',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'dummy_ios_api_key',
    appId: 'dummy_ios_app_id',
    messagingSenderId: 'dummy_ios_messaging_sender_id',
    projectId: 'dummy_ios_project_id',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'dummy_macos_api_key',
    appId: 'dummy_macos_app_id',
    messagingSenderId: 'dummy_macos_messaging_sender_id',
    projectId: 'dummy_macos_project_id',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'dummy_windows_api_key',
    appId: 'dummy_windows_app_id',
    messagingSenderId: 'dummy_windows_messaging_sender_id',
    projectId: 'dummy_windows_project_id',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'dummy_linux_api_key',
    appId: 'dummy_linux_app_id',
    messagingSenderId: 'dummy_linux_messaging_sender_id',
    projectId: 'dummy_linux_project_id',
  );
}
