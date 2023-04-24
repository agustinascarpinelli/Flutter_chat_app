import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
final String text;
final void Function() ?function;


  const CustomButtom({super.key, required this.text, required this.function});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        elevation: 2,
        highlightElevation: 5,
        color: const Color(0xFFFA6450),
        shape:const StadiumBorder() ,
        onPressed:function,
        child: Container(
          width: double.infinity,
          height: 55,
          child: Center(child: Text(text,style: const TextStyle(color: Colors.white,fontSize:18,fontFamily: 'Poppins' ),)) ,
        )
        ) ;
  }
}