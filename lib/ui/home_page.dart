import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:agenda/helpers/contact_helper.dart';
import 'package:agenda/ui/contact_page.dart';
import 'package:flutter/material.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
 
  @override
  _HomePageState createState() => _HomePageState();
}
 
 class _HomePageState extends State<HomePage> {
   
  ContactHelper helper = ContactHelper();

  

  List<Contact> contacts = [];
  
  @override
  void initState() {
    super.initState();
    _getAllContacts();
    
  } 
   
   Widget build(BuildContext context) {
     //print(contacts);
     
     return Scaffold(
       appBar: AppBar(
         title: Text("Contatos"),
         backgroundColor: Colors.red,
         centerTitle: true,
         actions: [
           PopupMenuButton(itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
             const PopupMenuItem<OrderOptions>(
               child: Text("Ordernar de A-Z"),
               value: OrderOptions.orderaz,
             ),
             const PopupMenuItem<OrderOptions>(
               child: Text("Ordernar de Z-A"),
               value: OrderOptions.orderza,
             )
            ],
            onSelected: _orderList,
           )
         ],
       ),
       backgroundColor: Colors.white,
       floatingActionButton: FloatingActionButton(
         onPressed: () {
           _showContactPage();
         },
         child: Icon(Icons.add),
         backgroundColor: Colors.red,
       ),
       body: ListView.builder( 
         padding: EdgeInsets.all(10.0),
         itemCount: contacts.length,
         itemBuilder: (context ,index){
           return _contactCard(context, index);
         },
       ),
     );
   }
   Widget _contactCard(BuildContext context, int index){
     return GestureDetector(
       child: Card(
         child: Padding(
           padding: EdgeInsets.all(10),
           child: Row(
             children: [
               Container(
                 width: 80,
                 height: 80,
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   image: DecorationImage(
                      image: contacts[index].img != null ? 
                        FileImage(File(contacts[index].img)) : 
                          AssetImage('images/person.png')
                   ),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.only(left: 10.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(contacts[index].name ?? "",
                      style: TextStyle(fontSize: 22, 
                        fontWeight: FontWeight.bold),
                     ),
                     Text(contacts[index].email ?? "",
                      style: TextStyle(fontSize: 18, 
                        fontWeight: FontWeight.bold),
                     ),
                     Text(contacts[index].phone ?? "",
                      style: TextStyle(fontSize: 18 , 
                        fontWeight: FontWeight.bold),
                     )
                   ],
                 ),
               )
             ],
           ),
         ),
       ),
       onTap: () {
         _showOptions(context, index);
       },
     );
   }
  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
      context: context, builder: (context){
        return BottomSheet(onClosing: () {}, builder: (context){
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: (){
                        launch("tel:${contacts[index].phone}");
                        Navigator.pop(context);
                      }, child: Text("Ligar",style: TextStyle(color: Colors.red, fontSize: 20.0),)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                        _showContactPage(contact: contacts[index]);
                      }, child: Text("Editar",style: TextStyle(color: Colors.red, fontSize: 20.0),)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: (){
                        helper.deleteContact(contacts[index].id);
                        setState(() {
                          contacts.removeAt(index);
                          Navigator.pop(context);
                        });

                      }, child: Text("Excluir",style: TextStyle(color: Colors.red, fontSize: 20.0),)
                    ),
                  ),
              ],
            ),
          );
        });
      });
  }
  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
      context,
        MaterialPageRoute(
          builder: (context) => 
            ContactPage(contact: contact,)
        )
      );
      if(recContact != null){
        if(contact != null){
          print(recContact);
          await helper.updateContact(recContact);
          print('checo1');
          print(contact);
          _getAllContacts();
          print('checo');
          print(contact);


        }else{
          await helper.saveContact(recContact);
        }
        _getAllContacts();
      }    
  }
  void _getAllContacts(){
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
      print('checo 3');
      print(list);
    });
  }
  void _orderList(OrderOptions result) {
        switch(result){
      case OrderOptions.orderaz:
        contacts.sort((a, b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {
      
    });
  }
  
 }