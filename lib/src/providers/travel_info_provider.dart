import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:give_structure/src/models/travel_info.dart';

class TravelInfoProvider{
  CollectionReference _ref;
  TravelInfoProvider(){
    _ref = FirebaseFirestore.instance.collection('TravelInfo');
  }

  Future<void> create(TravelInfo travelInfo){
    String errorMessage;
    try{
      return _ref.doc(travelInfo.id).set(travelInfo.toJson());
    } catch(error) {
      errorMessage = error.code;
    }

    if (errorMessage != null){
      return Future.error(errorMessage);
    }
  }


  Future<void> update(Map<String, dynamic> data, String id){
    return _ref.doc(id).update(data);
  }
}