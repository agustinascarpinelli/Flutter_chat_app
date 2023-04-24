import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/global/environment.dart';
import 'package:flutter_chat_app/models/error_message_response.dart';
import 'package:flutter_chat_app/models/errors.dart';
import 'package:flutter_chat_app/models/login_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService with ChangeNotifier {
  late User user;
  bool _isAuth = false;

  //Storage para el token
  final _storage = FlutterSecureStorage();

  ///Getters y setters

  bool get auth => _isAuth;
  set auth(bool value) {
    _isAuth = value;
    notifyListeners();
  }

//Getters y setters especiales, estaticos para poder acceder al token desde otros lugares de la aplicacion sin la necesidad de tener que instanciar el provider
//Acceder al token de manera estatica
  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token!;
  }

//Borrar el token de manera estatica
  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    return _storage.delete(key: 'token');
  }

//Login
  Future login(String email, String password) async {
    auth = true;

    final data = {'email': email, 'password': password};

    final uri = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      auth = false;
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;
      _saveToken(loginResponse.token);
      return true;
    } else {
      auth = false;
      return false;
    }
  }

//Registro

  Future register(
      String email, String name, String password, String confirmPass) async {
    auth = true;

    final data = {
      'email': email,
      'name': name,
      'password': password,
      'passwordConfirmation': confirmPass,
    };

    final uri = Uri.parse('${Environment.apiUrl}/login/new');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      auth = false;
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;

      _saveToken(loginResponse.token);
      return ErrorMessage("", true);
    } else {
      final Map<String, dynamic> respBody = jsonDecode(resp.body);
      final error = ErrorsResponse.fromJson(respBody);

      auth = false;

      if (error.errors.email != null) {
        return ErrorMessage(error.errors.email!.msg, false);
      } else if (error.errors.password != null) {
        return ErrorMessage(error.errors.password!.msg, false);
      } else if (error.errors.passwordConfirmation != null) {
        return ErrorMessage(error.errors.passwordConfirmation!.msg, false);
      } else if (error.errors.error != "") {
        return ErrorMessage(error.errors.error ?? "", false);
      }
    }
  }

//Guardar token

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  //Verificar token
  Future <ErrorMessage> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final uri = Uri.parse('${Environment.apiUrl}/login/renew');
    
    final resp = await http.get(uri, 
    headers:
     {
      'Content-Type': 'application/json',
      'x-token':token?? '123'
     
     });
     

    
    if (resp.statusCode == 200) {
      auth = false;
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;
      _saveToken(loginResponse.token);
      return ErrorMessage("", true);
    
    } else {
      _logout();
      return ErrorMessage("Not authorize", false);
    }
  }

//Borrar token al hacer logout
  Future _logout() async {
    await _storage.delete(key: 'token');
  }


  Future changeUser(name,email)async{
       
    final data = {'name':name, 'email': email};

    final uri = Uri.parse('${Environment.apiUrl}/login/change');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json',
         'x-token':await getToken()});

    if (resp.statusCode == 200) {
      auth = false;
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;
      return ErrorMessage('',true);
    } else {
      
      final Map<String, dynamic> respBody = jsonDecode(resp.body);
      final error = ErrorsResponse.fromJson(respBody);
      if (error.errors.email != null) {
        return ErrorMessage(error.errors.email!.msg, false);
      }else{
        return ErrorMessage('Error.Try again later', false);
      }
      
    }
  }
}
