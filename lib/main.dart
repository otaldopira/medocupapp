import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medocup_app/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medocup_app/pages/cadastros/agenda_medico_page.dart';
import 'package:medocup_app/pages/cadastros/cadasto.dart';
import 'package:medocup_app/pages/home_page.dart';
import 'package:medocup_app/providers/agenda_provider.dart';
import 'package:medocup_app/providers/agendamento_provider.dart';
import 'package:medocup_app/providers/colaborador_provider.dart';
import 'package:medocup_app/providers/profissional_provider.dart';
import 'package:medocup_app/services/auth_service.dart';
import 'package:medocup_app/widgets/auth_check.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(
            create: (context) =>
                AgendaProvider(auth: context.read<AuthService>())),
        ChangeNotifierProvider(create: (context) => AgendamentoProvider()),
        ChangeNotifierProvider(create: (context) => ColaboradorProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                ProfissionalProvider(auth: context.read<AuthService>())),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthCheck(),
      // home: ConfiguracaoAgenda(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [Locale("pt", "BR")],
    );
  }
}
