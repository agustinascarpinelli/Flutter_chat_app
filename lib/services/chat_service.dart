import 'package:flutter/material.dart';
import 'package:flutter_chat_app/global/environment.dart';
import 'package:flutter_chat_app/models/messagesResponse.dart';
import 'package:flutter_chat_app/services/auth_service.dart';

import '../models/user.dart';
import 'package:http/http.dart' as http;


class ChatService with ChangeNotifier{

late User userfriend;

Future <List<Msg>>getChat (String userId) async{

final Uri url=Uri.parse('${Environment.apiUrl}/messages/${userId}');
  final resp=await http.get(url,
    headers:{
      'Content-type':'application/json',
      'x-token':await AuthService.getToken()
    }
  );

  final messagesResponse=messagesResponseFromJson(resp.body);
  return messagesResponse.msg;

}

Future <bool> deleteChat (String userId) async{
  final Uri url=Uri.parse('${Environment.apiUrl}/messages/${userId}');
  final resp=await http.delete(url,
    headers:{
      'Content-type':'application/json',
      'x-token':await AuthService.getToken()
    }
  );

if(resp.statusCode==200){
  return true;
}
else{
  return false;
}
}
}

