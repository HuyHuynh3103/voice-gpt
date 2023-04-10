import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_gpt/blocs/chat_gpt/chat_gpt_bloc.dart';
import 'package:voice_gpt/blocs/chat_gpt/chat_gpt_event.dart';
import 'package:voice_gpt/blocs/setting/setting_bloc.dart';
import 'package:voice_gpt/blocs/setting/setting_state.dart';
import 'package:voice_gpt/common/colors.dart';

class SpeakButton extends StatefulWidget {
  TextEditingController controller;
  SpeakButton({required this.controller});

  @override
  State<SpeakButton> createState() => _SpeakButtonState();
}

class _SpeakButtonState extends State<SpeakButton> {
  late SpeechToText _speech;
  late ChatGptBloc _chatGptBloc;
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
    _chatGptBloc = BlocProvider.of<ChatGptBloc>(context);
  }

  /// This has to happen only once per app

  Future<void> _listen(SettingLoaded setting) async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (val) {
            setState(() {
              _text = val.recognizedWords;
              widget.controller.text = _text;
            });
          },
          localeId: setting.currentLanguage.code,
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  void turnOffAndSend() {
    setState(() {
      _isListening = false;
      _speech.stop();
    });
    if (_text.isNotEmpty) {
      widget.controller.clear();
      _chatGptBloc.add(SendMessage(_text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AvatarGlow(
            animate: _isListening,
            endRadius: 20,
            repeat: true,
            glowColor: tPrimaryColor,
            duration: const Duration(milliseconds: 2000),
            child: Container(
              width: 50,
              decoration: const BoxDecoration(
                color: tPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                child: Center(
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                onTapDown: (TapDownDetails details) async {
                  await _listen(BlocProvider.of<SettingBloc>(context).state
                      as SettingLoaded);
                },
                onTapUp: (TapUpDetails details) {
                  turnOffAndSend();
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Hold to speak',
            style: TextStyle(color: tPrimaryColor, fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
