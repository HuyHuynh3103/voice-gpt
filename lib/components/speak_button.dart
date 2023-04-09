import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_gpt/common/colors.dart';

class SpeakButton extends StatefulWidget {
  final Function(String) onTextChanged;
  SpeakButton({required this.onTextChanged});

  @override
  State<SpeakButton> createState() => _SpeakButtonState();
}

class _SpeakButtonState extends State<SpeakButton> {
  late SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
  }

  /// This has to happen only once per app

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(onStatus: (val) {
        setState(() {
          _isListening = val == 'done';
          _speech.stop();
        });
      }, onError: (val) {
        print('onError: $val');
        setState(() {
          _isListening = false;
          _speech.stop();
        });
      });
      print('available: $available');
      print('isListening: $_isListening');
      print('text: $_text');
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(onResult: (val) {
          print('onResult: $val');
          setState(() {
            _text = val.recognizedWords;
          });

          if (val.finalResult) {
            widget.onTextChanged(_text);
            setState(() {
              _isListening = false;
              _text = '';
            });
          }
        });
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
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
              decoration: const BoxDecoration(
                color: tPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                ),
                onPressed: _listen,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Tap to speak',
            style: TextStyle(color: tPrimaryColor, fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
