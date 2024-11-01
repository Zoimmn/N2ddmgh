import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'WineFormPage.dart';
import 'WineDetailPage.dart';

class WineListPage extends StatelessWidget {
  final CollectionReference wines = FirebaseFirestore.instance.collection('wines');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Catálogo de Vinhos")),cancel
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: wines.where('tried', isEqualTo: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
                if (!snapshot.hasData) return Text("Sem vinhos experimentados");
                return WineList(snapshot: snapshot.data!, title: "Vinhos Experimentados");
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: wines.where('tried', isEqualTo: false).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
                if (!snapshot.hasData) return Text("Sem vinhos a experimentar");
                return WineList(snapshot: snapshot.data!, title: "Vinhos a Experimentar");
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WineFormPage())),
        child: Icon(Icons.add),
      ),
    );
  }
}

class WineList extends StatelessWidget {
  final QuerySnapshot snapshot;
  final String title;

  WineList({required this.snapshot, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Expanded(
          child: ListView(
            children: snapshot.docs.map((doc) {
              var wine = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(wine['name']),
                subtitle: Text("País: ${wine['country']} | Tipo da Uva: ${wine['grapeType']}"),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WineDetailPage(doc.id))),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
