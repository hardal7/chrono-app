import '../style.dart';
import 'package:flutter/material.dart';

import '../widgets/settings.dart';
import '../widgets/auth.dart';

class UsersSettingsPage extends StatelessWidget {
  const UsersSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Userspage');
  }
}

class Userspage extends StatelessWidget {
  const Userspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: Column(
        children: [
          InputField(fieldName: 'Search Username'),
          Row(
            children: [ElevatedButton(
                onPressed: ,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: foregroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fixedSize: Size(120, 35.0),
                ),
                child: Text(
                  'Friends',
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ), 
                ,   ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  Text(
                    'rank', 
                    style: TextStyle(
                     color: foregroundColor,
                     fontWeight: FontWeight.w500,
                     fontSize: 20,
                     ),
                    ), 
                     
                ,]),
                Standing(), 
                
        ],
      ),
    );
    


  }
}

class Standing extends StatelessWidget {
  const Standing({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      Text(
        '1', 
        style: TextStyle(
         color: foregroundColor,
         fontWeight: FontWeight.w500,
         fontSize: 10,
         ),
        ),
      
      Row(
        children: [
          ClipOval( 
            child: Image.file('assets/icons/google.png') 
            height: 100.0,
            width: 100.0,
            fit:BoxFit.cover,
        ),
          Text(
            'username', 
            style: TextStyle(
             color: foregroundColor,
             fontWeight: FontWeight.w500,
             fontSize: 10,
             ),
            ),
        ],
      ),
      Text(
        '1107:32', 
        style: TextStyle(
         color: foregroundColor,
         fontWeight: FontWeight.w500,
         fontSize: 10,
         ),
        ),
    
    
      ],
    );
  }
}
