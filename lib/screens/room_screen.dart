import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomDescriptionController =
      TextEditingController();

  final _room = Room();
  final _roomService = RoomService();

  // ignore: non_constant_identifier_names
  List<Room> _RoomList = [];
  List<Room>? _findItems;

  bool _isLoading = true;

  getAllRooms() async {
    _RoomList = [];
    var rooms = await _roomService.getAllRooms();
    rooms.forEach((bedroom) {
      setState(() {
        var roomModel = Room();
        roomModel.id = bedroom['id'];
        roomModel.name = bedroom['name'];
        roomModel.description = bedroom['description'];
        roomModel.createdAt = bedroom['created_at'];
        roomModel.updatedAt = bedroom['updated_at'];
        _RoomList.add(roomModel);
        _findItems = _RoomList;
        _isLoading = false;
      });
    });
    // ignore: avoid_print
    print(rooms);
  }

  @override
  void initState() {
    super.initState();
    getAllRooms();
  }

  Future<void> _updateRoom(int id) async {
    await _roomService.updateRoom(
        id, _roomNameController.text, _roomDescriptionController.text);
  }

  void _showForm(int? id) async {
    if (id != null) {
      var room = _RoomList.firstWhere((room) => room.id == id);
      _roomNameController.text = room.name!;
      _roomDescriptionController.text = room.description!;
    }

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(id == null ? 'Add Room' : 'Edit Room'),
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
              child: Text(id == null ? 'Create New' : 'Update'),
              onPressed: () async {
                if (id == null) {
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
                    _room.name = _roomNameController.text;
                    _room.description = _roomDescriptionController.text;
                    _room.createdAt = DateTime.now().toString();
                    _room.updatedAt = DateTime.now().toString();
                    await _roomService.insertRoom(_room);
                  }
                }

                if (id != null) {
                  await _updateRoom(id);
                }

                // Clear the text fields
                _roomNameController.text = '';
                _roomDescriptionController.text = '';

                Navigator.pop(context);
                getAllRooms();
              },
            ),
          ],
        );
      },
    );
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
                Text(
                  'Name: ${room.name}',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Description: ${room.description}'),
                Text(
                  'Created At: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(room.createdAt!))}',
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Successfully deleted a room!'),
                  ));
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

  void _searchRoom(String name) {
    List<Room> results = [];
    if (name.isEmpty) {
      results = _RoomList;
    } else {
      results = _RoomList.where(
              (item) => item.name!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    setState(() {
      _findItems = results;
    });
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
              'Rooms',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Search bar
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                onChanged: (text) {
                  _searchRoom(text);
                },
                decoration: const InputDecoration(
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
              itemCount: _findItems?.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.orange[200],
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    title: Text(_findItems?[index].name ?? ''),
                    subtitle: Text(_findItems?[index].description ?? ''),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showForm(_findItems?[index].id);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _showDeleteMessage(_findItems?[index].id);
                            },
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      _showDetails(_findItems?[index].id);
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
