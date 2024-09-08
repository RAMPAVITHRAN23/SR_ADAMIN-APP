class ProductDetails{
  String? productname;
  String? currentPrice;
  String? lastPrice;
  String? productQuantity;
  String? descrption;
  String? quantityType;
  String? productImage;
  String? docId;
  List? availableAt;
  Map? availablePharmacyLocation;

  ProductDetails({this.productname,
    this.currentPrice,
    this.lastPrice,
    this.productQuantity,
    this.descrption,
    this.quantityType,
    this.productImage,
    this.docId,
    this.availableAt,
    this.availablePharmacyLocation,
  });

  ProductDetails.fromJson(Map<String, dynamic> json) {
    productname = json['productname'];
    currentPrice = json['currentPrice'];
    lastPrice = json['lastPrice'];
    productQuantity=json["productQuantity"];
    descrption=json['descrption'];
    quantityType=json['quantityType'];
    productImage=json['productImage'];
    docId=json['docId'];
    availableAt=json['availableAt'];
    availablePharmacyLocation=json['availablePharmacyLocation'];
  }

  Map<String, dynamic> toJson() {

    return {
      "productname":productname,
      "currentPrice":currentPrice,
      "lastPrice":lastPrice,
      "productQuantity":productQuantity,
      "descrption":descrption,
      "quantityType":quantityType,
      "productImage":productImage,
      "docId":docId,
      'availableAt':availableAt,
      'availablePharmacyLocation':availablePharmacyLocation,
    }..removeWhere((key, value) => value == null);
  }
}