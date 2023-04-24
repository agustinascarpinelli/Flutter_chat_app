import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/change_profile_page.dart';
import 'package:flutter_chat_app/pages/chat_page.dart';
import 'package:flutter_chat_app/pages/friend_page.dart';
import 'package:flutter_chat_app/pages/friends_request_page.dart';
import 'package:flutter_chat_app/pages/loading_page.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/pages/profile_page.dart';
import 'package:flutter_chat_app/pages/register_page.dart';
import 'package:flutter_chat_app/pages/search_friends_page.dart';
import 'package:flutter_chat_app/pages/users_page.dart';
import '../pages/search_messages.dart';



final Map<String,Widget Function(BuildContext)> appRoutes={
'users':(_)=>const UsersScreen(),
'chat':(_)=>const ChatScreen(),
'login':(_)=>const LoginScreen(),
'register':(_)=>const RegisterScreen(),
'loading':(_)=>const LoadingScreen(),
'friend':(_)=>const FriendScreen(),
'profile':(_)=>const ProfileScreen(),
'change-profile':(_)=>const ChangeProfileScreen(),
'search-friends':(_)=>const SearchFriendScreen(),
'friends-request':(_)=>const FriendsRequestsScreen(),
'search-messages':(_)=>const SearchMessagesScreen()

};