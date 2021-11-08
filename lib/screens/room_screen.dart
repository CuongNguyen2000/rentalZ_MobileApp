import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_z/helpers/drawer_navigation.dart';
import 'package:rental_z/models/room.dart';
import 'package:rental_z/services/room_service.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({Key? key}) : super(key: key);

  @override
  _RoomScreennState createState() => _RoomScreennState();
}

class _RoomScreennState extends State<RoomScreen> {
  // ignore: unused_field
  final _roomNameController = TextEditingController();
  final _roomDescriptionController = TextEditingController();

  final _room = Room();
  final _roomService = RoomService();

  // ignore: non_constant_identifier_names
  List<Room> _RoomList = <Room>[];

  final _editRoomNameController = TextEditingController();
  final _editRoomDescriptionController = TextEditingController();

  bool _isLoading = false;

  getAllRooms() async {
    _RoomList = [];
    var rooms = await _roomService.getAllRooms();
    rooms.forEach((bedroom) {
      setState(() {
        var roomModel = Room();
        roomModel.id = bedroom['id'];
        roomModel.name = bedroom['name'];
        roomModel.description = bedroom['description'];
        _RoomList.add(roomModel);
        _isLoading = false;
      });
    });
    // ignore: avoid_print
    print(rooms);
  }

  void initState() {
    super.initState();
    getAllRooms();
  }

  void _showForm(int? id) async {
    if (id == null) {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Room'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _roomNameController,
                  decoration: InputDecoration(
                    labelText: 'Room Name',
                  ),
                  autofocus: true,
                ),
                TextField(
                  controller: _roomDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Room Description',
                  ),
                  autofocus: true,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Submit'),
                onPressed: () async {
                  if (_roomNameController.text.isEmpty) {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('Room Name is required'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (_roomDescriptionController.text.isEmpty) {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('Room Description is required'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    setState(() {
                      _isLoading = true;
                    });
                    _room.name = _roomNameController.text;
                    _room.description = _roomDescriptionController.text;
                    var result = await _roomService.insertRoom(_room);
                    Navigator.pop(context);
                    getAllRooms();
                  }
                },
              ),
            ],
          );
        },
      );
    } else {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Room'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _editRoomNameController,
                  decoration: InputDecoration(
                    labelText: _RoomList.firstWhere(
                      (room) => room.id == id,
                    ).name,
                  ),
                ),
                TextField(
                  controller: _editRoomDescriptionController,
                  decoration: InputDecoration(
                    labelText: _RoomList.firstWhere(
                      (room) => room.id == id,
                    ).description,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  //update bedroom by id
                  setState(() {
                    _room.id = id;
                    _room.name = _editRoomNameController.text;
                    _room.description = _editRoomDescriptionController.text;
                    _roomService.updateRoom(_room);
                    getAllRooms();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Show room details by id
  void _showDetails(int? id) {
    if (id == null) {
      return;
    }
    var room = _RoomList.firstWhere((room) => room.id == id);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Room Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name: ${room.name}'),
                Text('Description: ${room.description}'),
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
          title: const Text('Delete Room'),
          content: Text('Are you sure you want to delete this room?'),
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
                  _roomService.deleteRoom(id);
                  getAllRooms();
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
              'Rooms',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Search bar
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                onChanged: (text) {},
                decoration: InputDecoration(
                  hintText: 'Search room',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
      ),
      // show card message if no bedroom found
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _RoomList.length == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'No Rooms Found',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _RoomList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.orange[200],
                      margin: const EdgeInsets.all(15),
                      child: ListTile(
                        title: Text(_RoomList[index].name!),
                        subtitle: Text(_RoomList[index].description!),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showForm(_RoomList[index].id);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteMessage(_RoomList[index].id);
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          _showDetails(_RoomList[index].id);
                        },
                      ),
                    );
                  },
                ),
      drawer: DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
        onPressed: () {
          _showForm(null);
        },
      ),
    );
  }
}
