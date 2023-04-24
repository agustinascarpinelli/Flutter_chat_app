import 'package:flutter/material.dart';
class Labels extends StatelessWidget {
  final String route;
  final String text;
  const Labels({super.key, required this.route, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
          GestureDetector(
            child: Text(text,style: TextStyle(color:Colors.grey,fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins')),
            onTap: (){
              Navigator.pushReplacementNamed(context,route);
            },
            )
      ],
    );
  }
}