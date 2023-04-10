import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_gpt/blocs/chat_gpt/chat_gpt_bloc.dart';
import 'package:voice_gpt/blocs/chat_gpt/chat_gpt_event.dart';
import 'package:voice_gpt/blocs/setting/setting_bloc.dart';
import 'package:voice_gpt/blocs/setting/setting_event.dart';
import 'package:voice_gpt/blocs/setting/setting_state.dart';
import 'package:voice_gpt/common/colors.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:voice_gpt/common/language.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late ChatGptBloc _chatGptBloc;
  late SettingBloc _settingBloc;
  @override
  void initState() {
    super.initState();
    _chatGptBloc = context.read<ChatGptBloc>();
    _settingBloc = context.read<SettingBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: tBlackColor,
        backgroundColor: tWhiteColor,
        title: Text('Setting', style: TextStyle(color: tBlackColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            _buildAutoTTS(),
            const SizedBox(height: 20.0),
            _buildSpeechLanguageChoosen(),
            const SizedBox(height: 20.0),
            _buildDeleteAll(),
          ],
        ),
      ),
    );
  }

  // Implement _buildAutoTTS()
  Widget _buildAutoTTS() {
    return BlocBuilder(
        builder: (context, state) {
          print('state: $state');
          if (state is SettingLoaded) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              height: 50.0,
              decoration: const BoxDecoration(
                color: tGreyLightColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Auto TTS replies',
                      style: TextStyle(fontSize: 16.0)),
                  FlutterSwitch(
                    activeColor: tPrimaryColor,
                    width: 50.0,
                    height: 25.0,
                    toggleSize: 20.0,
                    value: state.isAutoTTS,
                    borderRadius: 30.0,
                    padding: 2.0,
                    onToggle: (bool value) {
                      context.read<SettingBloc>().add(SetHandFree(value));
                    },
                  )
                ],
              ),
            );
          }
          return const SizedBox();
        },
        bloc: _settingBloc);
  }

  // Implement _buildSpeechLanguage()
  Widget _buildSpeechLanguageChoosen() {
    return BlocBuilder(
        builder: (context, state) {
          if (state is SettingLoaded) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              height: 50.0,
              decoration: const BoxDecoration(
                color: tGreyLightColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Speech language',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  DropdownButton<Language>(
                    value: state.currentLanguage,
                    elevation: 16,
                    style: const TextStyle(color: tPrimaryColor),
                    onChanged: (Language? newValue) {
                      context
                          .read<SettingBloc>()
                          .add(ToggleLanguage(newValue ?? languages[0]));
                    },
                    items: languages
                        .map<DropdownMenuItem<Language>>((Language value) {
                      return DropdownMenuItem<Language>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Image.asset(value.flag),
                              const SizedBox(width: 10.0),
                              Text(value.name),
                            ],
                          ));
                    }).toList(),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
        bloc: _settingBloc);
  }

  // Implement _buildDeleteAll()
  Widget _buildDeleteAll() {
    return GestureDetector(
      onTap: () {
        _settingBloc.add(ClearMessages());
        _chatGptBloc.add(const LoadInitialMessage());
        context.pop();
      },
      child: Container(
        height: 50.0,
        decoration: const BoxDecoration(
          color: tPrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: const Center(
          child: Text('Delete all messages',
              style: TextStyle(fontSize: 16.0, color: tWhiteColor)),
        ),
      ),
    );
  }
}
