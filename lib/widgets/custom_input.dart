import 'package:flutter/material.dart';
class CustomInput extends StatelessWidget {

  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;



  const CustomInput({super.key,
   required this.icon,
   required this.placeholder,
   required this.textController,
 this.keyboardType=TextInputType.text,
 this.isPassword=false});

  @override
  Widget build(BuildContext context) {
    return    Container(
      margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.only(top:5,left: 5,bottom: 5,right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0,5),
                blurRadius: 5
              )


            ]
          ),
          child: TextField(
            style: TextStyle(fontFamily: 'Poppins'),
            controller: textController,
            autocorrect: false,
            obscureText:isPassword? true : false,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon,color: const Color(0xFFFA6450),),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: placeholder,
              hintStyle: const TextStyle(color: Colors.grey,fontFamily: 'Poppins')
            ),
          ),
         );
  }
}