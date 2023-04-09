import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_gpt/components/chatbox_layout.dart';
import 'package:voice_gpt/common/colors.dart';
import 'package:voice_gpt/components/speak_button.dart';

class MessageChatPage extends StatefulWidget {
  const MessageChatPage({Key? key}) : super(key: key);

  @override
  _MessageChatPageState createState() => _MessageChatPageState();
}

class _MessageChatPageState extends State<MessageChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tWhiteColor,
        title: const Center(
          child: Text('Chat', style: TextStyle(color: tBlackColor)),
        ),
        actions: <Widget>[
          Center(
            child: GestureDetector(
                onTap: _navigateToSettingsPage,
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                  color: tPrimaryColor,
                )),
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
                children: [_buildLanguageButton(() {})],
              )),
          const SizedBox(height: 10.0),
          const Expanded(child: ChatBoxLayout()),
        ],
      ),
      // bottom bar has speak button in middle and hand-free checkbox on right-hand side
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Spacer(),
            SpeakButton(onTextChanged: (String text) {
              print('text: $text');
              ChatBoxLayout chatBoxLayout =
                  context.findAncestorWidgetOfExactType<ChatBoxLayout>()!;
              chatBoxLayout.addMessageFromSpeaker(text);
            }),
            const SizedBox(width: 60.0),
            _buildHandFreeCheckbox((bool? value) {}),
            const SizedBox(width: 10.0),
          ],
        ),
      ),
    );
  }

  Widget _buildHandFreeCheckbox(
    void Function(bool? value) onChanged,
  ) {
    return Row(
      children: <Widget>[
        const Text('Hand-free'),
        Checkbox(
          value: false,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildLanguageButton(
    void Function() onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          children: <Widget>[
            Image.asset('assets/countries/us.png'),
            const SizedBox(width: 5.0),
            const Text('US-EN'),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _navigateToSettingsPage() {
    context.go('/settings');
  }
}
