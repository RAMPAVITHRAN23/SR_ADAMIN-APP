import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medx_admin/Authentication/signIn.dart';
import 'package:medx_admin/Pojo/pharmacyDetailsPojo.dart';
import 'package:medx_admin/Screens/bottomNavbar.dart';
import 'package:medx_admin/Service/dbService.dart';


class AuthService{


  final _auth=FirebaseAuth.instance;
  GetStorage userDetails=GetStorage();
  DBService dbService=DBService();
  PharmacyDetails pharmacyDetails=PharmacyDetails();



  CreateAccount({
    required String email,
    required String password,
    required PharmacyDetails pharmacyDetails,
}) async{
    try{
      UserCredential credential=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      String uid=credential.user!.uid;
      userDetails.write("uid", uid);
      pharmacyDetails.uid=uid;
      await dbService.CreateUser(pharmacyDetails: pharmacyDetails);
      Get.offAll( BottomBar());
      EasyLoading.dismiss();
    }catch(e){
      EasyLoading.showError(e.toString());


    }
  }

  Login({required String email,
  required String password
  }) async{
    try{
      UserCredential userCredential=await _auth.signInWithEmailAndPassword(email: email, password: password);

      String uid=userCredential.user!.uid;
      DocumentSnapshot documentSnapshot=await dbService.FetchUserDetails(uid);
      Map<String,dynamic> data=documentSnapshot.data() as Map<String,dynamic>;
      pharmacyDetails=PharmacyDetails.fromJson(data);

      await userDetails.write("uid",uid);
      await userDetails.write("address", pharmacyDetails.address);
      await userDetails.write("pharmacyname", pharmacyDetails.pharmacyname);
      await userDetails.write("latlng", pharmacyDetails.latlng);
      await userDetails.write("geoHash", pharmacyDetails.geoHash);
      await userDetails.write("phone", pharmacyDetails.phone);
      await userDetails.write("email", pharmacyDetails.email);
      Get.offAll( BottomBar());
      EasyLoading.dismiss();
    }catch (e){
      EasyLoading.showError(e.toString());
    }
  }

  SignOut()async{
    try{
      await _auth.signOut();
      userDetails.erase();
      Get.offAll(SignIn());
      EasyLoading.dismiss();
    }catch (e){
      EasyLoading.showError(e.toString());
    }
  }
}