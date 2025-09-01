// To parse this JSON data, do
//
//     final getUsersModel = getUsersModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetUsersModel getUsersModelFromJson(String str) => GetUsersModel.fromJson(json.decode(str));

String getUsersModelToJson(GetUsersModel data) => json.encode(data.toJson());

class GetUsersModel {
    bool success;
    String message;
    Data data;

    GetUsersModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GetUsersModel.fromJson(Map<String, dynamic> json) => GetUsersModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    List<User> users;
    Pagination pagination;

    Data({
        required this.users,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class Pagination {
    int total;
    int page;
    int limit;
    int totalPages;
    bool hasNext;
    bool hasPrev;

    Pagination({
        required this.total,
        required this.page,
        required this.limit,
        required this.totalPages,
        required this.hasNext,
        required this.hasPrev,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        hasNext: json["hasNext"],
        hasPrev: json["hasPrev"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
        "hasNext": hasNext,
        "hasPrev": hasPrev,
    };
}

class User {
    String id;
    String username;
    String role;
    DateTime createdAt;
    dynamic lastActive;

    User({
        required this.id,
        required this.username,
        required this.role,
        required this.createdAt,
        required this.lastActive,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        lastActive: json["lastActive"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "lastActive": lastActive,
    };
}
