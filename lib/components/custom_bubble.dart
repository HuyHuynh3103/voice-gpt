import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:voice_gpt/models/message_model.dart';

class CustomBubble extends BubbleSpecialThree {
  Message message;
  CustomBubble({
    required this.message,
  }) : super(
          text: message.content,
          tail: true,
          isSender: message.isSender,
          color: message.isSender
              ? const Color(0xFF1B97F3)
              : const Color(0xFFE8E8EE),
          textStyle: message.isSender
              ? const TextStyle(color: Colors.white)
              : const TextStyle(color: Colors.black),
        );

  @override
  Widget build(BuildContext context) {
    final contentMsg = super.build(context);
    if (!this.message.isLoading) {
      return contentMsg;
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
              child: const JumpingDots(
                color: Color(0xFF1B97F3),
                radius: 10,
                numberOfDots: 3,
              ),
            ),
          ),
        ),
      );
    }
  }
}
