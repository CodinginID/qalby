// Firebase project config — used by native GoogleService-Info.plist / google-services.json.
// Kept as reference; not imported at runtime (auth uses pure OAuth).
// ignore_for_file: type=lint

class FirebaseConfig {
  static const android = (
    apiKey: 'AIzaSyD-b2hxXrNGDL2Iy5vn2vIaMpYD07M3d7Q',
    appId: '1:182949033056:android:112743592f54c9c1d4ff05',
    messagingSenderId: '182949033056',
    projectId: 'qalby-b4b71',
    storageBucket: 'qalby-b4b71.firebasestorage.app',
  );

  static const ios = (
    apiKey: 'AIzaSyBgPRJ0bzZCpaxR3hPx7K0ppbC2yYEN7vY',
    appId: '1:182949033056:ios:4a9ad983ffda35c0d4ff05',
    messagingSenderId: '182949033056',
    projectId: 'qalby-b4b71',
    storageBucket: 'qalby-b4b71.firebasestorage.app',
    iosBundleId: 'com.qalby.qalby',
  );
}
