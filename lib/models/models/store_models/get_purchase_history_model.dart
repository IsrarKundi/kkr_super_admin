// To parse this JSON data, do
//
//     final getPurchaseHistoryModel = getPurchaseHistoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetPurchaseHistoryModel getPurchaseHistoryModelFromJson(String str) => GetPurchaseHistoryModel.fromJson(json.decode(str));

String getPurchaseHistoryModelToJson(GetPurchaseHistoryModel data) => json.encode(data.toJson());

class GetPurchaseHistoryModel {
    bool success;
    String message;
    Data data;

    GetPurchaseHistoryModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GetPurchaseHistoryModel.fromJson(Map<String, dynamic> json) => GetPurchaseHistoryModel(
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
    List<PurchaseHistory> purchaseHistory;
    Pagination pagination;

    Data({
        required this.purchaseHistory,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        purchaseHistory: List<PurchaseHistory>.from(json["purchaseHistory"].map((x) => PurchaseHistory.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "purchaseHistory": List<dynamic>.from(purchaseHistory.map((x) => x.toJson())),
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

class PurchaseHistory {
    String purchaseId;
    String itemName;
    String measuringUnit;
    int quantity;
    int pricePerUnit;
    int totalAmount;
    String paymentMethod;
    String supplierName;
    DateTime createdAt;
    DateTime updatedAt;

    PurchaseHistory({
        required this.purchaseId,
        required this.itemName,
        required this.measuringUnit,
        required this.quantity,
        required this.pricePerUnit,
        required this.totalAmount,
        required this.paymentMethod,
        required this.supplierName,
        required this.createdAt,
        required this.updatedAt,
    });

    factory PurchaseHistory.fromJson(Map<String, dynamic> json) => PurchaseHistory(
        purchaseId: json["purchaseId"],
        itemName: json["itemName"],
        measuringUnit: json["measuringUnit"],
        quantity: json["quantity"],
        pricePerUnit: json["pricePerUnit"],
        totalAmount: json["totalAmount"],
        paymentMethod: json["paymentMethod"],
        supplierName: json["supplierName"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "purchaseId": purchaseId,
        "itemName": itemName,
        "measuringUnit": measuringUnit,
        "quantity": quantity,
        "pricePerUnit": pricePerUnit,
        "totalAmount": totalAmount,
        "paymentMethod": paymentMethod,
        "supplierName": supplierName,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
