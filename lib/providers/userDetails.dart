import 'package:flutter/material.dart';

class UserDetails with ChangeNotifier {
  String weight;
  String height;
  String pastMedhx;
  String alcohol;
  bool smoker;
  String nsmoke;
  String avatarUrl;
  String firstName;
  String lastName;
  String displayName;

  UserDetails({
    this.weight,
    this.height,
    this.pastMedhx,
    this.alcohol,
    this.smoker,
    this.nsmoke,
    this.avatarUrl,
    this.firstName,
    this.lastName,
    this.displayName,
  });

  Map<String, dynamic> toJson() {
    return {
      'weight': this.weight,
      'height': this.height,
      'alcohol': this.alcohol,
      'pastMedhx': this.pastMedhx,
      'smoker': this.smoker,
      'nsmoke': this.nsmoke,
      'avatarUrl': this.avatarUrl,
      'firstName': this.firstName,
      'lastName': this.lastName,

    };
  }
  
}

UserDetails getUserDetails(record) {
  Map<String, dynamic> attributes = {
    'weight': '',
    'height': '',
    'alcohol': '',
    'pastMedhx': '',
    'smoker': false,
    'nsmoke': '',
    'firstName': '',
    'lastName': '',
  };

  record.forEach((key, value) => {attributes[key] = value});

  UserDetails userdetails = new UserDetails(
    weight: attributes['weight'],
    height: attributes['height'],
    alcohol: attributes['alcohol'],
    pastMedhx: attributes['pastMedhx'],
    smoker: attributes['smoker'],
    nsmoke: attributes['nsmoke'],
    avatarUrl: attributes['avatarUrl'],
    firstName: attributes['firstName'],
    lastName: attributes['lastName'],
    displayName: attributes['firstName'] + ' ' + attributes['lastName'],
  );
  return userdetails;

}