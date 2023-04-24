import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helpers/alert.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class ChangeProfileScreen extends StatelessWidget {
  const ChangeProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final User user = authService.user;

    return Scaffold(
        backgroundColor: const Color(0xFFFCCE73),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                    color: const Color(0xFFFAB904),
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.all(40),
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const _FormProfile(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class _FormProfile extends StatefulWidget {
  const _FormProfile({super.key});

  @override
  State<_FormProfile> createState() => __FormProfileState();
}

class __FormProfileState extends State<_FormProfile> {
  final emailCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameCtrl.text = Provider.of<AuthService>(context, listen: false).user.name;
    nameCtrl.addListener(_handleChange);
  }

  @override
  void dispose() {
    nameCtrl.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          _logoName(
              nameCtrl.text.trim() == '' ? user.name : nameCtrl.text.trim(),
              nameCtrl),
          _actions(() => Navigator.pop(context), () async {
            final name = nameCtrl.text.trim() == ''
                ? authService.user.name
                : nameCtrl.text.trim();
            final email = emailCtrl.text.trim() == ''
                ? authService.user.email
                : emailCtrl.text.trim();
            final res = await authService.changeUser(name, email);
            if (res.isLoggedIn) {
              Navigator.pop(context);
            } else {
              showAlert(context, 'Error', res.msg, const Icon(Icons.error));
            }
          }),
          //SizeBox(height:20),
          _info(user, emailCtrl)
        ],
      ),
    );
  }
}

_logoName(String name, controller) {
  return Container(
    margin: const EdgeInsets.all(50),
    child: Column(children: [
      CircleAvatar(
        backgroundColor: const Color(0xFFFF4040),
        maxRadius: 50,
        child: Text(name.substring(0, 1).toUpperCase(),
            style: const TextStyle(
                fontFamily: 'Poppins', fontSize: 30, color: Colors.white)),
      ),
      const SizedBox(height: 3),
      TextField(
        style: const TextStyle(fontFamily: 'Poppins'),
        //   controller: textController,
        autocorrect: false,
        cursorColor: const Color(0xFFFF4040),

        maxLines: 2,
        decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: name,
            hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: 'Poppins',
                fontSize: name.length <= 10 ? 30 : 20)),
        textAlign: TextAlign.center,
        controller: controller,
      )
    ]),
  );
}

_info(User user, controller) {
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
        TextField(
          style: const TextStyle(fontFamily: 'Poppins'),
          //   controller: textController,
          autocorrect: false,
          decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: user.email,
              hintStyle:
                  const TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          textAlign: TextAlign.center,
          controller: controller,
        )
      ],
    ),
  );
}

_actions(navigate, handleChange) {
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
            onPressed: navigate,
            icon: const Icon(Icons.cancel),
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
            onPressed: handleChange,
            icon: const Icon(Icons.done),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        )
      ],
    ),
  );
}
