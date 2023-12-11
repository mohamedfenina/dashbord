import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../colors.dart';
import '../../components.dart';
import '../../constants/constants.dart';
import '../../constants/responsive.dart';
import '../drawer_menu.dart';
import 'Categorie.dart';
import 'add_categorie_screen.dart';

class ScanScreen extends StatelessWidget {
  ScanScreen({Key? key}) : super(key: key);

  CategorieProduction _categorie = CategorieProduction();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: DrawerMenu(),
      // key: context.read<Controller>().scaffoldKey,
      body: SafeArea(
        child: Row(
          children: [
            if (Responsive.isDesktop(context))
              Expanded(child: DrawerMenu(),),

            Expanded(
              flex: 5,
              child: StreamBuilder<QuerySnapshot>(
                stream: _categorie.getCategorieStream(), // Use the function to get the stream
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}',));

                  }



                  if (snapshot.connectionState == ConnectionState.waiting ) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if(snapshot.data!.docs.isEmpty){
                    return Center(
                      child: Text('Aucune donnée disponible',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 50
                        ),),
                    );
                  }


                  return ListView.separated(
                    itemCount: snapshot.data!.docs.length,

                    itemBuilder: (context, index)   {
                      var document = snapshot.data!.docs[index];
                      String documentId = document.id;
                      String user = document['UserName'];
                      String produit = document['ProductName'];
                      int rate = document['Rate'];




                      // String code = document['code'];
                      // String documentId = document.id;

                      return CategorieItem2(
                          rate:rate ,
                          nameProduct: produit,
                          nameUser: user,
                          pressed: (){

                          },
                          delete: (){
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Suppression'),
                                content: Text('Êtes-vous sûr de vouloir supprimer cette Categorie ?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text('Non'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _categorie.Delete(documentId);
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('Oui'),
                                  ),
                                ],
                              ),
                            );

                          },
                          edit: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddRate(
                              document: documentId,
                              type: 'update',
                            ),));

                          }
                      );

                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 0,
                      );
                    },



                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => const AddRate()));

        },
        backgroundColor: mainColor,
        child: const Icon(Icons.add,
            color: Colors.white),
      ),
    );
  }
}