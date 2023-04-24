import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/chat_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/routes/routes.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/socket_service.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>AuthService()),
        ChangeNotifierProvider(create: (_) =>SocketService()),
        ChangeNotifierProvider(create: (_) =>ChatService()),
        
        
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}