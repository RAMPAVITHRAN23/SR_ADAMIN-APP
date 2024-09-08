import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medx_admin/Pojo/pharmacyDetailsPojo.dart';
import 'package:medx_admin/Service/authService.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var divHeight, divWidth;
  String? email, password,address,pharmacyName,phone;
  bool _obscureText = false;
  GetStorage userDetails=GetStorage();
  PharmacyDetails pharmacyDetails=PharmacyDetails();

  @override
  Widget build(BuildContext context) {
    divHeight = MediaQuery
        .of(context)
        .size
        .height;
    divWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Login', style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold
          ),),
          centerTitle: true,

        ),
        body:

        SingleChildScrollView(child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  Image.asset("assets/signup.png", height: divHeight * 0.20,),
                  SizedBox(height: divHeight * 0.02,),
                  TextField(
                    onChanged: (val) {
                      pharmacyName = val;
                    },
                    decoration: InputDecoration(
                        labelText: "PharmacyName",
                        prefixIcon: Icon(Icons.local_pharmacy),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)

                        )
                    ),
                  ),
                  SizedBox(height: divHeight * 0.02,),

                  TextField(
                    onChanged: (val) {
                      email = val;
                    },
                    decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)

                        )
                    ),
                  ),
                  SizedBox(height: divHeight * 0.02,),
                  TextField(
                    onChanged: (val) {
                      password = val;
                    },
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: _obscureText ? IconButton(
                          icon: Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ) : IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),


                        prefixIcon: Icon(Icons.key),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)

                        )
                    ),
                  ),
                  SizedBox(height: divHeight * 0.02,),
                  TextField(
                    minLines: 1,
                    maxLines: 4,
                    onChanged: (val) {
                      phone = val;
                    },
                    decoration: InputDecoration(
                        labelText: "Phone",
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)

                        )
                    ),
                  ),

                  SizedBox(height: divHeight * 0.02,),
                  TextField(
                    minLines: 1,
                    maxLines: 4,
                    onChanged: (val) {
                      address = val;
                    },
                    decoration: InputDecoration(
                        labelText: "Address",
                        prefixIcon: Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)

                        )
                    ),
                  ),

                  SizedBox(height: divHeight * 0.04,),
                  InkWell(
                    onTap: () async {
                      EasyLoading.show(status: "Loading");
                      pharmacyDetails.pharmacyname=pharmacyName;
                      pharmacyDetails.phone=phone;
                      pharmacyDetails.email=email;
                      pharmacyDetails.address=address;
                      await userDetails.write("pharmacyname", pharmacyDetails.pharmacyname);
                      await userDetails.write("phone", pharmacyDetails.phone);
                      await userDetails.write("email", pharmacyDetails.email);

                      await userDetails.write("address", pharmacyDetails.address);
                      if(await FetchLatLong(address!)) {
                        await userDetails.write("latlng", pharmacyDetails.latlng);
                        await userDetails.write("geoHash", pharmacyDetails.geoHash);
                        await AuthService().CreateAccount(
                          email: email.toString(),
                          password: password.toString(),
                          pharmacyDetails: pharmacyDetails,);
                      }
                      else{

                      }
                    },
                    child: Container(
                      height: divHeight * 0.08,

                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(25),

                      ),
                      child: Center(
                        child: Text("SignUp", style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),),
                      ),
                    ),),


                ]
            )
        )
        )

    );
  }
  Future<bool> FetchLatLong(String address) async{
    String targetAddress = address;
    try {
      List<Location> locations = await locationFromAddress(
          targetAddress!);
      if (locations != null && locations.isNotEmpty) {
        Location location = locations[0];
        GeoHasher geoHasher = GeoHasher();
        double latitude1 = location.latitude;
        double longitude1 = location.longitude;
        String geoHasH=geoHasher.encode(latitude1, longitude1,precision: 5);
       // await DBServiGeoHasher geoHasher = GeoHasher();ce().updatePharamacy(documents[index].id,geoHasH );
        pharmacyDetails.geoHash=geoHasH;
        pharmacyDetails.latlng=[latitude1,longitude1];
        return true;
      }
      return false;
    }
    catch(e){
      EasyLoading.showError(e.toString());
      return false;
    }
  }
}

