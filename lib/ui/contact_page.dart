import 'dart:io';

import 'package:agenda/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class ContactPage extends StatefulWidget {

  bool _userEdited = false;  
  final Contact contact;
  
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  Contact _editedContact;

  bool _userEdited;

  @override
  void initState() {
    super.initState();
    
    if (widget.contact == null) {
      _editedContact = Contact();    
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.red,
        title: Text(_editedContact.name ?? "Novo Contato"),
        centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(_editedContact.name != null && _editedContact.name.isNotEmpty){
              //print(_editedContact.img);
              Navigator.pop(context,_editedContact);
            } else{
              FocusScope.of(context).requestFocus(_nameFocus);
            } 
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null ? 
                          FileImage(File(_editedContact.img)) : 
                            AssetImage('images/person.png')
                    ),
                  ),
                ),
                onTap: () {
                  final ImagePicker _picker = ImagePicker();
                  _picker.pickImage(source: ImageSource.camera).then((file){
                    if(file == null) return;
                    setState(() {
                      _editedContact.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.name = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone,
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Descartar Altera????es?"),
          content: Text("Se sair as altera????es ser??o peridas"),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text("Cancelar")),
            TextButton(onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
            }, child: Text("Sim")),
          ],
        );
      });
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }
}