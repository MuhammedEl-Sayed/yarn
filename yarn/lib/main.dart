import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:yarn/app_router.dart';
import 'package:yarn/providers/spool_provider.dart';
import 'package:yarn/services/spool_service.dart';
import 'package:yarn/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SpoolService>(create: (_) => SpoolService.create()),
        ChangeNotifierProvider<SpoolProvider>(
          create: (context) => SpoolProvider(context.read<SpoolService>()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Yarn',
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}
