import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'google_services.dart' show SignInResult;

/// Sign in with Apple through Firebase Auth's native Apple provider.
///
/// On iOS/macOS firebase_auth shows the system Apple sheet, handles the
/// nonce, and forwards the user's name to Firebase so `displayName` is set
/// on the first sign-in (Apple only shares the name once).
class AppleServices {
  static const providerId = 'apple.com';

  /// Apple sign-in is offered on iOS/macOS (required there by App Store
  /// Guideline 4.8 alongside Google sign-in) and on Android, where
  /// firebase_auth runs Apple's web sign-in flow in a browser tab.
  static bool get isAvailable =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.android);

  static AppleAuthProvider _provider() =>
      AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');

  static bool usesApple(User user) =>
      user.providerData.any((provider) => provider.providerId == providerId);

  static Future<SignInResult> signInWithApple() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithProvider(
        _provider(),
      );
      final user = credential.user;
      if (user == null) {
        return const SignInResult.failure(
          'Apple did not return an account. Please try again.',
        );
      }
      // HomePage provisions the reader profile after authStateChanges fires,
      // using user.displayName (or "Reader" if the name was not shared).
      return const SignInResult.success();
    } on FirebaseAuthException catch (error) {
      _logFailure('Apple sign-in', error.code);
      if (_isCancel(error.code)) return const SignInResult.cancelled();
      if (error.code == 'operation-not-allowed') {
        return const SignInResult.failure(
          'Apple sign-in is disabled in Firebase Authentication for this project.',
        );
      }
      if (error.code == 'invalid-cert-hash' ||
          error.code == 'invalid-oauth-client-id' ||
          error.code == 'internal-error') {
        return const SignInResult.failure(
          'Apple sign-in needs an app configuration update. Please use email sign-in for now.',
        );
      }
      if (error.code == 'account-exists-with-different-credential') {
        return const SignInResult.failure(
          'An account already uses this email with a different sign-in method.',
        );
      }
      return const SignInResult.failure(
        'Apple sign-in could not be completed. Please try again.',
      );
    } catch (error) {
      _logFailure('Apple sign-in', error.runtimeType.toString());
      return const SignInResult.failure(
        'Apple sign-in could not be completed. Please try again.',
      );
    }
  }

  /// Re-authenticates [user] with Apple and revokes the app's Apple token,
  /// as Apple requires when an account is deleted. Call right before
  /// deleting the account: the authorization code is single use and
  /// expires after a few minutes.
  static Future<void> reauthenticateAndRevoke(User user) async {
    final credential = await user.reauthenticateWithProvider(_provider());
    final code = credential.additionalUserInfo?.authorizationCode;
    if (code == null) return;
    try {
      await FirebaseAuth.instance.revokeTokenWithAuthorizationCode(code);
    } catch (error) {
      // Revocation failure must not block deleting the user's data.
      _logFailure('Apple token revocation', error.runtimeType.toString());
    }
  }

  static bool _isCancel(String code) =>
      code == 'canceled' ||
      code == 'cancelled' ||
      code == 'web-context-canceled' ||
      code == 'user-cancelled';

  static void _logFailure(String stage, String code) {
    if (kDebugMode) {
      debugPrint('Bookfania sign-in: $stage failed ($code).');
    }
  }
}
