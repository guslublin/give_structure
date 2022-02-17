import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:give_structure/src/models/prices.dart';

class PriceProvider {
  CollectionReference _ref;
  PriceProvider(){
    _ref = FirebaseFirestore.instance.collection('Prices');
  }
  Future<Prices> getAll() async {
    DocumentSnapshot document = await _ref.doc('info').get();
    Prices prices = Prices.fromJson(document.data());
    return prices;
  }
}