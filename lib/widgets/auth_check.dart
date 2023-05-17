import 'package:flutter/material.dart';
import 'package:medocup_app/pages/home_page.dart';
import 'package:medocup_app/pages/login_page.dart';
import 'package:medocup_app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    Future(() {
      Loader.show(context,
          progressIndicator: const CircularProgressIndicator());
      context.read<AuthService>();
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = context.watch<AuthService>();

    if (auth.isLoading) {
      Loader.hide();
      return loading();
    } else if (auth.usuario == null) {
      Loader.hide();
      return const LoginPage();
    } else {
      Loader.hide();
      return const HomePage();
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
