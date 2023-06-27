import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService extends ChangeNotifier {
  final LocalAuthentication auth;
  LocalAuthService({required this.auth});

  Future<bool> isBiometricAvailable() async {
  try {
    final bool hasBiometrics = await auth.canCheckBiometrics;
    final bool hasDeviceSupport = await auth.isDeviceSupported();

    if (hasBiometrics && hasDeviceSupport) {
      return true; // Autenticação biométrica disponível
    } else {
      return false; // Autenticação biométrica não disponível
    }
  } catch (e) {
    return false; // Ocorreu um erro durante a verificação
  }
}

  Future<bool> authenticate() async {
    return await auth.authenticate(
      localizedReason: 'Por favor, autentique-se.',
    );
  }
}
