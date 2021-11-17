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
          // singleChileScroll is a custom ScrollBehavior widget.
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // show image here
                image == null
                    ? Text('No image selected.')
                    : Image.file(
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
          // content: Text('Are you sure you want to add this house?'),

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

  // Future<void> _displayPickImageDialog(
  //     BuildContext buildContext,
  //     Future<Null> Function(double? maxWidth, double? maxHeight, int? quality)
  //         param1) {
  //   return showDialog<void>(
  //     context: buildContext,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Pick an image'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               TextButton(
  //                 child: const Text('Take a photo'),
  //                 onPressed: () async {
  //                   await param1(null, null, null);
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //               TextButton(
  //                 child: const Text('Pick from gallery'),
  //                 onPressed: () async {
  //                   await param1(null, null, null);
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //               TextButton(
  //                 child: const Text('Pick from camera'),
  //                 onPressed: () async {
  //                   await param1(null, null, null);
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //               TextButton(
  //                 child: const Text('Pick from camera with custom options'),
  //                 onPressed: () async {
  //                   await param1(640, 480, 100);
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
                // return a text form field to enter the name of reporter with validation of the input field
                TextFormField(
                  controller: _houseReporterController,
                  decoration: const InputDecoration(
                    labelText: 'Name Reporter *',
                    hintText: 'Enter the name of reporter',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name reporter';
                    }
                    return null;
                  },
                ),
                // return a text form field to enter the name of the house with validation of the input field
                TextFormField(
                  controller: _houseNameController,
                  decoration: const InputDecoration(
                    labelText: 'House Name *',
                    hintText: 'Enter the name of house',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                // return a text form field to enter the price of the house with validation of the input field
                TextFormField(
                  controller: _housePriceController,
                  decoration: const InputDecoration(
                    labelText: 'House Price *',
                    hintText: 'Enter the price of house',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (!isNumeric(value)) {
                      return 'Price must be a number';
                    }
                    return null;
                  },
                ),
                // return a text form field to enter the address of the house with validation of the input field
                TextFormField(
                  controller: _houseAddressController,
                  decoration: const InputDecoration(
                    labelText: 'House Address *',
                    hintText: 'Enter the address of house',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
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
                    labelText: 'Select Room *',
                    hintText: 'Select the room of house',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a room';
                    }
                    return null;
                  },
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
                    labelText: 'Select Bedroom *',
                    hintText: 'Select the bedroom of house',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a bedroom';
                    }
                    return null;
                  },
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
                    hintText: 'Select the furniture of house',
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
                // return a card to show image selected preview
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        // return a image to show preview image
                        image != null
                            ? Image.file(
                                image!,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                        // return a button to delete image
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
                // ElevatedButton(
                //   child: Text('Add House'),
                //   onPressed: () async {
                //     if (_houseNameController.text.isEmpty ||
                //         _houseReporterController.text.isEmpty ||
                //         _housePriceController.text.isEmpty ||
                //         _houseAddressController.text.isEmpty ||
                //         _selectedRoom == null ||
                //         _selectedBedroom == null ||
                //         _selectedFurniture == null) {
                //       return showDialog(
                //         context: context,
                //         builder: (context) {
                //           return AlertDialog(
                //             title: const Text('Error'),
                //             content: const Text('Please fill all the fields'),
                //             actions: <Widget>[
                //               TextButton(
                //                 child: const Text('Ok'),
                //                 onPressed: () {
                //                   Navigator.of(context).pop();
                //                 },
                //               ),
                //             ],
                //           );
                //         },
                //       );
                //     }
                //     if (int.tryParse(_housePriceController.text) == null) {
                //       return showDialog(
                //         context: context,
                //         builder: (context) {
                //           return AlertDialog(
                //             title: const Text('Error'),
                //             content: const Text('Please enter a valid price'),
                //             actions: <Widget>[
                //               TextButton(
                //                 child: const Text('Ok'),
                //                 onPressed: () {
                //                   Navigator.of(context).pop();
                //                 },
                //               ),
                //             ],
                //           );
                //         },
                //       );
                //     }

                //     _showConfirmDialog(context);
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
