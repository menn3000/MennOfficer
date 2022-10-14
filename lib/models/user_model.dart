import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String id;
  final String type;
  final String name;
  final String user;
  final String password;
  final String? idJob; // cursor behide comma and light bulb to json serializeation
  
  UserModel({
    required this.id,
    required this.type,
    required this.name,
    required this.user,
    required this.password,
    this.idJob,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'name': name,
      'user': user,
      'password': password,
      'idJob': idJob,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: (map['id'] ?? '') as String,
      type: (map['type'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      user: (map['user'] ?? '') as String,
      password: (map['password'] ?? '') as String,
      idJob: map['idJob'] != null ? map['idJob'] as String : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
