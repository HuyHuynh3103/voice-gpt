import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_gpt/common/colors.dart';
import 'package:voice_gpt/models/message_model.dart';
import 'package:text_to_speech/text_to_speech.dart';

class BubbleChat extends StatefulWidget {
  Message message;
  late BubbleSpecialThree _bubble;
  String currentLanguage;
  bool isReading;
  BubbleChat(
      {super.key,
      required this.message,
      required this.currentLanguage,
      this.isReading = false}) {
    _bubble = BubbleSpecialThree(
      text: message.content,
      tail: true,
      isSender: message.isSender,
      color: message.isSender ? tPrimaryColor : const Color(0xFFE8E8EE),
      textStyle: message.isSender
          ? const TextStyle(color: Colors.white)
          : const TextStyle(color: Colors.black),
    );
  }

  @override
  State<BubbleChat> createState() => _BubbleChatState();
}

class _BubbleChatState extends State<BubbleChat> {
  TextToSpeech tts = TextToSpeech();
  late bool isPlaying;
  @override
  void initState() {
    isPlaying = widget.isReading;
    tts.setLanguage(widget.currentLanguage);
    tts.setPitch(1.0);
    tts.setRate(0.8);
    tts.setVolume(1.0);

    if (isPlaying) {
      tts.speak(
        widget._bubble.text,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.message.isTyping) {
      return Row(
        mainAxisAlignment: widget._bubble.isSender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          _buildCustomMessage(context),
          if (!widget._bubble.isSender)
            Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: IconButton(
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  color: tPrimaryColor,
                ),
                color: tPrimaryColor,
                onPressed: () {
                  setState(() {
                    isPlaying = !isPlaying;
                    if (isPlaying) {
                      tts.speak(
                        widget._bubble.text,
                      );
                    } else {
                      tts.stop();
                    }
                  });
                },
              ),
            ),
        ],
      );
    } else {
      return _buildIsTypingMessage();
    }
  }

  Widget _buildIsTypingMessage() {
    return Align(
      alignment:
          widget._bubble.isSender ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: CustomPaint(
          painter: SpecialChatBubbleThree(
            color: widget._bubble.color,
            alignment: widget._bubble.isSender
                ? Alignment.topRight
                : Alignment.topLeft,
            tail: widget._bubble.tail,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(10),
            child: const SpinKitThreeBounce(
              color: tPrimaryColor,
              size: 20.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomMessage(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (widget._bubble.sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (widget._bubble.delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (widget._bubble.seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Align(
      alignment:
          widget._bubble.isSender ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: CustomPaint(
          painter: SpecialChatBubbleThree(
            color: widget._bubble.color,
            alignment: widget._bubble.isSender
                ? Alignment.topRight
                : Alignment.topLeft,
            tail: widget._bubble.tail,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .7,
              minWidth: MediaQuery.of(context).size.width * .3,
            ),
            margin: widget._bubble.isSender
                ? stateTick
                    ? const EdgeInsets.fromLTRB(7, 7, 14, 7)
                    : const EdgeInsets.fromLTRB(7, 7, 17, 7)
                : const EdgeInsets.fromLTRB(17, 7, 7, 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: stateTick
                          ? const EdgeInsets.only(left: 4, right: 20)
                          : const EdgeInsets.only(left: 4, right: 4),
                      child: Text(
                        widget._bubble.text,
                        style: widget._bubble.textStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    stateIcon != null && stateTick
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            child: stateIcon,
                          )
                        : const SizedBox(
                            width: 1,
                          ),
                    // datetime
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  DateFormat('hh:mm a').format(widget.message.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: widget._bubble.textStyle.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
