import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final User user = authService.user;
    return Scaffold(
        backgroundColor: const Color(0xFFFCCE73),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
                color: Color(0xFFFAB904),
                borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.all(50),
            child: Column(
              children: [
                _logoName(user),
                _actions(() => Navigator.pushNamed(context, 'change-profile')),
                //SizeBox(height:20),
                _info(user)
              ],
            ),
          ),
        ));
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
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: user.name.length >= 10 ? 15 : 30),
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

_actions(navigate) {
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
            onPressed: () {},
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
            onPressed: navigate,
            icon: const Icon(Icons.edit),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        )
      ],
    ),
  );
}
