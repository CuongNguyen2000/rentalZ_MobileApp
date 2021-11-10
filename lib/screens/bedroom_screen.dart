import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _bedroomNameController = TextEditingController();
  final TextEditingController _bedroomDescriptionController =
      TextEditingController();

  final _bedroom = Bedroom();
  final _bedroomService = BedroomService();

  List<Bedroom> _bedroomList = [];
  List<Bedroom>? _findItem;

  getAllBedrooms() async {
    _bedroomList = [];
    var bedrooms = await _bedroomService.getAllBedrooms();
    bedrooms.forEach((bedroom) {
      setState(() {
        var bedroomModel = Bedroom();
        bedroomModel.id = bedroom['id'];
        bedroomModel.name = bedroom['name'];
        bedroomModel.description = bedroom['description'];
        bedroomModel.createdAt = bedroom['created_at'];
        bedroomModel.updatedAt = bedroom['updated_at'];
        _bedroomList.add(bedroomModel);
        _findItem = _bedroomList;
      });
    });
    // ignore: avoid_print
    print(bedrooms);
  }

  @override
  initState() {
    super.initState();
    getAllBedrooms();
  }

  Future<void> _updateBedroom(int id) async {
    await _bedroomService.updateBedroom(
        id, _bedroomNameController.text, _bedroomDescriptionController.text);
  }

  void _showForm(int? id) async {
    if (id != null) {
      var bedroom = _bedroomList.firstWhere((bedroom) => bedroom.id == id);
      _bedroomNameController.text = bedroom.name!;
      _bedroomDescriptionController.text = bedroom.description!;
    }

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(id == null ? 'Add Bedroom' : 'Edit Bedroom'),
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
              child: Text(id == null ? 'Create New' : 'Update'),
              onPressed: () async {
                if (id == null) {
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
                    }
                  }
                }

                if (id != null) {
                  await _updateBedroom(id);
                }

                // Clear the text fields
                _bedroomNameController.text = '';
                _bedroomDescriptionController.text = '';

                // Close the dialog
                Navigator.pop(context);
                getAllBedrooms();
              },
            ),
          ],
        );
      },
    );
  }

  // Show bedrooom details by id
  void _showDetails(int? id) {
    if (id == null) {
      return;
    }
    var bedroom = _bedroomList.firstWhere((bedroom) => bedroom.id == id);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bedroom Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Name: ${bedroom.name}',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Description: ${bedroom.description}'),
                Text(
                  'Created At: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(bedroom.createdAt!))}',
                ),
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
      results = _bedroomList;
    } else {
      results = _bedroomList
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
            const Text(
              'Bedroom',
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
                  _searchBedrooms(text);
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
      // show card message if no bedroom found
      body: _bedroomList.isEmpty
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
