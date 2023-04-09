import 'package:flutter/material.dart';
import 'package:voice_gpt/common/colors.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: tBlackColor,
        backgroundColor: tWhiteColor,
        title: const Center(
          child: Text('Setting', style: TextStyle(color: tBlackColor)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            _buildAutoTTS(),
            const SizedBox(height: 20.0),
            _buildSpeechLanguage(),
            const SizedBox(height: 20.0),
            _buildDeleteAll(),
          ],
        ),
      ),
    );
  }

  // Implement _buildAutoTTS()
  Widget _buildAutoTTS() {
    return Container(
      height: 50.0,
      decoration: const BoxDecoration(
        color: tGreyLightColor,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Auto TTS replies', style: TextStyle(fontSize: 16.0)),
          ),
          FlutterSwitch(
            activeColor: tPrimaryColor,
            width: 50.0,
            height: 25.0,
            toggleSize: 20.0,
            value: true,
            borderRadius: 30.0,
            padding: 2.0,
            onToggle: (bool value) {},
          )
        ],
      ),
    );
  }

  // Implement _buildSpeechLanguage()
  Widget _buildSpeechLanguage() {
    return Container(
      height: 50.0,
      decoration: const BoxDecoration(
        color: tGreyLightColor,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Speech language', style: TextStyle(fontSize: 16.0)),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Text('English', style: TextStyle(fontSize: 16.0)),
          ),
        ],
      ),
    );
  }

  // Implement _buildDeleteAll()
  Widget _buildDeleteAll() {
    return GestureDetector(
      onTap: () {},
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
