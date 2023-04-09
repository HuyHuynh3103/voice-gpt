import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_gpt/common/colors.dart';
import 'package:voice_gpt/models/message_model.dart';

class CustomBubble extends BubbleSpecialThree {
  Message message;
  CustomBubble({
    required this.message,
  }) : super(
          text: message.content,
          tail: true,
          isSender: message.isSender,
          color: message.isSender ? tPrimaryColor : const Color(0xFFE8E8EE),
          textStyle: message.isSender
              ? const TextStyle(color: Colors.white)
              : const TextStyle(color: Colors.black),
        );

  @override
  Widget build(BuildContext context) {
    final contentMsg = _buildCustomMessage(context);
    if (!message.isTyping) {
      return Row(
        mainAxisAlignment: this.message.isSender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          contentMsg,
          if (!message.isSender)
            Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: IconButton(
                icon: Icon(Icons.play_circle_outline),
                color: tPrimaryColor,
                onPressed: () => {},
              ),
            ),
        ],
      );
    } else {
      return Align(
        alignment: isSender ? Alignment.topRight : Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: CustomPaint(
            painter: SpecialChatBubbleThree(
              color: color,
              alignment: isSender ? Alignment.topRight : Alignment.topLeft,
              tail: tail,
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
  }

  Widget _buildCustomMessage(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: CustomPaint(
          painter: SpecialChatBubbleThree(
            color: color,
            alignment: isSender ? Alignment.topRight : Alignment.topLeft,
            tail: tail,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .7,
              minWidth: MediaQuery.of(context).size.width * .3,
            ),
            margin: isSender
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
                        text,
                        style: textStyle,
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
                  DateFormat('hh:mm a').format(message.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: textStyle.color,
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
