import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medx_admin/Pojo/pharmacyDetailsPojo.dart';
import 'package:medx_admin/Pojo/productDetailsPojo.dart';

class DBService{

  final firestore=FirebaseFirestore.instance;
  CreateUser({
required PharmacyDetails pharmacyDetails
}){
 firestore.collection("PharmacyUsers").doc(pharmacyDetails.uid).set(pharmacyDetails.toJson());
}

addProduct({required ProductDetails productDetails}) async{
    await firestore.collection("Products").doc(productDetails.docId).set(productDetails.toJson());
}

Future<bool> checkProductExist({required String docId}) async{
  DocumentSnapshot documentSnapshot = await firestore.collection("Products").doc(docId).get();
  return documentSnapshot.exists;
}

FetchUserDetails(String uid)async {
return await firestore.collection("PharmacyUsers").doc(uid).get();
}
 Stream YourProducts(String pharmacyname) {
    return  firestore.collection("Products").where("availableAt", arrayContains: pharmacyname).snapshots();

 }
  Stream Products() {
    return  firestore.collection("Products").snapshots();

  }
  addProductstoInventory({required ProductDetails productDetails}){
    return firestore.collection("Products").doc(productDetails.productname).update(productDetails.toJson());
}

}