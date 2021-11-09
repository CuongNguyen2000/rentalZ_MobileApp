import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_z/helpers/drawer_navigation.dart';
import 'package:rental_z/models/bedroom.dart';
import 'package:rental_z/services/bedroom_service.dart';

class BedroomScreen extends StatefulWidget {
  const BedroomScreen({Key? key}) : super(key: key);

  @override
  _BedroomScreenState createState() => _BedroomScreenState();
}

class _BedroomScreenState extends State<BedroomScreen> {
  // ignore: unused_field
  final _bedroomNameController = TextEditingController();
  final _bedroomDescriptionController = TextEditingController();

  final _bedroom = Bedroom();
  final _bedroomService = BedroomService();

  List<Bedroom>? _bedroomList;

  final _editBedroomNameController = TextEditingController();
  final _editBedroomDescriptionController = TextEditingController();

  bool _isLoading = false;

  getAllBedrooms() async {
    _bedroomList = <Bedroom>[];
    var bedrooms = await _bedroomService.getAllBedrooms();
    bedrooms.forEach((bedroom) {
      setState(() {
        var bedroomModel = Bedroom();
        bedroomModel.id = bedroom['id'];
        bedroomModel.name = bedroom['name'];
        bedroomModel.description = bedroom['description'];
        // bedroomModel.createdAt = bedroom['createdAt'];
        _bedroomList!.add(bedroomModel);
        _isLoading = false;
      });
    });
    // ignore: avoid_print
    print(bedrooms);
  }

  List<Bedroom>? _findItem;

  @override
  initState() {
    super.initState();
    getAllBedrooms();
    _findItem = _bedroomList;
  }

  Future<void> _updateBedroom(int id) async {
    await _bedroomService.updateBedroom(id, _editBedroomNameController.text,
        _editBedroomDescriptionController.text);
    getAllBedrooms();
  }

  void _showForm(int? id) async {
    if (id == null) {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Bedroom'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _bedroomNameController,
                  decoration: InputDecoration(
                    labelText: 'Bedroom Name',
                  ),
                  autofocus: true,
                ),
                TextField(
                  controller: _bedroomDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Bedroom Description',
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
                  if (_bedroomNameController.text.isEmpty) {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Bedroom Name is required'),
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
                  } else if (_bedroomDescriptionController.text.isEmpty) {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content:
                              const Text('Bedroom Description is required'),
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
                    _bedroom.name = _bedroomNameController.text;
                    _bedroom.description = _bedroomDescriptionController.text;
                    _bedroom.createdAt = DateTime.now().toString();
                    _bedroom.updatedAt = DateTime.now().toString();
                    var results = await _bedroomService.insertBedroom(_bedroom);
                    if (results == null) {
                      await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Something went wrong'),
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
                      Navigator.pop(context);
                      getAllBedrooms();
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    } else {
      var bedroom = _bedroomList!.firstWhere((bedroom) => bedroom.id == id);
      _editBedroomNameController.text = bedroom.name!;
      _editBedroomDescriptionController.text = bedroom.description!;

      await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Bedroom'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _editBedroomNameController,
                  decoration: InputDecoration(
                    labelText: 'Bedroom Name',
                  ),
                ),
                TextField(
                  controller: _editBedroomDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Bedroom Description',
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
                onPressed: () async {
                  //update bedroom by id
                  await _updateBedroom(id);
                  // return new list of bedrooms
                  getAllBedrooms();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Show bedrooom details by id
  void _showDetails(int? id) {
    if (id == null) {
      return;
    }
    var bedroom = _findItem!.firstWhere((bedroom) => bedroom.id == id);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bedroom Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name: ${bedroom.name}'),
                Text('Description: ${bedroom.description}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
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
          title: const Text('Delete Bedroom'),
          content: const Text('Are you sure you want to delete this bedroom?'),
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
                  _bedroomService.deleteBedroom(id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Successfully deleted a bedroom!'),
                  ));
                  _findItem!.removeWhere((item) => item.id == id);
                  getAllBedrooms();
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  // search bedrooms by name and return all bedrooms
  void _searchBedrooms(String name) {
    List<Bedroom> results = [];
    if (name.isEmpty) {
      results = _bedroomList!;
    } else {
      results = _bedroomList!
          .where(
              (item) => item.name!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    setState(() {
      _findItem = results;
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
            Text(
              'Bedroom',
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
                  _searchBedrooms(text);
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
      // show card message if no bedroom found
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _bedroomList!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'No bedrooms found',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _findItem?.length,
                  itemBuilder: (BuildContext context, int index) {
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
                                  _showForm(_findItem?[index].id);
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
        onPressed: () {
          _showForm(null);
        },
      ),
    );
  }
}
