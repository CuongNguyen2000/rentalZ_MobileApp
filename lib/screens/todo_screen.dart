import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_z/Utils/utility.dart';
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
  File? image;

  final _houseNameController = TextEditingController();
  final _houseNoteController = TextEditingController();
  final _housePriceController = TextEditingController();
  final _houseAddressController = TextEditingController();
  final _houseReporterController = TextEditingController();

  dynamic _pickImageError;

  final _houseService = HouseService();
  final _house = House();

  var _selectedRoom;
  var _selectedBedroom;
  var _selectedFurniture;

  final _rooms = <DropdownMenuItem>[];
  final _bedrooms = <DropdownMenuItem>[];
  final _furnitures = <DropdownMenuItem>[];

  // global formKey
  final _formKey = GlobalKey<FormState>();

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
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.file(
                  image!,
                  height: 200,
                  width: 200,
                ),
                Text(
                  'House Reporter: ${_houseReporterController.text}',
                  style: const TextStyle(color: Colors.red),
                ),
                Text('House Name: ${_houseNameController.text}'),
                Text('House Price: ${_housePriceController.text}/month'),
                Text('House Address: ${_houseAddressController.text}'),
                Text('Room: ${_selectedRoom}'),
                Text('Bedroom: ${_selectedBedroom}'),
                Text('Furniture: ${_selectedFurniture}'),
                Text(
                  'Note: ${_houseNoteController.text.isEmpty ? 'NO NOTE' : _houseNoteController.text}',
                  style: TextStyle(
                    color: Colors.red[300],
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Text('Note: ${_houseNoteController.text}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                _house.reporter = _houseReporterController.text;
                _house.name = _houseNameController.text;
                _house.note = _houseNoteController.text;
                _house.price = int.parse(_housePriceController.text);
                _house.address = _houseAddressController.text;
                _house.note = _houseNoteController.text;
                _house.bedroom_type = _selectedBedroom;
                _house.furniture_type = _selectedFurniture;
                _house.room_type = _selectedRoom;
                _house.image = await Utility.convertImageToBase64(image);
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
          ],
        );
      },
    );
  }

  bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return int.tryParse(value) != null;
  }

  Future _onImageButtonPressed(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Add House'),
      ),
      // return card to add house, avoid overflow of the page
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                // return a text form field to enter the name of reporter with validation of the input field with border radius and icon user in the left
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    controller: _houseReporterController,
                    decoration: InputDecoration(
                      labelText: 'House Reporter',
                      icon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the reporter name';
                      }
                      return null;
                    },
                  ),
                ),
                // return a text form field to enter the name of house with validation of the input field with border radius and icon home in the left
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    controller: _houseNameController,
                    decoration: InputDecoration(
                      labelText: 'House Name',
                      icon: Icon(Icons.home),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the house name';
                      }
                      return null;
                    },
                  ),
                ),
                // return a text form field to enter the price of house with validation of the input field with border radius and icon attach money in the left
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    controller: _housePriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'House Price',
                      icon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the house price';
                      }
                      if (!isNumeric(value)) {
                        return 'Please enter the house price in number';
                      }
                      return null;
                    },
                  ),
                ),
                // return a text form field to enter the address of house with validation of the input field with border radius and icon map in the left
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    controller: _houseAddressController,
                    decoration: InputDecoration(
                      labelText: 'House Address',
                      icon: Icon(Icons.map),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the house address';
                      }
                      return null;
                    },
                  ),
                ),
                // return a dropdown menu to select the room of the house with validation of the input field with border radius and icon room in the left
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DropdownButtonFormField<dynamic>(
                    value: _selectedRoom,
                    items: _rooms,
                    onChanged: (value) {
                      setState(() {
                        _selectedRoom = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Room',
                      icon: Icon(Icons.room_service),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a room';
                      }
                      return null;
                    },
                  ),
                ),
                // return a dropdown menu to select the bedroom of the house with validation of the input field with border radius and icon hotel in the left
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DropdownButtonFormField<dynamic>(
                    value: _selectedBedroom,
                    items: _bedrooms,
                    onChanged: (value) {
                      setState(() {
                        _selectedBedroom = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Bedroom',
                      icon: Icon(Icons.hotel),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a bedroom';
                      }
                      return null;
                    },
                  ),
                ),
                // return a dropdown menu to select the furniture of the house with validation of the input field with border radius and icon chair in the left
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DropdownButtonFormField<dynamic>(
                    value: _selectedFurniture,
                    items: _furnitures,
                    onChanged: (value) {
                      setState(() {
                        _selectedFurniture = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Furniture',
                      icon: Icon(Icons.chair),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a furniture';
                      }
                      return null;
                    },
                  ),
                ),
                // select images from gallery to upload
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            _onImageButtonPressed(
                              ImageSource.gallery,
                            );
                          },
                          child: const Text('Select Image'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            _onImageButtonPressed(
                              ImageSource.camera,
                            );
                          },
                          child: const Text('Take Image'),
                        ),
                      ),
                    ),
                  ],
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        image != null
                            ? Container(
                                width: double.infinity,
                                height: 200,
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ))
                            : Container(),
                        image != null
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    image = null;
                                  });
                                },
                                child: const Text('Delete'),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                // return a card with color with text form field to enter the note of the house
                Card(
                  color: Colors.orange[200],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _houseNoteController,
                      decoration: const InputDecoration(
                        labelText: 'Note',
                        hintText: 'Enter some note',
                      ),
                      maxLines: 3,
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text('Add House'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (image == null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Image is not null'),
                              content: Text('Please select an image'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        _showConfirmDialog(context);
                      }
                    }
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
