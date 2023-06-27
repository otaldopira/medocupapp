import 'package:flutter/material.dart';
import 'package:medocup_app/pages/auth_page.dart';
import 'package:medocup_app/pages/home_page.dart';
import 'package:medocup_app/pages/login_page.dart';
import 'package:medocup_app/services/auth_service.dart';
import 'package:provider/provider.dart';


class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});
  @override
  State<AuthCheck> createState() => AuthCheckState();
}
class AuthCheckState extends State<AuthCheck> {
  
  @override
  Widget build(BuildContext context) {
    AuthService auth = context.watch<AuthService>();
    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario != null) {
      if (auth.returnLogin) {
        return const AuthPage();
      }
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }

  loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
