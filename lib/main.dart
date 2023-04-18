import 'package:flutter/material.dart';
import 'package:medocup_app/pages/agendamento.page.dart';
import 'package:medocup_app/pages/busca.page.dart';
import 'package:medocup_app/pages/cadastro.colaborador.page.dart';
import 'package:medocup_app/pages/home.page.dart';
import 'package:medocup_app/pages/login.page.dart';
import 'package:medocup_app/pages/cadastro.page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medocup_app/providers/agenda.provider.dart';
import 'package:medocup_app/providers/agendamento.provider.dart';
import 'package:medocup_app/providers/colaborador.provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
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
      initialRoute: '/login',
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
