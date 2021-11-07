import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_z/helpers/drawer_navigation.dart';

class FunitureScreen extends StatefulWidget {
  const FunitureScreen({Key? key}) : super(key: key);

  @override
  _FunitureScreenState createState() => _FunitureScreenState();
}

class _FunitureScreenState extends State<FunitureScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Funiture'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'FunitureScreen',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      drawer: DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
        onPressed: () => print("FunitureScreen"),
      ),
    );
  }
}