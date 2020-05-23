import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';



void main(){
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _toDoController = TextEditingController();

  List _toDoList = [];

  void _addToDo(){
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["OK"] = false;
      _toDoList.add(newToDo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de compras"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 1.0, 6.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: _toDoController,
                      decoration: InputDecoration(
                          labelText: "Novo Iten",
                          labelStyle: TextStyle(color:Colors.red)
                      ),
                    )
                ),
                RaisedButton(
                  color: Colors.red,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: _toDoList.length,
                  itemBuilder:(context, index){
                    return CheckboxListTile(
                        title: Text(_toDoList[index]["title"]),
                        value: _toDoList[index]["OK"],
                        secondary: CircleAvatar(
                          child: Icon(_toDoList[index]["OK"] ?
                              Icons.check: Icons.error),),
                        onChanged:(c){
                          setState(() {
                            _toDoList[index]["OK"] = c;
                          });
                        } ,
                      );
                   }),
          )
        ],
      ),
    );
  }
  Future<File>_getFile() async{
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.jason");
  }
  Future<File>_saveDate() async{
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);

  }
  Future<String>_readData() async{
    try{
      final file = await _getFile();
      return file.readAsString();

    }
    catch (e){
      return null;
    }
  }
}

