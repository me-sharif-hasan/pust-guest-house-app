import 'package:flutter/material.dart';

class User {
  int? id;
  String? name;
  String? email;
  String? password;
  String? department;
  String? phone;
  String? title;

  User(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.department,
      this.phone,
      this.title});

  factory User.fromJson(Map<String, dynamic> json) {
    // print("parse json is : $json");
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        department: json['department'],
        phone: json['phone'],
        title: json['title']);
  }

  Map<String, dynamic> getUser() {
    return {
      'name' : name,
      'email' : email,
      'password' : password,
      'department' : department,
      'phone' : phone,
      'title' : title,
    };
  }
}
