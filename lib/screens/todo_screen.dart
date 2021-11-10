import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_z/services/bedroom_service.dart';
import 'package:rental_z/services/house_service.dart';
import 'package:rental_z/services/room_service.dart';
import 'package:rental_z/services/furniture_service.dart';
import 'package:rental_z/screens/home.dart';
import 'package:rental_z/models/house.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key, int? house}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _houseNameController = TextEditingController();
  final _houseDescriptionController = TextEditingController();
  final _housePriceController = TextEditingController();
  final _houseAddressController = TextEditingController();
  final _houseCityController = TextEditingController();
  final _houseReporterController = TextEditingController();

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

  void _showConfirmDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to add this house?'),
          // singleChileScroll is a custom ScrollBehavior widget.
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('House Name: ${_houseNameController.text}'),
                Text('House Description: ${_houseDescriptionController.text}'),
                Text('House Price: ${_housePriceController.text}'),
                Text('House Address: ${_houseAddressController.text}'),
                Text('House City: ${_houseCityController.text}'),
                Text('House Reporter: ${_houseReporterController.text}'),
                Text('Room: ${_selectedRoom}'),
                Text('Bedroom: ${_selectedBedroom}'),
                Text('Furniture: ${_selectedFurniture}'),
              ],
            ),
          ),
          // content: Text('Are you sure you want to add this house?'),

          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                _house.reporter = _houseReporterController.text;
                _house.name = _houseNameController.text;
                _house.description = _houseDescriptionController.text;
                _house.price = int.parse(_housePriceController.text);
                _house.address = _houseAddressController.text;
                _house.city = _houseCityController.text;
                _house.bedroom_type = _selectedBedroom;
                _house.furniture_type = _selectedFurniture;
                _house.room_type = _selectedRoom;
                _house.createdAt = DateTime.now().toString();
                _house.updatedAt = DateTime.now().toString();
                await _houseService.insertHouse(_house);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // return a headings of the page
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Add House'),
      ),
      // return card to add house, avoid overflow of the page
      body: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                // return a text form field to enter the name of reporter with validation of the input field
                TextFormField(
                  controller: _houseReporterController,
                  decoration: const InputDecoration(
                    labelText: 'Name Reporter',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name reporter';
                    }
                    return null;
                  },
                ),
                // return a text form field to enter the name of the house with validation of the input field
                TextFormField(
                  controller: _houseNameController,
                  decoration: const InputDecoration(
                    labelText: 'House Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                // return a text form field to enter the description of the house with validation of the input field
                TextFormField(
                  controller: _houseDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'House Description',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                // return a text form field to enter the price of the house with validation of the input field
                TextFormField(
                  controller: _housePriceController,
                  decoration: const InputDecoration(
                    labelText: 'House Price',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                ),
                // return a text form field to enter the address of the house with validation of the input field
                TextFormField(
                  controller: _houseAddressController,
                  decoration: const InputDecoration(
                    labelText: 'House Address',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                // return a text form field to enter the city of the house with validation of the input field
                TextFormField(
                  controller: _houseCityController,
                  decoration: const InputDecoration(
                    labelText: 'House City',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a city';
                    }
                    return null;
                  },
                ),
                // return a dropdown menu to select the room of the house
                DropdownButtonFormField<dynamic>(
                  value: _selectedRoom,
                  items: _rooms,
                  onChanged: (value) {
                    setState(() {
                      _selectedRoom = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Room',
                  ),
                ),
                // return a dropdown menu to select the bedroom of the house
                DropdownButtonFormField<dynamic>(
                  value: _selectedBedroom,
                  items: _bedrooms,
                  onChanged: (value) {
                    setState(() {
                      _selectedBedroom = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Bedroom',
                  ),
                ),
                // return a dropdown menu to select the furniture of the house
                DropdownButtonFormField<dynamic>(
                  value: _selectedFurniture,
                  items: _furnitures,
                  onChanged: (value) {
                    setState(() {
                      _selectedFurniture = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Furniture',
                  ),
                ),
                // return a button to add the house and check validation of the input fields and check if price is not a number and navigate to the home page
                ElevatedButton(
                  child: const Text('Add House'),
                  onPressed: () async {
                    if (_houseNameController.text.isEmpty ||
                        _houseReporterController.text.isEmpty ||
                        _houseDescriptionController.text.isEmpty ||
                        _housePriceController.text.isEmpty ||
                        _houseAddressController.text.isEmpty ||
                        _houseCityController.text.isEmpty ||
                        _selectedRoom == null ||
                        _selectedBedroom == null ||
                        _selectedFurniture == null) {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Please fill all the fields'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    if (int.tryParse(_housePriceController.text) == null) {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Please enter a valid price'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }

                    _showConfirmDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
