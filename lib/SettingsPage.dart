import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'MyApp.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final int id = 0;
  double currentHumidityRate = 20.0;
  double currentTemperature = 60.0;
  String currentName = '';
  String? currentAdress = '';
  String currentPassword = '';
  String newPassword = '';
  String newName = '';
  String newAdress = '';
  void updateState(int index, BuildContext context) {
    if (index != 2) {
      Navigator.pushNamed(context, '/home');
    }
  }

  Future<void> fetchValuesFromDatabase() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseFirestore.instance;
    final documentSnapshot =
        await databaseReference.collection('user').doc(firebaseUser!.uid).get();

    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      setState(() {
        currentName = data!['Name'] ?? '';
        currentHumidityRate = data['Humidity Rate Threshold'] ?? 20.0;
        currentTemperature = data['Temperature Threshold'] ?? 60.0;
        currentAdress = FirebaseAuth.instance.currentUser?.email;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchValuesFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 4, 104, 130),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Action souhaitée lors de l'appui sur le bouton flèche
            // Par exemple, pour revenir à l'écran précédent :
            appState.changeIndexProfilePage(0);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              const Text('Choose your humidity rate threshold',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
              SizedBox(height: 16),
              Slider(
                value: currentHumidityRate,
                min: 0,
                max: 100,
                divisions: 50,
                label: currentHumidityRate.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    currentHumidityRate = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Selected: $currentHumidityRate'),
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () async {
                    final firebaseUser = FirebaseAuth.instance.currentUser;
                    final databaseReference = FirebaseFirestore.instance;
                    final collectionReference = databaseReference.collection(
                        'user'); // Remplacez 'your_collection' par le nom de votre collection dans la base de données

                    await collectionReference.doc(firebaseUser!.uid).update({
                      'Humidity Rate Threshold': currentHumidityRate,
                    });

                    print('Database updated successfully!');
                  },
                  child: const Text("Validation")),
              SizedBox(height: 20),
              const Text('Choose your temperature threshold',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
              SizedBox(height: 16),
              Slider(
                value: currentTemperature,
                min: 0,
                max: 100,
                divisions: 50,
                label: currentTemperature.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    currentTemperature = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Selected: $currentTemperature'),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    final firebaseUser = FirebaseAuth.instance.currentUser;
                    final databaseReference = FirebaseFirestore.instance;
                    final collectionReference = databaseReference.collection(
                        'user'); // Remplacez 'your_collection' par le nom de votre collection dans la base de données

                    await collectionReference.doc(firebaseUser!.uid).update({
                      'Temperature Threshold': currentTemperature,
                    });

                    print('Database updated successfully!');
                  },
                  child: const Text("Validation")),
              const SizedBox(height: 20),
              const Text(
                'Modifications',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(
                    Icons.mail,
                    size: 40,
                    color: Color.fromARGB(255, 4, 104, 130),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Mail address',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Modify my mail address'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'New mail address',
                                          hintText: currentAdress,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          icon: Icon(Icons.mail_lock),
                                        ),
                                        onChanged: (value) => newAdress = value,
                                      ),
                                      SizedBox(height: 20),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Enter your password',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          icon: Icon(Icons.password),
                                        ),
                                        onChanged: (value) =>
                                            currentPassword = value,
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                          onPressed: () async {
                                            final user = FirebaseAuth
                                                .instance.currentUser;
                                            final cred =
                                                EmailAuthProvider.credential(
                                                    email: user!.email!,
                                                    password: currentPassword);
                                            user
                                                .reauthenticateWithCredential(
                                                    cred)
                                                .then((value) {
                                              user
                                                  .updateEmail(newAdress)
                                                  .then((_) {
                                                print("sucess mail updated");
                                              }).catchError((error) {
                                                print("fail mail updated");
                                              });
                                            }).catchError((err) {});
                                          },
                                          child: const Text("Validation"))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor:
                            const Color.fromARGB(255, 219, 129, 129)),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Color.fromRGBO(202, 171, 236, 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.password,
                    size: 40,
                    color: Color.fromARGB(255, 4, 104, 130),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Password',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Modify your password'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Former Password',
                                          hintText: 'Insert former password',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          icon: Icon(Icons.password),
                                        ),
                                        onChanged: (value) =>
                                            currentPassword = value,
                                      ),
                                      SizedBox(height: 20),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'New Password',
                                          hintText: 'Insert new password',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          icon: Icon(Icons.password),
                                        ),
                                        onChanged: (value) =>
                                            newPassword = value,
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                          onPressed: () async {
                                            final user = FirebaseAuth
                                                .instance.currentUser;
                                            final cred =
                                                EmailAuthProvider.credential(
                                                    email: user!.email!,
                                                    password: currentPassword);
                                            user
                                                .reauthenticateWithCredential(
                                                    cred)
                                                .then((value) {
                                              user
                                                  .updatePassword(newPassword)
                                                  .then((_) {
                                                print("sucess");
                                                //Success, do something
                                              }).catchError((error) {
                                                print("fail");
                                                //Error, show something
                                              });
                                            }).catchError((err) {});
                                          },
                                          child: const Text("Validation"))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor:
                            const Color.fromARGB(255, 219, 129, 129)),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Color.fromRGBO(202, 171, 236, 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.image_search,
                    size: 40,
                    color: Color.fromARGB(255, 4, 104, 130),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Profile picture',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Modify your profile picture'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'New Profile picture',
                                          icon: Icon(Icons.image_search),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor:
                            const Color.fromARGB(255, 219, 129, 129)),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Color.fromRGBO(202, 171, 236, 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.text_fields,
                    size: 40,
                    color: Color.fromARGB(255, 4, 104, 130),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Name',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Modify your name'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'New name',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            hintText: currentName,
                                            icon: Icon(Icons.people),
                                          ),
                                          onChanged: (value) =>
                                              newName = value),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                          onPressed: () async {
                                            final firebaseUser = FirebaseAuth
                                                .instance.currentUser;
                                            final databaseReference =
                                                FirebaseFirestore.instance;
                                            final collectionReference =
                                                databaseReference.collection(
                                                    'user'); // Remplacez 'your_collection' par le nom de votre collection dans la base de données

                                            await collectionReference
                                                .doc(firebaseUser!.uid)
                                                .update({
                                              'Name': newName,
                                            });

                                            print(
                                                'Database updated successfully!');
                                          },
                                          child: const Text("Validation")),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor:
                            const Color.fromARGB(255, 219, 129, 129)),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Color.fromRGBO(202, 171, 236, 0.8),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
