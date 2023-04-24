import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

alertConfirm(
  BuildContext context,
    String title,
  String subtitle,
  void Function() function,

) {
  if (Platform.isAndroid) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        actionsOverflowAlignment: OverflowBarAlignment.center,
        iconColor: const Color(0xFFFCCE73),
        backgroundColor: const Color(0xFFFA6450),
        icon: const Icon(Icons.warning),
        title:Text(
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
            child: Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

              MaterialButton(
                color: const Color(0xFFFCCE73),
                onPressed: () => Navigator.pop(context),
                textColor: Colors.white,
                elevation: 5,
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
              SizedBox(width: 40,),
              MaterialButton(
                color: const Color(0xFFFCCE73),
                onPressed: function,
                textColor: Colors.white,
                elevation: 5,
                child: const Text(
                  'Ok',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
  showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
            title: Text(
             title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFFFA6450),
              ),
            ),
            content: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFFFA6450),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFFFA6450),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: function,
                  child: const Text(
                    'Ok',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFFFA6450),
                    ),
                  ))
            ],
          ));
}
 