import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:give_structure/src/models/travel_info.dart';

class TravelInfoProvider{
  CollectionReference _ref;

  TravelInfoProvider(){
    _ref = FirebaseFirestore.instance.collection('TravelInfo');
  }

  Stream<DocumentSnapshot> getByIdStream(String id){
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<void> create(TravelInfo travelInfo){
    String errorMessage;
    print("create travel info: ${travelInfo.fromLat}, ${travelInfo.fromLng}");
    try{
      return _ref.doc(travelInfo.id).set(travelInfo.toJson());
    } catch(error) {
      errorMessage = error.code;
    }

    if (errorMessage != null){
      return Future.error(errorMessage);
    }
  }

  Future<TravelInfo> getById(String id) async{
    DocumentSnapshot document = await _ref.doc(id).get();
    if (document.exists) {
      TravelInfo travelInfo= TravelInfo.fromJson(document.data());
      print("travelInfo: ${travelInfo.fromLat}, ${travelInfo.fromLng}");
      return travelInfo;
    }
    return null;
  }

  Future<void> update(Map<String, dynamic> data, String id){
    return _ref.doc(id).update(data);
  }
}