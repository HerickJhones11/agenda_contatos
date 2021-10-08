import 'dart:io';

import 'package:agenda/helpers/contact_helper.dart';
import 'package:flutter/material.dart';


class ContactPage extends StatefulWidget {
  
  final Contact contact;
  
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;

  @override
  void initState() {
    super.initState();
    
    if (widget.contact == null) {
      _editedContact = Contact();    
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red,
      title: Text(_editedContact.name ?? "Novo Contato"),
      centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { },
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
                        FileImage(File(_editedContact .img)) : 
                          AssetImage('images/person.png')
                   ),
                 ),
               ),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (text) {},
            )
          ],
        ),
      ),
    );
  }
}