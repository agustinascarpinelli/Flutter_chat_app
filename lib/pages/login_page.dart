import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helpers/alert.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/socket_service.dart';
import 'package:flutter_chat_app/widgets/custom_button.dart';
import 'package:flutter_chat_app/widgets/custom_input.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_labels.dart';
import '../widgets/custom_logo.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFCCE73),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Logo(),
                  const _FormLogin(),
                  const Labels(
                    text: 'Create a FREE account',
                    route: 'register',
                  ),
                  const Text(
                    'Terms of use',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _FormLogin extends StatefulWidget {
  const _FormLogin({super.key});

  @override
  State<_FormLogin> createState() => __FormLoginState();
}

class __FormLoginState extends State<_FormLogin> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService=Provider.of<SocketService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.key,
            placeholder: 'Password',
            keyboardType: TextInputType.text,
            isPassword: true,
            textController: passCtrl,
          ),
          CustomButtom(
              text: 'Login',
              function: authService.auth
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final login = await authService.login(
                          emailCtrl.text.trim(), passCtrl.text.trim());
                      if (login) {
                        socketService.connect();
                        Navigator.pushReplacementNamed(context,'users');
                      } else {
                        showAlert(context,'Invalid data','Try again',Icon(Icons.warning_outlined));
                      }
                    })
        ],
      ),
    );
  }
}
