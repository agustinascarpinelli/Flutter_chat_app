import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

showAlert(BuildContext context, String title, String subtitle, Icon icon) {
  if (Platform.isAndroid) {
  return  showDialog(
      context: context,
      builder: (_) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        actionsOverflowAlignment: OverflowBarAlignment.center,
        iconColor: const Color(0xFFFCCE73),
        backgroundColor: const Color(0xFFFA6450),
        icon: icon,
        title: Text(
          title,
          style: const TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        content: Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        actions: [
          Center(
            child: MaterialButton(
              color: const Color(0xFFFCCE73),
              onPressed: () => Navigator.pop(context),
              textColor: Colors.white,
              elevation: 5,
              child: const Text(
                'Ok',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          )
        ],
      ),
    );
  }
  showCupertinoDialog(
    context: context,
     builder: (_)=>CupertinoAlertDialog(
       title: Text(
          title,
          style: const TextStyle(fontFamily: 'Poppins',color:  Color(0xFFFA6450),),
        ),
        content: Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Poppins',color:  Color(0xFFFA6450),),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text(
                'Ok',
                style: TextStyle(fontFamily: 'Poppins',color: Color(0xFFFA6450),),
              ),
              onPressed: () => Navigator.pop(context),
     )],
      )
     
     
     );
}
