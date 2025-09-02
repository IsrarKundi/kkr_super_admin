// To parse this JSON data, do
//
//     final getInventoryModel = getInventoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetInventoryModel getInventoryModelFromJson(String str) => GetInventoryModel.fromJson(json.decode(str));

String getInventoryModelToJson(GetInventoryModel data) => json.encode(data.toJson());

class GetInventoryModel {
    bool success;
    String message;
    Data data;

    GetInventoryModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GetInventoryModel.fromJson(Map<String, dynamic> json) => GetInventoryModel(
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
    List<CurrentInventory> currentInventory;
    Pagination pagination;

    Data({
        required this.currentInventory,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentInventory: List<CurrentInventory>.from(json["currentInventory"].map((x) => CurrentInventory.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "currentInventory": List<dynamic>.from(currentInventory.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class CurrentInventory {
    String itemId;
    String name;
    String category;
    String measuringUnit;
    int currentStock;
    int pricePerUnit;
    int totalValue;
    String status;

    CurrentInventory({
        required this.itemId,
        required this.name,
        required this.category,
        required this.measuringUnit,
        required this.currentStock,
        required this.pricePerUnit,
        required this.totalValue,
        required this.status,
    });

    factory CurrentInventory.fromJson(Map<String, dynamic> json) => CurrentInventory(
        itemId: json["itemId"],
        name: json["name"],
        category: json["category"],
        measuringUnit: json["measuringUnit"],
        currentStock: json["currentStock"],
        pricePerUnit: json["pricePerUnit"],
        totalValue: json["totalValue"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "name": name,
        "category": category,
        "measuringUnit": measuringUnit,
        "currentStock": currentStock,
        "pricePerUnit": pricePerUnit,
        "totalValue": totalValue,
        "status": status,
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
