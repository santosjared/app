// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:twitter_login/twitter_login.dart';

// class TwitterAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<String?> signInWithTwitter() async {
//     final twitterLogin = TwitterLogin(
//       apiKey: 'TU_API_KEY',
//       apiSecretKey: 'TU_SECRET_KEY',
//       redirectURI: 'twitter://callback',
//     );

//     final authResult = await twitterLogin.login();
//     if (authResult.status == TwitterLoginStatus.loggedIn) {
//       final AuthCredential credential = TwitterAuthProvider.credential(
//         accessToken: authResult.authToken!,
//         secret: authResult.authTokenSecret!,
//       );

//       final UserCredential userCredential = await _auth.signInWithCredential(credential);
//       return userCredential.user?.getIdToken();
//     }
//     return null;
//   }
// }
