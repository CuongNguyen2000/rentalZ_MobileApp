import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _furnitureNameController =
      TextEditingController();
  final TextEditingController _furnitureDescriptionController =
      TextEditingController();

  final _furniture = Furniture();
  final _furnitureService = FurnitureService();

  // ignore: non_constant_identifier_names
  List<Furniture> _FurnitureList = [];
  List<Furniture>? _findItems;

  getAllFurnitures() async {
    _FurnitureList = [];
    var furnitures = await _furnitureService.getAllFurnitures();
    furnitures.forEach((bedroom) {
      setState(() {
        var furnitureModel = Furniture();
        furnitureModel.id = bedroom['id'];
        furnitureModel.name = bedroom['name'];
        furnitureModel.description = bedroom['description'];
        furnitureModel.createdAt = bedroom['created_at'];
        furnitureModel.updatedAt = bedroom['updated_at'];
        _FurnitureList.add(furnitureModel);
        _findItems = _FurnitureList;
      });
    });
    // ignore: avoid_print
    print(furnitures);
  }

  @override
  void initState() {
    super.initState();
    getAllFurnitures();
  }

  Future<void> _updateFurniture(int id) async {
    await _furnitureService.updateFurniture(id, _furnitureNameController.text,
        _furnitureDescriptionController.text);
  }

  void _showForm(int? id) async {
    if (id != null) {
      var furniture =
          _FurnitureList.firstWhere((furniture) => furniture.id == id);
      _furnitureNameController.text = furniture.name!;
      _furnitureDescriptionController.text = furniture.description!;
    }

    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(id == null ? 'Add Furniture' : 'Edit Furniture'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _furnitureNameController,
                  decoration: InputDecoration(
                    labelText: 'Furniture Name',
                  ),
                  autofocus: true,
                ),
                TextField(
                  controller: _furnitureDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Furniture Description',
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
                      _furniture.name = _furnitureNameController.text;
                      _furniture.description =
                          _furnitureDescriptionController.text;
                      _furniture.createdAt = DateTime.now().toString();
                      _furniture.updatedAt = DateTime.now().toString();
                      await _furnitureService.insertFurniture(_furniture);
                      Navigator.pop(context);
                    }
                  }

                  if (id != null) {
                    await _updateFurniture(id);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Successfully updated a furniture!'),
                    ));
                    Navigator.pop(context);
                  }

                  // Clear the text fields
                  _furnitureNameController.text = '';
                  _furnitureDescriptionController.text = '';

                  getAllFurnitures();
                },
              ),
            ],
          );
        });
  }

  // Show furniture details by id
  void _showDetails(int? id) {
    if (id == null) {
      return;
    }
    var furniture =
        _FurnitureList.firstWhere((furniture) => furniture.id == id);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Furniture Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Furniture Name: ${furniture.name}',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Furniture Description: ${furniture.description}'),
                Text(
                  'Created At: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(furniture.createdAt!))}',
                ),
                Text(
                  'Last modified at: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(furniture.updatedAt!))}',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Successfully deleted a furniture!'),
                  ));
                  getAllFurnitures();
                  Navigator.pop(context);
                  _FurnitureList.removeWhere((furniture) => furniture.id == id);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _searchFurniture(String name) {
    List<Furniture> results = [];
    if (name.isEmpty) {
      results = _FurnitureList;
    } else {
      results = _FurnitureList.where(
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
              'Furniture',
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
                  _searchFurniture(text);
                },
                decoration: const InputDecoration(
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
      body: _FurnitureList.isEmpty
          ? Center(
              // child: CircularProgressIndicator(),
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
