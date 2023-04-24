import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helpers/alert_confirm.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/chat_service.dart';
import 'package:flutter_chat_app/services/usesrs_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_chat_app/models/user.dart';

import '../services/socket_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final userService = UserService();
  bool _noFriends=false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<User> usersDB = [];
  @override
  void initState() {
    _chargeUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final user = authService.user;
    final status = socketService.serverStatus;
    return Scaffold(
        backgroundColor: const Color(0xFFFCCE73),
        appBar: AppBar(
          title: Text(
            user.name,
            style: const TextStyle(fontFamily: 'Poppins', color: Colors.white),
          ),
          elevation: 1,
          centerTitle: true,
          backgroundColor: const Color(0xFFfab400),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              child:
                    IconButton(
                    icon:status==ServerStatus.Online ? const Icon(Icons.check_circle, color: Color(0xff9aac000) ):Icon(Icons.offline_bolt, color: Colors.red[400]),
            
                    onPressed: () {
                      alertConfirm(
                       context,
                     status==ServerStatus.Online ? 'Disconnect?' :'Connect?',
                     status==ServerStatus.Online ? 'You will not be able to send or receive messages ':'You will be able to send or receive messages',
                       (() {
                         status==ServerStatus.Online ?   socketService.disconnect():socketService.connect();
                        Navigator.of (context, rootNavigator: true).pop ();
                       }),
                        );
                      
                    },

                    )
            )
          ],
        ),
        drawer: Drawer(
            backgroundColor: const Color(0xFFfab400),
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: ListView(children: [
                ListTile(
                  title: const Text('Settings',
                      style: TextStyle(fontFamily: 'Poppins')),
                  trailing: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pushNamed(context, 'profile');
                  },
                ),
                ListTile(
                  title: const Text(
                    'Log out',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  trailing: const Icon(Icons.exit_to_app),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'login');
                    socketService.disconnect();
                    AuthService.deleteToken();
                  },
                ),
                ListTile(
                  title: const Text(
                    'Add new friends',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  trailing: const Icon(Icons.search),
                  onTap: () {
                   Navigator.pushNamed(context, 'search-friends');

                  },
                ),
                ListTile(
                  title: const Text(
                    'Friends request',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  trailing: const Icon(Icons.people),
                  onTap: () {
                    Navigator.pushNamed(context, 'friends-request');
                  },
                )
              ]),
            )),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          header: const WaterDropHeader(
            complete: Icon(Icons.check, color: Color(0xFFfab400)),
            refresh: CircularProgressIndicator(color: Color(0xFFfab400)),
            waterDropColor: Color(0xFFfab400),
          ),
          onRefresh: _chargeUsers,
          child: usersDB.isEmpty && !_noFriends
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF4040)))
              :
              (
                !_noFriends?
                _listViewUsers()
                :
                const Flexible(child: Center(child: Text('Add friends to start chatting',style: TextStyle(fontFamily: 'Poppins'),),))) 
        ));
  }

  ListView _listViewUsers() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(usersDB[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: usersDB.length);
  }

  ListTile _userListTile(User user) {
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
        decoration: BoxDecoration(
            color: user.online ? const Color(0xff9aac000) : Colors.red[400],
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: (() {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userfriend = user;
        Navigator.pushNamed(context, 'chat');
      }),
    );
  }


_chargeUsers() async {
 final authService = Provider.of<AuthService>(context, listen: false);
  final currentUser =  authService.user;
  if (currentUser.friends.isNotEmpty){
final friendsIds = currentUser.friends
  .where((friend) => friend['status'] == 'confirmed')
  .map((friend) => friend['_id'])
  .toList();
  final allUsers = await userService.getUsers();
  final friends = allUsers.where((user) => friendsIds.contains(user.uid)).toList();
  setState(() {
    usersDB = friends;
  });

  }else{
    setState(() {
       usersDB=[];
   _noFriends=true;
    });
  
  };
    
  
 
  

  _refreshController.refreshCompleted();
}

}
