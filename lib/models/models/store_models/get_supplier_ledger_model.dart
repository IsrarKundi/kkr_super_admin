// To parse this JSON data, do
//
//     final getSupplierLedgerModel = getSupplierLedgerModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetSupplierLedgerModel getSupplierLedgerModelFromJson(String str) => GetSupplierLedgerModel.fromJson(json.decode(str));

String getSupplierLedgerModelToJson(GetSupplierLedgerModel data) => json.encode(data.toJson());

class GetSupplierLedgerModel {
    bool success;
    String message;
    Data data;

    GetSupplierLedgerModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GetSupplierLedgerModel.fromJson(Map<String, dynamic> json) => GetSupplierLedgerModel(
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
    List<Ledger> ledger;
    Pagination pagination;

    Data({
        required this.ledger,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        ledger: List<Ledger>.from(json["ledger"].map((x) => Ledger.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "ledger": List<dynamic>.from(ledger.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class Ledger {
    String supplierId;
    String supplierName;
    int totalOutstanding;

    Ledger({
        required this.supplierId,
        required this.supplierName,
        required this.totalOutstanding,
    });

    factory Ledger.fromJson(Map<String, dynamic> json) => Ledger(
        supplierId: json["supplierId"],
        supplierName: json["supplierName"],
        totalOutstanding: json["totalOutstanding"],
    );

    Map<String, dynamic> toJson() => {
        "supplierId": supplierId,
        "supplierName": supplierName,
        "totalOutstanding": totalOutstanding,
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
