import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medx_admin/Pojo/productDetailsPojo.dart';
import 'package:medx_admin/Screens/addproduct.dart';
import 'package:medx_admin/Screens/loading.dart';
import 'package:medx_admin/Service/dbService.dart';
class OthersProducts extends StatefulWidget {
  const OthersProducts({super.key});

  @override
  State<OthersProducts> createState() => _OthersProductsState();
}

class _OthersProductsState extends State<OthersProducts> {
  var divHeight, divWidth;
  File? image;
  DBService dbService=DBService();
  GetStorage userDetails=GetStorage();
  ProductDetails productDetails=ProductDetails();
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
    String pharmacyname=userDetails.read("pharmacyname");
    return StreamBuilder(stream:dbService.Products(), builder:(context,snapshot)
    {
      if(!snapshot.hasData) return Loading();
      QuerySnapshot querySnapshot=snapshot.data;
      List<DocumentSnapshot> documents=querySnapshot.docs;
      int documentLenght=documents.length;


      return Scaffold(
        appBar: AppBar(
          title: Text("New Products", style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17
          ),),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(10,10,10,10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[

                    Wrap(
                      direction: Axis.horizontal,

                      children:
                      List.generate(
                        documentLenght,
                            (index)
                        {

                          Map<String,dynamic> data=documents[index].data() as Map<String,dynamic>;
                          productDetails=ProductDetails.fromJson(data);
                          List Available=productDetails.availableAt!.toList();
                          if(Available.contains(pharmacyname)){
                            return Container();
                          }
                          return Product(productDetails: productDetails);
                        },),


                    )



                  ]
              )
          ),

        ),

        /*floatingActionButton: FloatingActionButton.extended(onPressed: () {
          Get.to(() => AddProducts(), transition: Transition.rightToLeft);
        }, label: Text("Add Products")),*/
      );
    }
    );
  }

  Widget Product({required ProductDetails productDetails}){

    return Padding(padding:EdgeInsets.fromLTRB(5,10,20,10),child:InkWell(
        onTap: (){
         AlertBox(context,productDetails);
        },
        child:Container(
            width: divWidth*0.41, // Minimum width

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(width: 1.0,color: Colors.teal)
            ),

            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: divHeight*0.02,),
                  Align(
                    alignment: Alignment.topCenter,
                    child:Image.network(productDetails.productImage.toString(), height: divHeight*0.08,width: divWidth*0.20,fit:BoxFit.fill),),
                  SizedBox(height: divHeight*0.02,),
                  Text(productDetails.productname.toString(),style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold

                  ),),
                  Text(productDetails.productQuantity.toString()+productDetails.quantityType.toString(),style: TextStyle(
                      color: Colors.black45
                  ),),
                  SizedBox(height: divHeight*0.01,),
                  Row(children:[Text("₹"+productDetails.currentPrice.toString(),style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold

                  ),),
                    SizedBox(width: divWidth*0.03,),
                    productDetails.lastPrice!=null && productDetails.lastPrice.toString().isNotEmpty  ?
                    RichText(
                      text: TextSpan(
                        text: "₹"+productDetails.lastPrice.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.black, // Optional: Set the color of the strikethrough line
                          decorationThickness: 2.0, // Optional: Set the thickness of the strikethrough line
                        ),
                      ),
                    ):Text(""),

                  ])



                ],
              ),
            )
        )
    )

    );

  }
  Future AlertBox(BuildContext context,ProductDetails productDetails){

    return showDialog(context: context, builder: (BuildContext context){

      var  ProductDetailsPojo=productDetails;
      return AlertDialog(

          content: Container(
            height: divHeight*0.59,
            width: divWidth*0.90,
            child:Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  //  SizedBox(height: divHeight*0.04,),


                  SizedBox(height: divHeight*0.01,),
                  Text("Do you want to add this product in your inventory ",style:
                  TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),),
SizedBox(height: divHeight*0.02,),
                  Image.network(ProductDetailsPojo.productImage.toString(),height: divHeight*0.20,width: divWidth*70,),
                  SizedBox(height: divHeight*0.03,),

                  InkWell(
                      onTap:() async{
                        EasyLoading.show(status: "Adding");
                        var PharmacyName=userDetails.read("pharmacyname");
                        List latlng=userDetails.read("latlng");
                        var geoHash=userDetails.read("geoHash");
                        ProductDetailsPojo.availableAt!.add(PharmacyName);
                        ProductDetailsPojo.availablePharmacyLocation![PharmacyName]=[latlng[0],latlng[1],geoHash];

                        await dbService.addProductstoInventory(productDetails: ProductDetailsPojo);
                        EasyLoading.dismiss();
                        Get.back();
                        // Get.offAll(BottomBar());
                      },child:Container(
                      width: divWidth*0.90,
                      height: divHeight*0.07,
                      decoration: BoxDecoration(
                          color: Colors.teal[400],
                          borderRadius: BorderRadius.circular(45)
                      ),
                      child:Center(

                          child:Text("Yes",style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),)
                      )
                  )
                  ),
                  SizedBox(height:divHeight*0.02,),
                  InkWell(
                      onTap:() async{

                        Get.back();
                        // Get.offAll(BottomBar());
                      },child:Container(
                      width: divWidth*0.90,
                      height: divHeight*0.07,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal,width: 1.0),
                          borderRadius: BorderRadius.circular(45)
                      ),
                      child:Center(

                          child:Text("Cancel",style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                          ),)
                      )
                  )
                  ),

                ],
              ),
            ),
          )
      );
    });
  }
}
