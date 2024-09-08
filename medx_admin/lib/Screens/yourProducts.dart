import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medx_admin/Pojo/productDetailsPojo.dart';
import 'package:medx_admin/Screens/addproduct.dart';
import 'package:medx_admin/Screens/loading.dart';
import 'package:medx_admin/Service/dbService.dart';

class YourProducts extends StatefulWidget {
  const YourProducts({super.key});

  @override
  State<YourProducts> createState() => _YourProductsState();
}

class _YourProductsState extends State<YourProducts> {
  var divHeight, divWidth;
  File? image;
  DBService dbService = DBService();
  GetStorage userDetails = GetStorage();
  ProductDetails productDetails = ProductDetails();
  @override
  Widget build(BuildContext context) {
    divHeight = MediaQuery.of(context).size.height;
    divWidth = MediaQuery.of(context).size.width;
    print(userDetails.read("pharmacyname"));
    return StreamBuilder(
        stream: dbService.YourProducts(userDetails.read("pharmacyname")),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Loading();
          QuerySnapshot querySnapshot = snapshot.data;
          List<DocumentSnapshot> documents = querySnapshot.docs;
          int documentLenght = documents.length;
          print(documentLenght);
          userDetails.write("totalProducts", documentLenght);
          // print(documents[0].data());
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Your Products",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          direction: Axis.horizontal,
                          children: List.generate(
                            documentLenght,
                            (index) {
                              Map<String, dynamic> data = documents[index]
                                  .data() as Map<String, dynamic>;
                              productDetails = ProductDetails.fromJson(data);

                              return Product(productDetails: productDetails);
                            },
                          ),
                        )
                      ])),
            ),
            floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Get.to(() => AddProducts(),
                      transition: Transition.rightToLeft);
                },
                label: Text("Add Products")),
          );
        });
  }

  Widget Product({required ProductDetails productDetails}) {
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 10, 20, 10),
        child: InkWell(
            onTap: () {
              //  Get.to(DrugDetails(productImage: ProductImage, productName: ProductName, productQuantity: ProductQunatity, productPrice: ProductPrice, productRating: 3,),transition: Transition.rightToLeft);
            },
            child: Container(
                width: divWidth * 0.41, // Minimum width

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(width: 1.0, color: Colors.teal)),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: divHeight * 0.02,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Image.network(
                            productDetails.productImage.toString(),
                            height: divHeight * 0.08,
                            width: divWidth * 0.20,
                            fit: BoxFit.fill),
                      ),
                      SizedBox(
                        height: divHeight * 0.02,
                      ),
                      Text(
                        productDetails.productname.toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        productDetails.productQuantity.toString() +
                            productDetails.quantityType.toString(),
                        style: TextStyle(color: Colors.black45),
                      ),
                      SizedBox(
                        height: divHeight * 0.01,
                      ),
                      Row(children: [
                        Text(
                          "₹" + productDetails.currentPrice.toString(),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: divWidth * 0.03,
                        ),
                        productDetails.lastPrice != null &&
                                productDetails.lastPrice.toString().isNotEmpty
                            ? RichText(
                                text: TextSpan(
                                  text:
                                      "₹" + productDetails.lastPrice.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors
                                        .black, // Optional: Set the color of the strikethrough line
                                    decorationThickness:
                                        2.0, // Optional: Set the thickness of the strikethrough line
                                  ),
                                ),
                              )
                            : Text(""),
                      ])
                    ],
                  ),
                ))));
  }
}
