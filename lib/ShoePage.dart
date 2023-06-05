import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyApp.dart';

class ShoePage extends StatelessWidget {
  String? id;
  ShoePage({super.key, required this.id});

  void updateDocumentField(String collectionName, String documentId,
      String fieldName, dynamic newValue) {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .update({fieldName: newValue}).then((value) {
      print("Document field updated successfully!");
    }).catchError((error) {
      print("Failed to update document field: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var photoUrl = appState.photoUrlShoe;
    var name = appState.nameShoe;
    var brand = appState.brandShoe;
    var colorsString = appState.colorsShoe;
    var typeShoe = appState.typeShoe;
    List<Color> colors = colorsString.map((colorString) {
      switch (colorString.toLowerCase()) {
        case 'grey':
          return Colors.grey;
        case 'blue':
          return Colors.blue;
        case 'red':
          return Colors.red;
        case 'green':
          return Colors.green;
        case 'yellow':
          return Colors.yellow;
        case 'orange':
          return Colors.orange;
        case 'white':
          return Colors.white;
        case 'pink':
          return Colors.pink;
        case 'black':
          return Colors.black;
        default:
          return Colors.purple;
      }
    }).toList();

    var waterproof = appState.waterproofShoe;
    var seasonOfShoes = appState.seasonShoe;
    String seasons = seasonOfShoes.length == 1
        ? seasonOfShoes[0]
        : seasonOfShoes.sublist(0, seasonOfShoes.length - 1).join(', ') +
            ' and ' +
            seasonOfShoes.last;

    void deleteShoe() async {
      try {
        appState.changeIndexMyHomePage(1);
        appState.changeActualShoe("");
        await FirebaseFirestore.instance.collection('shoe').doc(id).delete();
        print('La chaussure a été supprimée avec succès.');
      } catch (e) {
        print('Erreur lors de la suppression de la chaussure : $e');
      }
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 7.0),
          Center(
            child: photoUrl == ""
                ? const Text("Any Photo Here")
                : CachedNetworkImage(
                    imageUrl: photoUrl,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    height: 200,
                  ),
          ),
          const SizedBox(height: 7.0),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Brand: $brand",
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 15.0),
                Row(
                  children: [
                    const Text(
                      'Waterproof:',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      waterproof ? Icons.check : Icons.close,
                      color: waterproof ? Colors.green : Colors.red,
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 7.0),
          const Center(
            child: Text(
              "Colors:",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 7.0),
          Center(
            child: SizedBox(
              height: 50, // Spécifiez la hauteur souhaitée pour le Container
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  child: GridView.builder(
                    itemCount: colors.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10, // Nombre de colonnes dans la grille
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: colors[index] == Colors.purple
                                  ? const LinearGradient(colors: [
                                      Colors.blue,
                                      Colors.yellow,
                                      Colors.red
                                    ])
                                  : LinearGradient(
                                      colors: [colors[index], colors[index]]),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const Center(
            child: Text(
              'Seasons:',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Text(
              seasons,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 7.0),
          Text(
            'Type: $typeShoe',
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7.0),
          Container(
            padding: const EdgeInsets.all(7.0),
            height: 110.0,
            width: double.infinity,
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        //write in firestore in the collection user where the id is the UID and put the id of the shoe in the field IdShoeToConnect
                        updateDocumentField("user", appState.uid,
                            "IdShoeToConnect", appState.actualShoe);
                      },
                      child: const Text("Connect to a smart shoe tree")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            appState.changeChange(true);
                            appState.changeIndexMyHomePage(4);
                          },
                          child: const Text("Change Shoe")),
                      const SizedBox(width: 7.0),
                      ElevatedButton(
                          onPressed: () {
                            deleteShoe();
                          },
                          child: const Text("Delete Shoe"))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
