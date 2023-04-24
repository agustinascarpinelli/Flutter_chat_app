import 'package:flutter/material.dart';
class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Image(
              image: AssetImage('assets/chat.png')
              ),
              const SizedBox(height: 20,),
              const Text('Messenger',style: TextStyle(fontSize: 30,color: Color(0xFFFA6450),fontFamily: 'Poppins'),)
          ],
        ),

      ),
    );
  }
}