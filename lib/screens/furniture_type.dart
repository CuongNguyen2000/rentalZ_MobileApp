import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_z/helpers/drawer_navigation.dart';
import 'package:rental_z/models/furniture.dart';
import 'package:rental_z/services/furniture_service.dart';

class FurnitureScreen extends StatefulWidget {
  const FurnitureScreen({Key? key}) : super(key: key);

  @override
  _FurnitureScreenState createState() => _FurnitureScreenState();
}

class _FurnitureScreenState extends State<FurnitureScreen> {
  // ignore: unused_field
  final _furnitureNameController = TextEditingController();
  final _furnitureDescriptionController = TextEditingController();

  final _furniture = Furniture();
  final _furnitureService = FurnitureService();

  // ignore: non_constant_identifier_names
  List<Furniture> _FurnitureList = <Furniture>[];

  final _editFurnitureNameController = TextEditingController();
  final _editFurnitureDescriptionController = TextEditingController();

  bool _isLoading = false;

  getAllFurnitures() async {
    _FurnitureList = [];
    var furnitures = await _furnitureService.getAllFurnitures();
    furnitures.forEach((bedroom) {
      setState(() {
        var furnitureModel = Furniture();
        furnitureModel.id = bedroom['id'];
        furnitureModel.name = bedroom['name'];
        furnitureModel.description = bedroom['description'];
        _FurnitureList.add(furnitureModel);
        _isLoading = false;
      });
    });
    // ignore: avoid_print
    print(furnitures);
  }

  void initState() {
    super.initState();
    getAllFurnitures();
  }

  void _showForm(int? id) async {
    if (id == null) {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Funiture'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _furnitureNameController,
                  decoration: InputDecoration(
                    labelText: 'Funiture Name',
                  ),
                  autofocus: true,
                ),
                TextField(
                  controller: _furnitureDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Funiture Description',
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
                  if (_furnitureNameController.text.isEmpty) {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('Furniture Name is required'),
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
                  } else if (_furnitureDescriptionController.text.isEmpty) {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('Furniture Description is required'),
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
                    _furniture.name = _furnitureNameController.text;
                    _furniture.description = _furnitureDescriptionController.text;
                    await _furnitureService.insertFurniture(_furniture);
                    Navigator.pop(context);
                    getAllFurnitures();
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
                  controller: _editFurnitureNameController,
                  decoration: InputDecoration(
                    labelText: _FurnitureList.firstWhere(
                        (furniture) => furniture.id == id).name,
                  ),
                ),
                TextField(
                  controller: _editFurnitureDescriptionController,
                  decoration: InputDecoration(
                    labelText: _FurnitureList.firstWhere(
                        (furniture) => furniture.id == id).description,
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
                    _furniture.id = id;
                    _furniture.name = _editFurnitureNameController.text;
                    _furniture.description =
                        _editFurnitureDescriptionController.text;

                    _furnitureService.updateFurniture(_furniture);
                    getAllFurnitures();
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

  // Show furniture details by id
  void _showDetails(int? id) {
    if (id == null) {
      return;
    }
    var furniture = _FurnitureList.firstWhere((furniture) => furniture.id == id);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Furniture Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name: ${furniture.name}'),
                Text('Description: ${furniture.description}'),
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
          title: const Text('Delete Furniture'),
          content: Text('Are you sure you want to delete this furniture?'),
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
                  _furnitureService.deleteFurniture(id);
                  getAllFurnitures();
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
              'Furniture',
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
                  hintText: 'Search furniture',
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
          : _FurnitureList.length == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'No Furniture Found',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _FurnitureList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.orange[200],
                      margin: const EdgeInsets.all(15),
                      child: ListTile(
                        title: Text(_FurnitureList[index].name!),
                        subtitle: Text(_FurnitureList[index].description!),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showForm(_FurnitureList[index].id);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteMessage(_FurnitureList[index].id);
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          _showDetails(_FurnitureList[index].id);
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
