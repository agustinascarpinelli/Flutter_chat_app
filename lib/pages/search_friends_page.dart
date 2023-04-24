import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helpers/alert.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/socket_service.dart';
import '../services/usesrs_service.dart';

class SearchFriendScreen extends StatefulWidget {
  const SearchFriendScreen({super.key});

  @override
  State<SearchFriendScreen> createState() => _SearchFriendScreenState();
}

class _SearchFriendScreenState extends State<SearchFriendScreen> {
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

  void _filterFriends(String query) {
    List<User> results = [];
    if (query.isNotEmpty) {
      for (User user in usersDB) {
        if (user.name.toLowerCase().contains(query.toLowerCase())) {
          results.add(user);
        }
      }
      if (results.isEmpty) {
        results.add(User(
            name: 'No hay resultados',
            uid: '123',
            email: '123',
            online: false,
            friends: []));
      }
    }
    setState(() {
      _searchResult = results;
    });
  }

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
          'Search friends',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        elevation: 1,
        centerTitle: true,
        backgroundColor: const Color(0xFFfab400),
      ),
      body: GestureDetector(
        onTap: (){
          _focusNode.unfocus();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                focusNode: _focusNode,
                cursorColor: Color(0xFFfab400),
                style: const TextStyle(fontFamily: 'Poppins'),
                onChanged: (query) => _filterFriends(query),
                decoration: InputDecoration(
                  hintText: 'Search friends',
                  hintStyle: const TextStyle(fontFamily: 'Poppins'),
                  prefixIcon: const Icon(Icons.search),
      
                  //prefixIconColor: Color(0xFFfab400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFfab400)),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
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
              child: _searchResult.isEmpty
                  ? 
                  (usersDB.isNotEmpty?  _listViewUsers() :  const Flexible(child: Center(child: CircularProgressIndicator(color: Color(0xFFFF4040)))))
                  : ListView.builder(
                      itemCount: _searchResult.length,
                      itemBuilder: (context, index) {
                        final user = _searchResult[index];
                        if (user.name == 'No hay resultados') {
                          return Center(
                              child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.warning,
                                  color: Color(0xFFFF4040),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFFFF4040)),
                                ),
                              ],
                            ),
                          ));
                        } else {
                          return _userListTile(user);
                        }
                      },
                    ),
            )),
          ],
        ),
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
            icon:  Icon(
              Icons.add_box_outlined,
              color: Color(0xFFFF4040),
            ),
            onPressed: () {
             
            },
          ),
          
          ),
          onTap: () {
            
             
              socketService.emit('add friend', {'uid':cuser.uid, 'idFriend': user.uid});
              showAlert(context, 'New friend added', 'You have sent a friend request to ${user.name}', Icon(Icons.check,color: Colors.green[500],));
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
  final nonFriends = allUsers.where((user) => !friendsIds.contains(user.uid)).toList();
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
