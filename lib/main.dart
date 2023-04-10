import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_gpt/blocs/chat_gpt/chat_gpt_bloc.dart';
import 'package:voice_gpt/blocs/setting/setting_bloc.dart';
import 'package:voice_gpt/repository/chat_gpt.dart';
import 'package:voice_gpt/repository/local_storage.dart';
import 'package:voice_gpt/routing/router.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:voice_gpt/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  final localStorage = LocalStorage();
  await localStorage.init();
  final chatGptRepository = ChatGptRepository();
  chatGptRepository.init();
  runApp(MainApp(
    chatGptRepository: chatGptRepository,
    localStorage: localStorage,
  ));
}

class MainApp extends StatelessWidget {
  @override
  final ChatGptRepository chatGptRepository;
  final LocalStorage localStorage;
  MainApp({
    Key? key,
    required this.chatGptRepository,
    required this.localStorage,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: routers,
      builder: (context, child) {
        return MultiBlocProvider(providers: [
          BlocProvider(
            create: (context) => ChatGptBloc(
              chatGptRepository: chatGptRepository,
              localStorage: localStorage,
            ),
          ),
          BlocProvider(
            create: (context) => SettingBloc(
              localStorage: localStorage,
            ),
          )
        ], child: child!);
      },
    );
  }
}
