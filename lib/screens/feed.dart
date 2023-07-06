import 'package:flutter/material.dart';

class UserFeed extends StatelessWidget {
  const UserFeed({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Oops... Looks like you don\'t follow anyone',
        style: TextStyle(
            fontSize: 24,
            fontWeight:
            FontWeight.w800),
        textAlign: TextAlign.center,
      ),
    );
  }
}