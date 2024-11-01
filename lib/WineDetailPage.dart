import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'WineFormPage.dart';

class WineDetailPage extends StatelessWidget {
  final String wineId;

  WineDetailPage(this.wineId);

  void deleteWine(BuildContext context) {
    FirebaseFirestore.instance.collection('wines').doc(wineId).delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhes do Vinho")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('wines').doc(wineId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var wine = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nome: ${wine['name']}", style: TextStyle(fontSize: 20)),
                Text("Tipo: ${wine['type']}"),
                Text("Ano: ${wine['year']}"),
                Text("País: ${wine['country']}"),
                Text("Tipo da Uva: ${wine['grapeType']}"),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WineFormPage(wineId: wineId))),
                  child: Text("Editar"),
                ),
                ElevatedButton(
                  onPressed: () => deleteWine(context),
                  child: Text("Deletar"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
