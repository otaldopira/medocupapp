import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medocup_app/pages/agendamento_page.dart';
import 'package:medocup_app/pages/busca_page.dart';
import 'package:medocup_app/pages/cadastro.colaborador_page.dart';
import 'package:medocup_app/pages/home_page.dart';
import 'package:medocup_app/pages/login_page.dart';
import 'package:medocup_app/pages/cadastro_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medocup_app/providers/agenda_provider.dart';
import 'package:medocup_app/providers/agendamento_provider.dart';
import 'package:medocup_app/providers/colaborador_provider.dart';
import 'package:medocup_app/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => AgendaProvider()),
        ChangeNotifierProvider(create: (context) => AgendamentoProvider()),
        ChangeNotifierProvider(create: (context) => ColaboradorProvider())
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/agendamento': (context) => const AgendamentoPage(),
        '/buscar': (context) =>
            const BuscaPage(tipoSelecao: TipoSelecao.selecionar),
        '/cadastro': (context) => const cadastroPage(),
        '/cadastro/Colaborador': (context) => CadastroColaboradorPage(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale("pt", "BR")],
    );
  }
}
