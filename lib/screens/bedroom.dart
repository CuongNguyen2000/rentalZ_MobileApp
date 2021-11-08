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

  List<Bedroom> _bedroomList = <Bedroom>[];

  final _editBedroomNameController = TextEditingController();
  final _editBedroomDescriptionController = TextEditingController();

  bool _isLoading = false;

  getAllBedrooms() async {
    _bedroomList = [];
    var bedrooms = await _bedroomService.getAllBedrooms();
    bedrooms.forEach((bedroom) {
      setState(() {
        var bedroomModel = Bedroom();
        bedroomModel.id = bedroom['id'];
        bedroomModel.name = bedroom['name'];
        bedroomModel.description = bedroom['description'];
        // bedroomModel.createdAt = bedroom['createdAt'];
        _bedroomList.add(bedroomModel);
        _isLoading = false;
      });
    });
    // ignore: avoid_print
    print(bedrooms);
  }

  void initState() {
    super.initState();
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
                    await _bedroomService.insertBedroom(_bedroom);
                    Navigator.pop(context);
                    getAllBedrooms();
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
            title: const Text('Edit Bedroom'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _editBedroomNameController,
                  decoration: InputDecoration(
                    labelText: _bedroomList
                        .firstWhere((bedroom) => bedroom.id == id)
                        .name,
                  ),
                ),
                TextField(
                  controller: _editBedroomDescriptionController,
                  decoration: InputDecoration(
                    labelText: _bedroomList
                        .firstWhere((bedroom) => bedroom.id == id)
                        .description,
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
                    _bedroom.id = id;
                    _bedroom.name = _editBedroomNameController.text;
                    _bedroom.description =
                        _editBedroomDescriptionController.text;
                    _bedroomService.updateBedroom(_bedroom);
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
             Text('Name: ${bedroom.name}'),
                Text('Description: ${bedroom.description}'),
              // Text(bedroom.createdAt!),
            ],
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
  void _searchBedrooms(String? name) {
    if (name == null) {
      getAllBedrooms();
    } else {
      _bedroomService.searchBedrooms(name).then((bedrooms) {
        setState(() {
          _bedroomList = bedrooms;
        });
      });
    }
  }

  // void onSearchTextChanged(String text) {
  //   List<Bedroom> results = [];
  //   if (text.isEmpty) {
  //     results = _bedroomList;
  //   } else {
  //     results = _bedroomList
  //         .where((bedroom) =>
  //             bedroom.name!.toLowerCase().contains(text.toLowerCase()))
  //         .toList();
  //   }
  //   setState(() {
  //     _bedroomList = results;
  //   });
  // }

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
          : _bedroomList.length == 0
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
                  itemCount: _bedroomList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.orange[200],
                      margin: const EdgeInsets.all(15),
                      child: ListTile(
                        title: Text(_bedroomList[index].name!),
                        subtitle: Text(_bedroomList[index].description!),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showForm(_bedroomList[index].id);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteMessage(_bedroomList[index].id);
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          _showDetails(_bedroomList[index].id);
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
