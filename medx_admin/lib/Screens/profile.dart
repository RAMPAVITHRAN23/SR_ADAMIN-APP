import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medx_admin/Service/authService.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late double divHeight, divWidth;
  GetStorage userDetails=GetStorage();

  @override
  Widget build(BuildContext context) {
    divHeight = MediaQuery.of(context).size.height;
    divWidth = MediaQuery.of(context).size.width;
   // final user = Provider.of<User?>(context);




        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                            fontSize: 22,
                          ),
                        ),
                      ),

                  //  SizedBox(height: divHeight * 0.05),
                    CircleAvatar(
                      radius: 65,
                     child: Text(
                       userDetails.read("pharmacyname").toString()[0].toUpperCase(),
                       style: TextStyle(
                         fontSize: 40,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     //backgroundImage: NetworkImage(data["profilePic"]),
                    ),
                    SizedBox(height: divHeight * 0.015),
                    SizedBox(height: divHeight*0.02,),
                    Text(
                      userDetails.read("pharmacyname"),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    SizedBox(height: divHeight * 0.015),
                    Text(
                      userDetails.read("address"),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                    Divider(height: divHeight * 0.05, thickness: 2.0),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        width: divWidth * 0.90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              SizedBox(height: divHeight * 0.02),
                              Row(
                                children: [
                                  Icon(Icons.email_outlined),
                                  SizedBox(width: divWidth * 0.02),
                                  Text(
                                    userDetails.read("email"),
                                    style:  TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                ],
                              ),

                              SizedBox(height: divHeight * 0.03),
                              Row(
                                children: [
                                  Icon(Icons.phone),
                                  SizedBox(width: divWidth * 0.020),
                                  Text(

                                      userDetails.read("phone"),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                ],
                              ),
                              SizedBox(height: divHeight * 0.03),
                              Row(
                                children: [
                                  Icon(Icons.production_quantity_limits),
                                  SizedBox(width: divWidth * 0.020),
                                  Text(

                                    "Total Products : "+userDetails.read("totalProducts").toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: divHeight * 0.02),
                              Divider(
                                height: divHeight * 0.04,
                                thickness: 2.0,
                              ),
                              SizedBox(height: divHeight * 0.01),

                              SizedBox(height: divHeight * 0.03),
                              InkWell(
                                onTap: () async {
                                  EasyLoading.show(status: "Logging Out");
                                  await AuthService().SignOut();
                                  EasyLoading.dismiss();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout_outlined),
                                    SizedBox(width: divWidth * 0.020),
                                    Text(
                                      "Log Out",
                                      style:  TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                    Spacer(),
                                    Icon(Icons.chevron_right),
                                    SizedBox(width: divWidth * 0.05),
                                  ],
                                ),
                              ),
                              SizedBox(height: divHeight * 0.03),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: divWidth * 0.020),
                                  Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  Spacer(),
                                  Icon(Icons.chevron_right),
                                  SizedBox(width: divWidth * 0.05),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

  }
}
