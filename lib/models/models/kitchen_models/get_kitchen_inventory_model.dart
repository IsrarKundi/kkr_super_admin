// To parse this JSON data, do
//
//     final getKitchenInventoryModel = getKitchenInventoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetKitchenInventoryModel getKitchenInventoryModelFromJson(String str) => GetKitchenInventoryModel.fromJson(json.decode(str));

String getKitchenInventoryModelToJson(GetKitchenInventoryModel data) => json.encode(data.toJson());

class GetKitchenInventoryModel {
    bool success;
    String message;
    Data data;

    GetKitchenInventoryModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GetKitchenInventoryModel.fromJson(Map<String, dynamic> json) => GetKitchenInventoryModel(
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
    List<Inventory> inventory;
    Pagination pagination;

    Data({
        required this.inventory,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        inventory: List<Inventory>.from(json["inventory"].map((x) => Inventory.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "inventory": List<dynamic>.from(inventory.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class Inventory {
    String id;
    String itemId;
    String itemName;
    String category;
    String measuringUnit;
    int currentStock;
    String kitchenSection;
    String status;
    DateTime createdAt;
    DateTime updatedAt;

    Inventory({
        required this.id,
        required this.itemId,
        required this.itemName,
        required this.category,
        required this.measuringUnit,
        required this.currentStock,
        required this.kitchenSection,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        id: json["id"],
        itemId: json["itemId"],
        itemName: json["itemName"],
        category: json["category"],
        measuringUnit: json["measuringUnit"],
        currentStock: json["currentStock"],
        kitchenSection: json["kitchenSection"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "itemId": itemId,
        "itemName": itemName,
        "category": category,
        "measuringUnit": measuringUnit,
        "currentStock": currentStock,
        "kitchenSection": kitchenSection,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

class Pagination {
    int total;
    String page;
    String limit;
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
