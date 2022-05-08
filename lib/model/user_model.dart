import 'dart:math';
class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? citizenshipNumber;
  String? pKey;
  String? area ;

  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.secondName,
      this.citizenshipNumber,
      this.area,
      this.pKey
      });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      citizenshipNumber: map['citizenshipNumber'],
      area: map['area'],
      pKey: map['pKey'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'citizenshipNumber': citizenshipNumber,
      'area':area,
      'pKey':pKey,
    };
  }
}
