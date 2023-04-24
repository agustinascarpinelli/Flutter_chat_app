
import 'package:flutter_chat_app/global/environment.dart';
import 'package:flutter_chat_app/models/usersResponse.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService{

Future getUsers() async{
try{
  final uri= Uri.parse('${Environment.apiUrl}/users');
final res=await http.get(uri,
  headers:{
    'Content-Type':'application/json',
    'x-token':await AuthService.getToken()
  }
);
final usersResponse=usersResponseFromJson(res.body);
return usersResponse.users;
}
catch(error){
print(error);
}

}

Future getRequest () async{

try{
  final uri= Uri.parse('${Environment.apiUrl}/users');
final res=await http.get(uri,
  headers:{
    'Content-Type':'application/json',
    'x-token':await AuthService.getToken()
  }
);
final user=AuthService().user;
final usersResponse=usersResponseFromJson(res.body);
List<User> filteredUsers = usersResponse.users.where((user) => 
  user.friends.any((friend) => friend['_id'] == user.uid && friend['status'] == 'pending')
).toList();
print(usersResponse.users);
return filteredUsers;

}catch(error){
  print(error);
}


}



}