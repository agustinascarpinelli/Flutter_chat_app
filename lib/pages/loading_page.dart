import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/pages/users_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/services/auth_service.dart';

import '../services/socket_service.dart';




class LoadingScreen extends StatelessWidget {
   
  const LoadingScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFFFCCE73) ,
      body: FutureBuilder(
        future:checkLoginState(context) ,
        builder: (context, snapshot) {
          return const Center(
           child: CircularProgressIndicator(
            color: Color(0xFFFA6450),
           )
          );
        },
                ),
      );
    
  }


  Future checkLoginState(BuildContext context) async{
    final authService=Provider.of<AuthService>(context,listen: false);
     final socketService=Provider.of<SocketService>(context,listen: false);
    final auth=await authService.isLoggedIn();
    if(auth.isLoggedIn){
      
      // Navigator.pushReplacementNamed(context, 'users');
      // ignore: use_build_context_synchronously
      socketService.connect();
      
      Navigator.pushReplacement(context,
       PageRouteBuilder(
        pageBuilder: (_,__,___)=>const UsersScreen(),
        transitionDuration: const Duration(milliseconds: 0)
        ));

    }else{
         // ignore: use_build_context_synchronously
         Navigator.pushReplacement(context,
       PageRouteBuilder(
        pageBuilder: (_,__,___)=>const LoginScreen(),
        transitionDuration: const Duration(milliseconds: 0)
        ));
    }
  }
}