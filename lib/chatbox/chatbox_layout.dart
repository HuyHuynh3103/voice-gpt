import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_gpt/blocs/chat_gpt_bloc.dart';
import 'package:voice_gpt/blocs/chat_gpt_event.dart';
import 'package:voice_gpt/blocs/chat_gpt_state.dart';
import 'package:voice_gpt/models/message_model.dart';

class ChatBoxLayout extends StatefulWidget {
  @override
  State<ChatBoxLayout> createState() => _ChatBoxLayoutState();
}

class _ChatBoxLayoutState extends State<ChatBoxLayout> {
  final TextEditingController _controller = TextEditingController();
  late ChatGptBloc _chatGptBloc;
  @override
  void initState() {
    super.initState();
    _chatGptBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  // Implement _buildBody()
  // This is the main widget that will be displayed on the screen
  Widget _buildBody() {
    return BlocBuilder<ChatGptBloc, ChatState>(
        bloc: _chatGptBloc,
        builder: (context, state) {
          print(state);
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded) {

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.messageList.length,
                    itemBuilder: (context, index) {
                      Message msg = state.messageList[index];
                      return BubbleSpecialThree(
                        text: msg.content,
                        tail: true,
                        isSender: msg.isSender,
                        color: msg.isSender
                            ? Color(0xFF1B97F3)
                            : Color(0xFFE8E8EE),
                        textStyle: msg.isSender
                            ? TextStyle(color: Colors.white)
                            : TextStyle(color: Colors.black),
                      );
                    },
                  ),
                ),
                MessageBar(
                  onSend: (msg) {
                    context.read<ChatGptBloc>().add(SendMessage(msg));
                  },
                )
              ],
            );
          } else if (state is ChatFailure) {
            return Center(
                child: Text(
              state.error,
              style: const TextStyle(color: Colors.red),
            ));
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        });
  }
}
