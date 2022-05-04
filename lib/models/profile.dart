import 'package:flutter/cupertino.dart';

class UserProfile {
  String id;
  String displayName;
  String photoUrl;
  String email;
  UserProfile(
    this.id,
    this.displayName,
    this.photoUrl,
    this.email,
  );
  factory UserProfile.fromJson(String id, Map<String, dynamic> json) {
    return UserProfile(
        id, json['displayName'], json['photoUrl'], json['email']);
  }
}
