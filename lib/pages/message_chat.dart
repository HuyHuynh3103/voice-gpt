import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_gpt/blocs/setting/setting_bloc.dart';
import 'package:voice_gpt/blocs/setting/setting_event.dart';
import 'package:voice_gpt/blocs/setting/setting_state.dart';
import 'package:voice_gpt/common/language.dart';
import 'package:voice_gpt/components/chatbox_layout.dart';
import 'package:voice_gpt/common/colors.dart';
import 'package:voice_gpt/components/speak_button.dart';

class MessageChatPage extends StatefulWidget {
  const MessageChatPage({Key? key}) : super(key: key);

  @override
  _MessageChatPageState createState() => _MessageChatPageState();
}

class _MessageChatPageState extends State<MessageChatPage> {
  final TextEditingController _textController = TextEditingController();
  late SettingBloc _settingBloc;
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _settingBloc = context.read<SettingBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: tWhiteColor,
        title: const Text('Chat', style: TextStyle(color: tBlackColor)),
        actions: <Widget>[
          Center(
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _navigateToSettingsPage,
              color: tPrimaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
              height: 50.0,
              color: tGreyLightColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [_buildLanguageButton()],
              )),
          const SizedBox(height: 10.0),
          Expanded(
            child: ChatBoxLayout(
              controller: _textController,
            ),
          ),
        ],
      ),
      // bottom bar has speak button in middle and hand-free checkbox on right-hand side
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Spacer(),
            SpeakButton(onTextChanged: (String text) {
              print('response : $text');
              setState(() {
                _textController.text = text;
              });
            }),
            const SizedBox(width: 60.0),
            _buildHandFreeCheckbox(),
            const SizedBox(width: 10.0),
          ],
        ),
      ),
    );
  }

  Widget _buildHandFreeCheckbox() {
    return BlocBuilder(
      bloc: _settingBloc,
      builder: (context, state) => Row(
        children: <Widget>[
          const Text('Hand-free'),
          Checkbox(
            checkColor: tWhiteColor,
            activeColor: tPrimaryColor,
            value: state is SettingLoaded ? state.isAutoTTS : false,
            onChanged: (bool? value) {
              if (value != null) {
                _settingBloc.add(SetHandFree(value));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton() {
    return BlocBuilder(
        builder: (context, state) {
          if (state is SettingLoaded) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButton<Language>(
                value: state.currentLanguage,
                elevation: 16,
                style: const TextStyle(color: tPrimaryColor),
                onChanged: (Language? newValue) {
                  context
                      .read<SettingBloc>()
                      .add(ToggleLanguage(newValue ?? languages[0]));
                },
                items:
                    languages.map<DropdownMenuItem<Language>>((Language value) {
                  return DropdownMenuItem<Language>(
                    value: value,
                    child: Row(
                      children: <Widget>[
                        Image.asset(value.flag),
                        const SizedBox(width: 10.0),
                        Text(value.name),
                      ],
                    )
                  );
                }).toList(),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
        bloc: _settingBloc);
  }

  void _navigateToSettingsPage() {
    context.push('/settings');
  }
}
