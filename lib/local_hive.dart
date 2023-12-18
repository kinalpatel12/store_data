import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:store_data/Boxes/boxes.dart';
import 'package:store_data/Model/notes_model.dart';

class LocalHiveScreen extends StatefulWidget {
  const LocalHiveScreen({super.key});

  @override
  State<LocalHiveScreen> createState() => _LocalHiveScreenState();
}

class _LocalHiveScreenState extends State<LocalHiveScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Hive Database")),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _showMyDialog();
            // var box = await Hive.openBox('asif');
            // box.put('name', 'vrajesh koladiya');
            // box.put('age', '23');
            // box.put('details', {
            //   'pro': 'Developer',
            //   'jjhh': 'hgghgh',
            // });
            // print(box.get('name'));
            // print(box.get('age'));
            // print(box.get('details')['pro']);
          },
          child: Icon(Icons.add),
        ),
        body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, __) {
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            data[index].title.toString(),
                          ),
                          Text(
                            data[index].description.toString(),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          edit(data[index], data[index].title,
                              data[index].description);
                        },
                        child: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          delete(data[index]);
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
  // FutureBuilder(
  //   future: Hive.openBox('asif'),
  //   builder: (context, snapshot) {
  //     return Column(
  //       children: [
  //         ListTile(
  //           title: Text(snapshot.data!.get('name').toString()),
  //           subtitle: Text(snapshot.data!.get('age').toString()),
  //           trailing:
  //               IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
  //         )

  //         // Text(snapshot.data!.get('details').toString())
  //       ],
  //     );
  //   },
  // )

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> edit(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Notes"),
          content: SingleChildScrollView(
              child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                notesModel.title = titleController.text.toString();
                notesModel.description = descriptionController.text.toString();
                notesModel.save();
              },
              child: Text("Edit"),
            )
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Notes"),
          content: SingleChildScrollView(
              child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final data = NotesModel(
                    title: titleController.text,
                    description: descriptionController.text);

                final box = Boxes.getData();
                box.add(data);
                data.save();
                titleController.clear();
                descriptionController.clear();
              },
              child: Text("ADD"),
            )
          ],
        );
      },
    );
  }
}
