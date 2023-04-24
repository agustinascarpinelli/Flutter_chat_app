import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/custom_button.dart';
import 'package:flutter_chat_app/widgets/custom_input.dart';
import 'package:provider/provider.dart';
import '../helpers/alert.dart';
import '../models/error_message_response.dart';
import '../services/auth_service.dart';
import '../services/socket_service.dart';
import '../widgets/custom_labels.dart';
import '../widgets/custom_logo.dart';

class RegisterScreen extends StatelessWidget {
   
  const RegisterScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFFFCCE73) ,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height*0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                 const Logo(),
                 const _FormRegister(),
                 const Labels(text: 'Already sign up? Sign in',route: 'login',),
                 const Text('Terms of use',style: TextStyle(color: Colors.white,fontFamily: 'Poppins'),)
              ],
            ),
          ),
        ),
      )
    );
  }
}



class _FormRegister extends StatefulWidget {
  const _FormRegister({super.key});

  @override
  State<_FormRegister> createState() => __FormRegisterState();
}

class __FormRegisterState extends State<_FormRegister> {

  final emailCtrl=TextEditingController();
  final passCtrl=TextEditingController();
  final confirmPassCtrl=TextEditingController();
  final nameCtrl=TextEditingController();

  @override
  Widget build(BuildContext context) {
     final authService = Provider.of<AuthService>(context);
     final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
           CustomInput(icon: Icons.perm_identity,placeholder: 'Name',keyboardType: TextInputType.text,textController: nameCtrl,),
      CustomInput(icon: Icons.mail_outline,placeholder: 'Email',keyboardType: TextInputType.emailAddress,textController: emailCtrl,),
      CustomInput(icon:Icons.key,placeholder: 'Password',keyboardType: TextInputType.text,isPassword: true,textController: passCtrl,),
      CustomInput(icon:Icons.key,placeholder: 'Confirm password',keyboardType: TextInputType.text,isPassword: true,textController: confirmPassCtrl,),
      
     CustomButtom(text: 'Sign up',function: authService.auth
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final ErrorMessage login = await authService.register(
                          emailCtrl.text.trim(),nameCtrl.text.trim(), passCtrl.text.trim(),confirmPassCtrl.text.trim());
                      if (login.isLoggedIn) {
                      //   if (!context.mounted) return;
                      socketService.connect();
                        Navigator.pushReplacementNamed(context,'users');
                      } else {
                      //   if (!context.mounted) return;
                        showAlert(context,'Invalid data',login.msg,const Icon(Icons.warning_outlined));
                      }
                    })
        ],
      ),
    );
  }


}

