import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';
import 'package:rental_z/helpers/drawer_navigation.dart';
import 'package:rental_z/screens/todo_screen.dart';
import 'package:rental_z/services/bedroom_service.dart';
import 'package:rental_z/services/furniture_service.dart';
import 'package:rental_z/services/house_service.dart';
import 'package:rental_z/models/house.dart';
import 'package:rental_z/services/room_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _houseNameController = TextEditingController();
  final TextEditingController _houseNoteController = TextEditingController();
  final TextEditingController _housePriceController = TextEditingController();
  final TextEditingController _houseAddressController = TextEditingController();
  final TextEditingController _houseReporterController =
      TextEditingController();

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
        model.note = house['note'];
        model.reporter = house['reporter'];
        model.note = house['note'];
        model.price = house['price'];
        model.address = house['address'];
        model.bedroom_type = house['bedroom_type'];
        model.furniture_type = house['furniture_type'];
        model.room_type = house['room_type'];
        model.createdAt = house['created_at'];
        model.updatedAt = house['updated_at'];
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
    _loadRooms();
    _loadBedrooms();
    _loadFurnitures();
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
                Text(
                  'Reporter: ${house.reporter}',
                  // text color and font bold
                  style: TextStyle(
                    color: Colors.red[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Name: ${house.name}'),
                Text('Description: ${house.note}'),
                Text('Price: ${house.price}/month'),
                Text('Address: ${house.address}'),
                Text('Bedroom Type: ${house.bedroom_type}'),
                Text('Furniture Type: ${house.furniture_type}'),
                Text('Room Type: ${house.room_type}'),
                Text(
                  'Created at: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(house.createdAt!))}',
                ),
                Text(
                  'Last modified at: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(house.updatedAt!))}',
                ),
                Text(
                  'Note: ${house.note!.isEmpty ? 'NO NOTE' : house.note}',
                  style: TextStyle(
                    color: Colors.red[300],
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    content: Text('Successfully deleted a house!'),
                  ));
                  _findItem!.removeWhere((item) => item.id == id);
                  getAllHouses();
                  Navigator.pop(context);
                  FlutterRingtonePlayer.playNotification();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateHouse(int id) async {
    await _houseService!.updateHouse(
      id,
      _houseNameController.text,
      _houseAddressController.text,
      _houseReporterController.text,
      int.parse(_housePriceController.text),
      _houseNoteController.text,
      _selectedRoom,
      _selectedBedroom,
      _selectedFurniture,
    );
  }

  // this form is use to update the house information by id
  void _showUpdateForm(int? id) {
    if (id == null) {
      return;
    }
    var house = _findItem!.firstWhere((house) => house.id == id);
    // assign values controller to the form fields  and set the value of the fields
    _houseReporterController.text = house.reporter!;
    _houseNameController.text = house.name!;
    _houseNoteController.text = house.note!;
    _housePriceController.text = house.price!.toString();
    _houseAddressController.text = house.address!;
    _selectedBedroom = house.bedroom_type;
    _selectedFurniture = house.furniture_type;
    _selectedRoom = house.room_type;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update House'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _houseReporterController,
                  decoration: InputDecoration(
                    labelText: 'Reporter',
                    hintText: 'Enter name of reporter',
                  ),
                ),
                TextFormField(
                  controller: _houseNameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter name of house',
                  ),
                ),
                TextFormField(
                  controller: _housePriceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: 'Enter price of house',
                  ),
                ),
                TextFormField(
                  controller: _houseAddressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter address of house',
                  ),
                ),
                DropdownButtonFormField<dynamic>(
                  value: _selectedBedroom,
                  items: _bedrooms,
                  decoration: InputDecoration(
                    labelText: 'Select Bedroom',
                    hintText: 'Select bedroom type',
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedBedroom = newValue;
                    });
                  },
                ),
                DropdownButtonFormField<dynamic>(
                  value: _selectedFurniture,
                  items: _furnitures,
                  decoration: InputDecoration(
                    labelText: 'Select Furniture',
                    hintText: 'Select furniture type',
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedFurniture = newValue;
                    });
                  },
                ),
                DropdownButtonFormField<dynamic>(
                  value: _selectedRoom,
                  items: _rooms,
                  decoration: InputDecoration(
                    labelText: 'Select Room',
                    hintText: 'Select room type',
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRoom = newValue;
                    });
                  },
                ),
                Card(
                  color: Colors.orange[200],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _houseNoteController,
                      decoration: const InputDecoration(
                        labelText: 'Note',
                        hintText: 'Enter note of house',
                      ),
                      maxLines: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                setState(() {
                  _updateHouse(id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Successfully updated a house!'),
                  ));
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
            const Text(
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
                decoration: const InputDecoration(
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
      body: _findItem!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'No House found',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            )
          // Show list of house into grid view set the number of column  and number of row in grid view
          : GridView.count(
              crossAxisCount: 1,
              children: _findItem!.map((house) {
                return Card(
                  color: Colors.orange[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  // margin
                  margin: const EdgeInsets.all(15),
                  // resize card to fit the screen  and set the padding of card to 10 and set the margin of card to 10  and set the height of card to 200 and set the width of card to 200  and set the child of card to a list of widgets
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // tap to view the house detail
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _showDetails(house.id);
                          },
                          // container to show the image of house set radius of container to 20 and show the image of house
                          child: Container(
                            height: 200,
                            width: 340,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://picsum.photos/250?image=9',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Name: ${house.name!}',
                            // color text to attach to the card
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Price: ${house.price} / month',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                'Location: ${house.address}',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          ),
                          trailing: Text(
                            '${DateFormat('dd-MM-yyyy').format(DateTime.parse(house.updatedAt!))}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateForm(house.id);
                                },
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteMessage(house.id);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // child: InkWell(
                  //   onTap: () {
                  //     _showDetails(house.id);
                  //   },
                  //   child: Column(
                  //     children: <Widget>[
                  //       ListTile(
                  //         title: Text(
                  //           'Name: ${house.name!}',
                  //           // color text to attach to the card
                  //           style: TextStyle(
                  //             color: Colors.red,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //         subtitle: Text(
                  //           '\$ ${house.price!.toString()} / month',
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 20,
                  //           ),
                  //         ),
                  //       ),
                  //       ListTile(
                  //         title: Text('Address: ${house.address!}'),
                  //         subtitle: Text(
                  //           'Reporter: ${house.reporter!}',
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 20,
                  //           ),
                  //         ),
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         children: <Widget>[
                  //           CircleAvatar(
                  //             backgroundColor: Colors.white,
                  //             child: IconButton(
                  //               icon: Icon(Icons.edit),
                  //               onPressed: () {
                  //                 _showUpdateForm(house.id);
                  //               },
                  //             ),
                  //           ),
                  //           CircleAvatar(
                  //             backgroundColor: Colors.white,
                  //             child: IconButton(
                  //               icon: Icon(Icons.delete),
                  //               onPressed: () {
                  //                 _showDeleteMessage(house.id);
                  //               },
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                );
              }).toList(),
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
