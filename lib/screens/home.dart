import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_z/helpers/drawer_navigation.dart';
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
  final _houseNameController = TextEditingController();
  final _houseDescriptionController = TextEditingController();
  final _housePriceController = TextEditingController();
  final _houseAddressController = TextEditingController();
  final _houseCityController = TextEditingController();

  var _selectedRoom;
  var _selectedBedroom;
  var _selectedFurniture;

  var _rooms = <DropdownMenuItem>[];
  var _bedrooms = <DropdownMenuItem>[];
  var _furnitures = <DropdownMenuItem>[];

  _loadRooms() async {
    var _roomService = RoomService();
    var _rooms = await _roomService.getAllRooms();
    for (var room in _rooms) {
      setState(() {
        _rooms.add(DropdownMenuItem(
          child: Text(room.name),
          value: room.name,
        ));
      });
    }
  }

  _loadBedrooms() async {
    var _bedroomService = BedroomService();
    var _bedrooms = await _bedroomService.getAllBedrooms();
    for (var bedroom in _bedrooms) {
      setState(() {
        _bedrooms.add(DropdownMenuItem(
          child: Text(bedroom.name),
          value: bedroom.name,
        ));
      });
    }
  }

  _loadFurnitures() async {
    var _furnitureService = FurnitureService();
    var _furnitures = await _furnitureService.getAllFurnitures();
    for (var furniture in _furnitures) {
      setState(() {
        _furnitures.add(DropdownMenuItem(
          child: Text(furniture.name),
          value: furniture.name,
        ));
      });
    }
  }

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
        model.funiture_type = house['funiture_type'];
        model.room_type = house['room_type'];
        _houseList!.add(model);
      });
    });
    print(houses);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'HomeScreen',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      drawer: DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
        onPressed: () => print("test"),
      ),
    );
  }
}
