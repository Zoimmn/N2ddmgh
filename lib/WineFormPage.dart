import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WineFormPage extends StatefulWidget {
  final String? wineId;

  WineFormPage({this.wineId});

  @override
  _WineFormPageState createState() => _WineFormPageState();
}

class _WineFormPageState extends State<WineFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _yearController = TextEditingController();
  final _countryController = TextEditingController();
  final _grapeTypeController = TextEditingController();
  bool _tried = false;

  void addOrUpdateWine() {
    CollectionReference wines = FirebaseFirestore.instance.collection('wines');
    var wineData = {
      'name': _nameController.text,
      'type': _typeController.text,
      'year': int.parse(_yearController.text),
      'country': _countryController.text,
      'grapeType': _grapeTypeController.text,
      'tried': _tried,
    };
    if (widget.wineId == null) {
      wines.add(wineData);
    } else {
      wines.doc(widget.wineId).update(wineData);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.wineId == null ? "Adicionar Vinho" : "Editar Vinho")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: InputDecoration(labelText: 'Nome')),
              TextFormField(controller: _typeController, decoration: InputDecoration(labelText: 'Tipo')),
              TextFormField(controller: _yearController, decoration: InputDecoration(labelText: 'Ano')),
              TextFormField(controller: _countryController, decoration: InputDecoration(labelText: 'País')),
              TextFormField(controller: _grapeTypeController, decoration: InputDecoration(labelText: 'Tipo da Uva')),
              SwitchListTile(
                title: Text("Experimentado"),
                value: _tried,
                onChanged: (value) => setState(() => _tried = value),
              ),
              ElevatedButton(onPressed: addOrUpdateWine, child: Text(widget.wineId == null ? "Adicionar" : "Atualizar")),
            ],
          ),
        ),
      ),
    );
  }
}
