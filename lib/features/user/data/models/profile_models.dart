// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? password;
  DateTime? lastUpdated;
  Profile(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.password,
      this.lastUpdated});

  factory Profile.fromFirestore(Map<String, dynamic> map) {
    return Profile(
        firstName: map['firstName'] as String?,
        lastName: map['lastName'] as String?,
        email: map['email'] as String?,
        phone: map['phone'] as String?,
        password: map['password'] as String?,
        lastUpdated: map['lastUpdated'] != null
            ? (map['lastUpdated'] as Timestamp).toDate()
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'lastUpdated':
          lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null
    };
  }
}
