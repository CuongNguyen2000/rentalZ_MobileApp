import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_z/helpers/drawer_navigation.dart';
import 'package:rental_z/screens/todo_screen.dart';
import 'package:rental_z/services/bedroom_service.dart';
import 'package:rental_z/services/house_service.dart';
import 'package:rental_z/services/room_service.dart';
import 'package:rental_z/services/furniture_service.dart';
import 'package:rental_z/screens/home.dart';
import 'package:rental_z/models/house.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  HouseService? _houseService;
  List<House>? _houseList;

  getAllHouses() async {
    _houseService = HouseService();
    _houseList = <House>[];
    var houses = await _houseService!.getAllHouses();
    houses.forEach((house) {
      setState(() {
        var model = House();
        model.id = house['id'];
        model.name = house['name'];
        model.description = house['description'];
        model.price = house['price'];
        model.address = house['address'];
        model.city = house['city'];
        model.bedroom_type = house['bedroom_type'];
        model.furniture_type = house['furniture_type'];
        model.room_type = house['room_type'];
        _houseList!.add(model);
      });
    });
    print(houses);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.orange,
      ),
      // show card message if no house found
      body: _houseList == null
          ? Center(
              child: Text('No house found'),
            )
          : ListView.builder(
              itemCount: _houseList!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_houseList![index].name!),
                    subtitle: Text(_houseList![index].description!),
                  ),
                );
              },
            ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         'HomeScreen',
      //         style: Theme.of(context).textTheme.headline4,
      //       ),
      //     ],
      //   ),
      // ),
      drawer: DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoScreen())),
      ),
    );
  }
}
