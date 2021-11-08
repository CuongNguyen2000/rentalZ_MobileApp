import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_z/helpers/drawer_navigation.dart';
import 'package:rental_z/models/funiture.dart';
import 'package:rental_z/services/funiture_service.dart';

class FunitureScreen extends StatefulWidget {
  const FunitureScreen({Key? key}) : super(key: key);

  @override
  _FunitureScreenState createState() => _FunitureScreenState();
}

class _FunitureScreenState extends State<FunitureScreen> {
  // ignore: unused_field
  final _funitureNameController = TextEditingController();
  final _funitureDescriptionController = TextEditingController();

  final _funiture = Funiture();
  final _funitureService = FunitureService();

  // ignore: non_constant_identifier_names
  List<Funiture> _FunitureList = <Funiture>[];

  final _editFunitureNameController = TextEditingController();
  final _editFunitureDescriptionController = TextEditingController();

  bool _isLoading = false;

  getAllFunitures() async {
    _FunitureList = [];
    var funitures = await _funitureService.getAllFunitures();
    funitures.forEach((bedroom) {
      setState(() {
        var funitureModel = Funiture();
        funitureModel.id = bedroom['id'];
        funitureModel.name = bedroom['name'];
        funitureModel.description = bedroom['description'];
        _FunitureList.add(funitureModel);
        _isLoading = false;
      });
    });
    // ignore: avoid_print
    print(funitures);
  }

  void initState() {
    super.initState();
    getAllFunitures();
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
                  controller: _funitureNameController,
                  decoration: InputDecoration(
                    labelText: 'Funiture Name',
                  ),
                  autofocus: true,
                ),
                TextField(
                  controller: _funitureDescriptionController,
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
                  if (_funitureNameController.text.isEmpty) {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('Funiture Name is required'),
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
                  } else if (_funitureDescriptionController.text.isEmpty) {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('Funiture Description is required'),
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
                    _funiture.name = _funitureNameController.text;
                    _funiture.description = _funitureDescriptionController.text;
                    await _funitureService.insertFuniture(_funiture);
                    Navigator.pop(context);
                    getAllFunitures();
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
                  controller: _editFunitureNameController,
                  decoration: InputDecoration(
                    labelText: _FunitureList.firstWhere(
                        (funiture) => funiture.id == id).name,
                  ),
                ),
                TextField(
                  controller: _editFunitureDescriptionController,
                  decoration: InputDecoration(
                    labelText: _FunitureList.firstWhere(
                        (funiture) => funiture.id == id).description,
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
                    _funiture.id = id;
                    _funiture.name = _editFunitureNameController.text;
                    _funiture.description =
                        _editFunitureDescriptionController.text;

                    _funitureService.updateFuniture(_funiture);
                    getAllFunitures();
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

  // Show funiture details by id
  void _showDetails(int? id) {
    if (id == null) {
      return;
    }
    var funiture = _FunitureList.firstWhere((funiture) => funiture.id == id);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Funiture Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name: ${funiture.name}'),
                Text('Description: ${funiture.description}'),
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
          title: const Text('Delete Funiture'),
          content: Text('Are you sure you want to delete this funiture?'),
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
                  _funitureService.deleteFuniture(id);
                  getAllFunitures();
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
              'Funiture',
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
                  hintText: 'Search funiture',
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
          : _FunitureList.length == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'No Funiture Found',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _FunitureList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.orange[200],
                      margin: const EdgeInsets.all(15),
                      child: ListTile(
                        title: Text(_FunitureList[index].name!),
                        subtitle: Text(_FunitureList[index].description!),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showForm(_FunitureList[index].id);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteMessage(_FunitureList[index].id);
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          _showDetails(_FunitureList[index].id);
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
