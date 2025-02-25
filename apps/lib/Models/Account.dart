import 'dart:convert';
import 'dart:typed_data';


class Account {
  late int userNumber;
  late String name;
  late String token;
  late Uint8List photo;
  late String phoneNumber;
  late String codeTel;
  late String resetToken;
  late String email;
  late String password;
  late String role;
  late bool isAccountNonLocked;
  late bool isAccountNonExpired;
  late bool isCredentialsNonExpired;
  late bool isEnabled;


  Account(
      {required this.userNumber,
        required this.name,
        required this.token,
        required this.photo,
        required this.phoneNumber,
        required this.codeTel,
        required this.resetToken,
        required this.email,
        required this.password,
        required this.role

      });



  // Convert the object to a Map
  Map<String, dynamic> toJson() {
    return {
      'userNumber': userNumber,
      'name': name,
      'token': token,
      'photo': photo,
      'phoneNumber': phoneNumber,
      'codeTel': codeTel,
      'resetToken': resetToken,
      'email': email,
      'password': password,
      'role': role,

    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      userNumber: json['userNumber'] ?? 0,
      name: json['name'] ?? '',
      token: json['token'] ?? '',
      photo: base64.decode(json['photo']),
      phoneNumber: json['phoneNumber'] ?? '',
      codeTel: json['codeTel'] ?? '',
      resetToken: json['resetToken'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',


    );
  }



}

