import 'package:flutter/material.dart';
import 'package:voice_gpt/router/router.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:voice_gpt/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: routers,
    );
  }
}
