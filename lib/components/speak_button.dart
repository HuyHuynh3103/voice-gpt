import 'package:flutter/cupertino.dart';
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

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => {
          setState(() {
            _isListening = val == 'listening';
          })
        },
        onError: (val) => print('error: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _text = val.recognizedWords;
            });
            if (val.finalResult) {
              setState(() {
                _isListening = false;
              });
              widget.onTextChanged(_text);
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: _listen,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: tPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic, color: tWhiteColor),
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
