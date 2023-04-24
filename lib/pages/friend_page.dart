import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helpers/alert_confirm.dart';
import 'package:flutter_chat_app/services/chat_service.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class FriendScreen extends StatelessWidget {
  const FriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final User friend = chatService.userfriend;

    return Scaffold(
        backgroundColor: const Color(0xFFFCCE73),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
                color: const Color(0xFFFAB904),
                borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.all(50),
            child: Column(
              children: [
                _logoName(friend),
                _actions(
                    context,
                   
                    friend.name,
                    () => {
                          alertConfirm(context,
                           'Are you sure?',
                           'The chat history between you and ${friend.name} will be deleted ',
                           () async{
                            final chatDel =await _handleDelete(context,friend.uid);
                            if (chatDel) {
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamed(context,'chat');
                            } else {
                              return;
                            }
                          })
                        }),
                //SizeBox(height:20),
                _info(friend)
              ],
            ),
          ),
        ));
  }
}

_handleDelete(context,uid) async {
  final chatService = Provider.of<ChatService>(context, listen: false);
  final message = await chatService.deleteChat(uid);

  if (message) {
    return true;
  } else {
    return false;
  }
}

_logoName(User user) {
  return Container(
    margin: const EdgeInsets.all(50),
    child: Column(children: [
      CircleAvatar(
        backgroundColor: const Color(0xFFFF4040),
        maxRadius: 50,
        child: Text(user.name.substring(0, 1),
            style: const TextStyle(
                fontFamily: 'Poppins', fontSize: 30, color: Colors.white)),
      ),
      const SizedBox(height: 3),
      Text(
        user.name,
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 30),
      )
    ]),
  );
}

_info(User user) {
  return Container(
    margin: const EdgeInsets.only(top: 30, left: 5, right: 5),
    padding: const EdgeInsets.only(left: 10, right: 5, bottom: 5, top: 5),
    width: 300,
    height: 100,
    decoration: BoxDecoration(
        color: const Color(0xFFfab400),
        borderRadius: BorderRadius.circular(20)),
    child: Column(
      children: [
        const Text(
          'Email:',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        Text(
          user.email,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
      ],
    ),
  );
}

_actions(BuildContext context, name, function) {
  return Container(
    width: 200,
    decoration: BoxDecoration(
        color: const Color(0xFFfab400),
        borderRadius: BorderRadius.circular(20)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: const Color(0xFFFAB904),
              borderRadius: BorderRadius.circular(15)),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'search-messages');
            },
            icon: const Icon(Icons.search),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          decoration: BoxDecoration(
              color: const Color(0xFFFAB904),
              borderRadius: BorderRadius.circular(15)),
          child: IconButton(
            onPressed: function,
            icon: const Icon(Icons.delete),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        )
      ],
    ),
  );
}
