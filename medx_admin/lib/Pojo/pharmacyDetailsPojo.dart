class PharmacyDetails {
  String? pharmacyname;
  String? email;
  String? phone;
  String? uid;
  String? address;
  List<dynamic>? latlng;
  String? geoHash;

  PharmacyDetails({this.pharmacyname,
    this.email,
    this.phone,
    this.uid,
    this.address,
    this.latlng,
    this.geoHash,
  });

  PharmacyDetails.fromJson(Map<String, dynamic> json) {
    pharmacyname = json['pharmacyname'];
    email = json['email'];
    phone = json['phone'];
    uid=json["uid"];
    address=json['address'];
    latlng=json['latlng'];
    geoHash=json['geoHash'];
  }

  Map<String, dynamic> toJson() {

    return {
      "pharmacyname":pharmacyname,
      "email":email,
      "phone":phone,
      "uid":uid,
      "address":address,
      "latlng":latlng,
      "geoHash":geoHash,
    }..removeWhere((key, value) => value == null);
  }
}