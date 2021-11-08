// ignore_for_file: prefer_const_constructors

import 'package:rental_z/screens/bedroom.dart';
import 'package:rental_z/screens/furniture_type.dart';
import 'package:rental_z/screens/home.dart';
import 'package:rental_z/screens/room_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
              accountName: Text('Nguyen Duc Cuong'),
              accountEmail: Text('cuongndgch18641@fpt.edu.vn'),
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.hotel),
              title: Text('Bedroom types'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BedroomScreen())),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Funiture Types'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FurnitureScreen())),
            ),
            ListTile(
              leading: Icon(Icons.room_service),
              title: Text('Room Types'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => RoomScreen())),
            )
          ],
        ),
      ),
    );
  }
}
