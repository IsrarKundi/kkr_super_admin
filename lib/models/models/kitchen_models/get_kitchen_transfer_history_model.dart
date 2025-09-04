// To parse this JSON data, do
//
//     final getKitchenTransferHistoryModel = getKitchenTransferHistoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetKitchenTransferHistoryModel getKitchenTransferHistoryModelFromJson(String str) => GetKitchenTransferHistoryModel.fromJson(json.decode(str));

String getKitchenTransferHistoryModelToJson(GetKitchenTransferHistoryModel data) => json.encode(data.toJson());

class GetKitchenTransferHistoryModel {
    bool success;
    String message;
    Data data;

    GetKitchenTransferHistoryModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GetKitchenTransferHistoryModel.fromJson(Map<String, dynamic> json) => GetKitchenTransferHistoryModel(
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
    List<History> history;
    Pagination pagination;

    Data({
        required this.history,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        history: List<History>.from(json["history"].map((x) => History.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "history": List<dynamic>.from(history.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class History {
    String id;
    String itemName;
    String category;
    String measuringUnit;
    String from;
    String to;
    int quantity;
    DateTime createdAt;
    DateTime updatedAt;

    History({
        required this.id,
        required this.itemName,
        required this.category,
        required this.measuringUnit,
        required this.from,
        required this.to,
        required this.quantity,
        required this.createdAt,
        required this.updatedAt,
    });

    factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"],
        itemName: json["itemName"],
        category: json["category"],
        measuringUnit: json["measuringUnit"],
        from: json["from"],
        to: json["to"],
        quantity: json["quantity"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "itemName": itemName,
        "category": category,
        "measuringUnit": measuringUnit,
        "from": from,
        "to": to,
        "quantity": quantity,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
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
