import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService extends ChangeNotifier {
  final LocalAuthentication auth;

  LocalAuthService({required this.auth});

  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    return await auth.authenticate(
      localizedReason: 'Por favor, autentique-se.',
    );
  }
}
