import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';

class CustomMessageBar extends MessageBar {
  TextEditingController textController;
  CustomMessageBar({
    required this.textController,
    bool replying = false,
    String replyingTo = "",
    List<Widget> actions = const [],
    Color replyWidgetColor = const Color(0xffF4F4F5),
    Color replyIconColor = Colors.blue,
    Color replyCloseColor = Colors.black12,
    Color messageBarColor = const Color(0xffF4F4F5),
    Color sendButtonColor = Colors.blue,
    void Function(String)? onTextChanged,
    void Function(String)? onSend,
    void Function()? onTapCloseReply,
  }) : super(
          replying: replying,
          replyingTo: replyingTo,
          actions: actions,
          replyWidgetColor: replyWidgetColor,
          replyIconColor: replyIconColor,
          replyCloseColor: replyCloseColor,
          messageBarColor: messageBarColor,
          sendButtonColor: sendButtonColor,
          onTextChanged: onTextChanged,
          onSend: onSend,
          onTapCloseReply: onTapCloseReply,
        );
  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          replying
              ? Container(
                  color: replyWidgetColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.reply,
                        color: replyIconColor,
                        size: 24,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            'Re : ' + replyingTo,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onTapCloseReply,
                        child: Icon(
                          Icons.close,
                          color: replyCloseColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ))
              : Container(),
          replying
              ? Container(
                  height: 1,
                  color: Colors.grey.shade300,
                )
              : Container(),
          Container(
            color: messageBarColor,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: Row(
              children: <Widget>[
                ...actions,
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 3,
                      onChanged: onTextChanged,
                      decoration: InputDecoration(
                        hintText: "Type your message here",
                        hintMaxLines: 1,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10),
                        hintStyle: TextStyle(
                          fontSize: 16,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 0.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.black26,
                            width: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: InkWell(
                    child: Icon(
                      Icons.send,
                      color: sendButtonColor,
                      size: 24,
                    ),
                    onTap: () {
                      if (textController.text.trim() != '') {
                        if (onSend != null) {
                          onSend!(textController.text.trim());
                        }
                        textController.text = '';
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
