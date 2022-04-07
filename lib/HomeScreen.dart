import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _updatecontroller = TextEditingController();

  Box? contactBox;
  @override
  void initState() {
    contactBox = Hive.box("contact-list");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(children: [
          TextField(
            controller: _controller,
          ),
          SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: () async {
                    final userInput = _controller.text;
                    print(userInput);
                    await contactBox?.add(userInput);
                    print("added");
                  },
                  child: Text("Add user Number"))),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: Hive.box("contact-list").listenable(),
                builder: (context, box, widget) {
                  return ListView.builder(
                      itemCount: contactBox!.keys.toList().length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            dense: true,
                            title: Text(contactBox!.getAt(index).toString()),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  title: Text("Update"),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            _updatecontroller,
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              double.maxFinite,
                                                          child: ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                contactBox!.putAt(
                                                                    index,
                                                                     _updatecontroller
                                                                        .text);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  "Update"))),
                                                    ],
                                                  ));
                                            });
                                      },
                                      icon: Icon(
                                        Icons.edit_outlined,
                                        size: 20,
                                        color: Colors.amber,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        await contactBox!.deleteAt(index);
                                      },
                                      icon: Icon(
                                        Icons.remove_outlined,
                                        size: 20,
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          )
        ]),
      ),
    );
  }
}
