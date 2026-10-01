import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yarn/app_router.dart';
import 'package:yarn/providers/spool_provider.dart';
import 'package:yarn/services/spool_service.dart';
import 'package:yarn/services/token_store.dart';
import 'package:yarn/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TokenStore>(create: (_) => TokenStore()),
        ProxyProvider<TokenStore, SpoolService>(
          update: (_, tokens, _) => SpoolService.create(tokens),
        ),
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
