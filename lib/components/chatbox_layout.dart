import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_gpt/blocs/chat_gpt/chat_gpt_bloc.dart';
import 'package:voice_gpt/blocs/chat_gpt/chat_gpt_event.dart';
import 'package:voice_gpt/blocs/chat_gpt/chat_gpt_state.dart';
import 'package:voice_gpt/components/custom_bubble.dart';
import 'package:voice_gpt/components/custom_message_bar.dart';

class ChatBoxLayout extends StatefulWidget {
  final TextEditingController controller;
  ChatBoxLayout({Key? key, required this.controller}) : super(key: key);
  @override
  State<ChatBoxLayout> createState() => _ChatBoxLayoutState();
}

class _ChatBoxLayoutState extends State<ChatBoxLayout> {
  final ScrollController _scrollController = ScrollController();
  late ChatGptBloc _chatGptBloc;
  @override
  void initState() {
    super.initState();
    _chatGptBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
          print(
              "messageList: ${state.messageList.map((e) => e.content).toList()}");
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.messageList.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return BubbleChat(
                      message: state.messageList[index],
                    );
                  },
                ),
              ),
              CustomMessageBar(
                textController: widget.controller,
                onSend: (msg) {
                  context.read<ChatGptBloc>().add(SendMessage(msg));
                },
              )
            ],
          );
        } else if (state is ChatFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: Text(state.error),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      _chatGptBloc.add(LoadInitialMessage());
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
          });
          return const SizedBox.shrink();
        } else {
          return const Center(child: Text('Something went wrong!'));
        }
      },
    );
  }
}
