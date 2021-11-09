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

  List<House>? _findItem;
  @override
  initState() {
    super.initState();
    getAllHouses();
    _findItem = _houseList;
  }

  void _searchHouse(String text) {
    List<House> results = [];
    if (text.isEmpty) {
      results = _houseList!;
    } else {
      results = _houseList!
          .where(
              (item) => item.name!.toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
    setState(() {
      _findItem = results;
    });
  }

  // Show furniture details by id
  void _showDetails(int? id) {
    if (id == null) {
      return;
    }
    var house = _houseList!.firstWhere((house) => house.id == id);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('House Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name: ${house.name}'),
                Text('Description: ${house.description}'),
                Text('Price: ${house.price}'),
                Text('Address: ${house.address}'),
                Text('City: ${house.city}'),
                Text('Bedroom Type: ${house.bedroom_type}'),
                Text('Furniture Type: ${house.furniture_type}'),
                Text('Room Type: ${house.room_type}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // message delete successfully
  void _showDeleteMessage(int? id) {
    if (id == null) {
      return;
    }
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete House'),
          content: Text('Are you sure you want to delete this house?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  _houseService!.deleteHouse(id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('House deleted'),
                  ));
                  // remove the deleted item from the list
                  _findItem!.removeWhere((item) => item.id == id);
                  getAllHouses();
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Home',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Search bar
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                onChanged: (text) {
                  _searchHouse(text);
                },
                decoration: InputDecoration(
                  hintText: 'Search Bedroom',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
      ),
      // show card message if no house found
      body: _houseList!.isEmpty
          ? Center(
              child: Text('No house found'),
            )
          : ListView.builder(
              itemCount: _findItem?.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.orange[200],
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    title: Text(_findItem?[index].name ?? ''),
                    subtitle: Text(_findItem?[index].description ?? ''),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // _showForm(_findItem?[index].id);
                              print("edit");
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _showDeleteMessage(_findItem?[index].id);
                            },
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      _showDetails(_findItem?[index].id);
                    },
                  ),
                );
              },
            ),
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
