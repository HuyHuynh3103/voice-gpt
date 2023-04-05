import 'package:chatview/chatview.dart';
import 'package:uuid/uuid.dart';

ChatUser user = ChatUser(id: const Uuid().v4(), name: 'User');
ChatUser bot = ChatUser(id: const Uuid().v4(), name: 'OpenAI Bot');

