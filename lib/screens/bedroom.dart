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
  var _bedroomNameController = TextEditingController();
  var _bedroomDescriptionController = TextEditingController();

  var _bedroom = Bedroom();
  var _bedroomService = BedroomService();

  List<Bedroom> _bedroomList = <Bedroom>[];

  var bedroom;
  var _editBedroomNameController = TextEditingController();
  var _editBedroomDescriptionController = TextEditingController();

  void initState() {
    super.initState();
    getAllBedrooms();
  }

  getAllBedrooms() async {
    _bedroomList = <Bedroom>[];
    var bedrooms = await _bedroomService.getAllBedrooms();
    bedrooms.forEach((bedroom) {
      setState(() {
        var bedroomModel = Bedroom();
        bedroomModel.id = bedroom['id'];
        bedroomModel.name = bedroom['name'];
        bedroomModel.description = bedroom['description'];
        _bedroomList.add(bedroomModel);
      });
    });
    print(bedrooms);
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
                ),
                TextField(
                  controller: _bedroomDescriptionController,
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
                onPressed: () {
                  setState(() {
                    _bedroom.name = _bedroomNameController.text;
                    _bedroom.description = _bedroomDescriptionController.text;
                    _bedroomService.insertBedroom(_bedroom);
                    Navigator.pop(context);
                  });
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
                  setState(() {
                    _bedroom.id = id;
                    _bedroom.name = _editBedroomNameController.text;
                    _bedroom.description =
                        _editBedroomDescriptionController.text;
                    _bedroomService.updateBedroom(_bedroom);
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
              Text(bedroom.name!),
              Text(bedroom.description!),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bedroom'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: _bedroomList.length,
        itemBuilder: (context, index) {
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
                        _bedroomService.deleteBedroom(_bedroomList[index].id);
                        setState(() {
                          _bedroomList.removeAt(index);
                        });
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
