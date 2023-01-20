import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  static Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      final googleKey = await account!.authentication;

      return googleKey.idToken;
    } catch (e) {
      return null;
    }
  }

  static Future singOut() async {
    await _googleSignIn.signOut();
  }
}
