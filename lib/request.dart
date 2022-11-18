import 'package:cloud_firestore/cloud_firestore.dart';

class Peticiones{
  final List listHorario = [];



  void getdatetime() async {
    CollectionReference collectionHorarios =
        FirebaseFirestore.instance.collection("horarios");
    QuerySnapshot horarios = await collectionHorarios.get();
    print("horarios: " + horarios.docs.length.toString());

    if (horarios.docs.length > 0) {
      for (var i in horarios.docs) {
        listHorario.add(i.data());
        print(i.data());
      }
    }
  }



}