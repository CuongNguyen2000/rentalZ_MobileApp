import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_z/services/bedroom_service.dart';
import 'package:rental_z/services/house_service.dart';
import 'package:rental_z/services/room_service.dart';
import 'package:rental_z/services/furniture_service.dart';
import 'package:rental_z/screens/home.dart';
import 'package:rental_z/models/house.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _houseNameController = TextEditingController();
  final _houseDescriptionController = TextEditingController();
  final _housePriceController = TextEditingController();
  final _houseAddressController = TextEditingController();
  final _houseCityController = TextEditingController();

  final _houseService = HouseService();
  final _house = House();

  var _selectedRoom;
  var _selectedBedroom;
  var _selectedFurniture;

  final _rooms = <DropdownMenuItem>[];
  final _bedrooms = <DropdownMenuItem>[];
  final _furnitures = <DropdownMenuItem>[];

  _loadRooms() async {
    var _roomService = RoomService();
    var rooms = await _roomService.getAllRooms();
    rooms.forEach((room) {
      setState(() {
        _rooms.add(DropdownMenuItem(
          child: Text(room['name']),
          value: room['name'],
        ));
      });
    });
  }

  _loadBedrooms() async {
    var _bedroomService = BedroomService();
    var bedrooms = await _bedroomService.getAllBedrooms();
    bedrooms.forEach((bedroom) {
      setState(() {
        _bedrooms.add(DropdownMenuItem(
          child: Text(bedroom['name']),
          value: bedroom['name'],
        ));
      });
    });
  }

  _loadFurnitures() async {
    var _furnitureService = FurnitureService();
    var furnitures = await _furnitureService.getAllFurnitures();
    furnitures.forEach((furniture) {
      setState(() {
        _furnitures.add(DropdownMenuItem(
          child: Text(furniture['name']),
          value: furniture['name'],
        ));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRooms();
    _loadBedrooms();
    _loadFurnitures();
  }

  @override
  Widget build(BuildContext context) {
    // return a headings of the page
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Add House'),
      ),
      // return card to add house
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _houseNameController,
                decoration: InputDecoration(
                  labelText: 'House Name',
                ),
              ),
              TextField(
                controller: _houseDescriptionController,
                decoration: InputDecoration(
                  labelText: 'House Description',
                ),
              ),
              TextField(
                controller: _housePriceController,
                decoration: InputDecoration(
                  labelText: 'House Price',
                ),
              ),
              TextField(
                controller: _houseAddressController,
                decoration: InputDecoration(
                  labelText: 'House Address',
                ),
              ),
              TextField(
                controller: _houseCityController,
                decoration: InputDecoration(
                  labelText: 'House City',
                ),
              ),
              DropdownButtonFormField<dynamic>(
                value: _selectedRoom,
                items: _rooms,
                hint: Text('Select Room'),
                onChanged: (value) {
                  setState(() {
                    _selectedRoom = value;
                  });
                },
              ),
              DropdownButtonFormField<dynamic>(
                value: _selectedBedroom,
                items: _bedrooms,
                hint: Text('Select Bedroom'),
                onChanged: (value) {
                  setState(() {
                    _selectedBedroom = value;
                  });
                },
              ),
              DropdownButtonFormField<dynamic>(
                value: _selectedFurniture,
                items: _furnitures,
                hint: Text('Select Furniture'),
                onChanged: (value) {
                  setState(() {
                    _selectedFurniture = value;
                  });
                },
              ),
              // ElevatedButton to add house
              ElevatedButton(
                child: Text('Add House'),
                onPressed: () async {
                  _house.name = _houseNameController.text;
                  _house.description = _houseDescriptionController.text;
                  _house.price = _housePriceController.text as int?;
                  _house.address = _houseAddressController.text;
                  _house.city = _houseCityController.text;
                  _house.bedroom_type = _selectedBedroom;
                  _house.furniture_type = _selectedFurniture;
                  _house.room_type = _selectedRoom;
                  var result = await _houseService.insertHouse(_house);
                  if (result > 0) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
