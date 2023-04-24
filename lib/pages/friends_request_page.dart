import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helpers/alert.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/socket_service.dart';
import '../services/usesrs_service.dart';

class FriendsRequestsScreen extends StatefulWidget {
  const FriendsRequestsScreen({super.key});

  @override
  State<FriendsRequestsScreen> createState() => _FriendsRequestsState();
}

class _FriendsRequestsState extends State<FriendsRequestsScreen> {
  late SocketService socketService;
  final userService = UserService();
 final _focusNode =FocusNode();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<User> usersDB = [];

  @override
  void initState() {
      socketService = Provider.of<SocketService>(context, listen: false);
       socketService.socket.on('add friend', ((data) {
         print(data);
       }));
    _chargeUsers();
    super.initState();
  }

  List<User> _searchResult = [];


  @override
  void dispose() {
    socketService.socket.off('add friend');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCCE73),
      appBar: AppBar(
        title: const Text(
          'Friends requests',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        elevation: 1,
        centerTitle: true,
        backgroundColor: const Color(0xFFfab400),
      ),
      body: Column(
        children: [
          Expanded(
              child: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            header: const WaterDropHeader(
              complete: Icon(Icons.check, color: Color(0xFFfab400)),
              refresh: CircularProgressIndicator(color: Color(0xFFfab400)),
              waterDropColor: Color(0xFFfab400),
            ),
            onRefresh: _chargeUsers,
            child: 
                (usersDB.isNotEmpty?  _listViewUsers() :  const Flexible(child: Center(child: Text('There are no friends requests'))))
                
          )),
        ],
      ),
    );
  }

  ListView _listViewUsers() {
    return
ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(usersDB[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: usersDB.length);
  }

  ListTile _userListTile(User user) {
    final socketService = Provider.of<SocketService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final cuser =  authService.user;
 
    return ListTile(
      title: Text(
        user.name,
        style: const TextStyle(fontFamily: 'Poppins', color: Color(0xFFFF4040)),
      ),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFFF4040),
        child: Text(
          user.name.substring(0, 1),
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      trailing: Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 15),
          child: IconButton(
            icon:  const Icon(
              Icons.add_box_outlined,
              color: Color(0xFFFF4040),
            ),
            onPressed: () {
             
            },
          ),
          
          ),
          onTap: () {
            
             
              socketService.emit('add friend', {'uid':cuser.uid, 'idFriend': user.uid});
              showAlert(context, 'New friend added', 'You have add ${user.name} to friends', Icon(Icons.check,color: Colors.green[500],));
              usersDB.removeWhere((u) => u.uid==user.uid);
              setState(() {

          });}
     
    );
  }

_chargeUsers() async {
 final authService = Provider.of<AuthService>(context, listen: false);
  final currentUser =  authService.user;
  if (currentUser.friends.isNotEmpty){
 final friendsIds = currentUser.friends.map((friend) => friend['_id']).toList();

  final allUsers = await userService.getUsers();
final nonFriends = allUsers.where((user) => 
  !friendsIds.contains(user.uid) &&
  user.friends.any((friend) => friend['_id'] == currentUser.uid && friend['status'] == 'pending')
).toList();
  setState(() {
    usersDB = nonFriends;
  });

  }else{
    final allUsers = await userService.getUsers();
    setState(() {
    usersDB = allUsers;
  });
    
  }
 
  

  _refreshController.refreshCompleted();
}


   
}
