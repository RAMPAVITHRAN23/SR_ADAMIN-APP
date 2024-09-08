import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medx_admin/Pojo/productDetailsPojo.dart';
import 'package:medx_admin/Service/dbService.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({Key? key}) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  late double divHeight, divWidth;
  File? image;
  String? productname,productQuantity,currentPrice,LastPrice,descrption;
  final key=GlobalKey<FormState>();
  var quantityType="ml";
  ProductDetails productDetails=ProductDetails();
  DBService dbService=DBService();
  GetStorage userDetails=GetStorage();

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
    productDetails.quantityType=quantityType;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key:key,
            child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                height: divHeight*0.20,
                width: divWidth*0.90,
                decoration: BoxDecoration(
                 // borderRadius: BorderRadius.circular(),
                  border: Border.all(width: 1.0,color: Colors.teal)

                ),
                child: image != null
                    ? InkWell(child:Image.file(image! as File, fit: BoxFit.cover),onTap: (){
                      AlertBox(context);
                },)
                    : IconButton(
                  onPressed: () async {
                    var Images = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (Images == null) return;

                    setState(() {
                      image = File(Images.path);
                    });
                  },
                  icon: Icon(
                    Icons.add,

                  ),
                ),
              ),
              SizedBox(height: divHeight*0.02,),
              TextFormField(
                validator: (val){
                  if(val!.isEmpty){
                    return "enter the product name";
                  }
                },
                onChanged: (val){
                  if(val!.isNotEmpty) {
                    productname=val;
                    productDetails.productname =
                        val[0].toUpperCase() + val.substring(1,).toLowerCase();
                  }
                },
                onFieldSubmitted: (val) async{
                  productDetails.docId=productDetails.productname.toString().replaceAll(" ", '').toLowerCase();
                 bool Exist= await DBService().checkProductExist(docId: productDetails.productname.toString());
                 if(Exist){
                   AlertBox(context);
                 }


                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.medical_services_outlined),
                    labelText: "Product Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),

                    )
                ),
              ),
              SizedBox(height: divHeight*0.02,),
              TextFormField(
                validator: (val){
                  if(val!.isEmpty){
                    return "enter the pieces or ml";
                  }
                },
                onChanged: (val){
                  productDetails.productQuantity=val;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.pie_chart_sharp),
                    suffixIconColor: Colors.black,

                  // suffixText: "ml",
                   // suffixIcon: IconButton(icon: Icon(Icons.wate),),
                    suffix: InkWell(
                      onTap: (){
                        setState(() {
                          if(quantityType=="ml") {
                            quantityType = "pcs";
                          }
                          else{
                            quantityType="ml";
                          }

                        });
                      },
                      child: Text(quantityType,style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.black
                      ),),
                    ),
                    labelText: "Pieces or ml per product",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),

                    )
                ),
              ),
              SizedBox(height: divHeight*0.02,),
              TextFormField(
                validator: (val){
                  if(val!.isEmpty){
                    return "enter the Current Price";
                  }
                },
                keyboardType: TextInputType.number,
                onChanged: (val){
                  productDetails.currentPrice=val;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.currency_rupee),
                    labelText: "Current Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),

                    )
                ),
              ),
              SizedBox(height: divHeight*0.02,),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (val){
                  productDetails.lastPrice=val;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.currency_rupee),
                    labelText: "Last Price (optional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),

                    )
                ),
              ),
              SizedBox(height: divHeight*0.02,),
              TextFormField(
                minLines: 1,
                maxLines: 10,
                validator: (val){
                  if(val!.isEmpty){
                    return "enter the descrption";
                  }
                },
                onChanged: (val){
                  productDetails.descrption=val;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.edit_note),
                    labelText: "Product descrption",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),

                    )
                ),
              ),

              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[Product(productDetails: productDetails),]),
              InkWell(
                onTap: () async {
                 List latlng=userDetails.read("latlng");
                 var pharmacyName=userDetails.read("pharmacyname");
                 var geoHash=userDetails.read("geoHash");

                 productDetails.availablePharmacyLocation={pharmacyName:[latlng[0],latlng[1],geoHash]};
                // print(productDetails.availablePharmacyLocation);
                  if(key.currentState!.validate()) {
                    EasyLoading.show(status: "Loading");
                    productDetails.docId =
                        productDetails.productname.toString().replaceAll(
                            " ", '').toLowerCase();


                    bool Exist = await DBService().checkProductExist(
                        docId: productDetails.docId.toString());
                    if (!Exist) {

                      List Available = [];
                      Available.add(pharmacyName);
                      productDetails.availableAt = Available;


                      productDetails.productImage = await uploadImage(
                          productDetails.productname.toString(), image);
                     // print(productDetails.availableAt);
                      await DBService().addProduct(
                          productDetails: productDetails);
                      EasyLoading.showSuccess("Product Added");
                      key.currentState!.reset();
                      setState(() {
                        image=null;
                      });
                      productDetails.productname=null;
                      productDetails.currentPrice=null;
                      productDetails.lastPrice=null;
                      productDetails.productQuantity=null;
                      productDetails.descrption=null;
                      EasyLoading.dismiss();
                    }
                    else {
                      EasyLoading.showError("Product already Exist");
                    }
                  }
                },
                child: Container(
                  height: divHeight * 0.08,

                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(25),

                  ),
                  child: Center(
                    child: Text("Add", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),),
                  ),
                ),),
            ],
          ),
        ),
      ),
      )
    );
  }


  Future<String?> uploadImage(String name, File? imageFile) async {
    try {
      if (imageFile != null) {
        Reference reference =
        FirebaseStorage.instance.ref().child(name);
        UploadTask uploadTask = reference.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        return downloadUrl;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future AlertBox(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context){

      return AlertDialog(

          content: Container(
            height: divHeight*0.25,
            width: divWidth*0.90,
            child:Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                //  SizedBox(height: divHeight*0.04,),

                  SizedBox(height: divHeight*0.03,),
                  Text("Do you want to",style:
                  TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),),
                  SizedBox(height: divHeight*0.01,),
                  Text("Change the image ",style:
                  TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),),

                  SizedBox(height: divHeight*0.03,),

                  InkWell(
                      onTap:() async{
                        var Images = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (Images == null) return;

                        setState(() {
                          image = File(Images.path);
                        });
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

                ],
              ),
            ),
          )
      );
    });
  }
  Widget Product({required ProductDetails productDetails}){

    return Padding(padding:EdgeInsets.fromLTRB(0,10,20,10),child:InkWell(
        onTap: (){
        //  Get.to(DrugDetails(productImage: ProductImage, productName: ProductName, productQuantity: ProductQunatity, productPrice: ProductPrice, productRating: 3,),transition: Transition.rightToLeft);
        },
        child:Container(

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
                  image!=null ? Image.file(image! as File, height: divHeight*0.08,width: divWidth*0.20,fit:BoxFit.fill) :Text(""),
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
                    SizedBox(width: divWidth*0.01,),
                    productDetails.lastPrice!=null && productDetails.lastPrice.toString().isNotEmpty ?
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
                    SizedBox(width: divWidth*0.03,),
                    Align(
                      alignment: Alignment.bottomRight,
                      child:InkWell(
                          onTap: (){

                          },
                          child:Container(
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(Icons.add,color: Colors.white,),
                          )
                      ),
                    ),
                  ])



                ],
              ),
            )
        )
    )
    );
  }
}

