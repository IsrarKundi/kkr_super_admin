// To parse this JSON data, do
//
//     final getItemsBySectionModel = getItemsBySectionModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetItemsBySectionModel getItemsBySectionModelFromJson(String str) => GetItemsBySectionModel.fromJson(json.decode(str));

String getItemsBySectionModelToJson(GetItemsBySectionModel data) => json.encode(data.toJson());

class GetItemsBySectionModel {
    bool success;
    String message;
    List<IngredientsDatum> data;

    GetItemsBySectionModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GetItemsBySectionModel.fromJson(Map<String, dynamic> json) => GetItemsBySectionModel(
        success: json["success"],
        message: json["message"],
        data: List<IngredientsDatum>.from(json["data"].map((x) => IngredientsDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class IngredientsDatum {
    String kitchenItemId;
    String itemName;
    int pricePerUnit;
    String category;

    IngredientsDatum({
        required this.kitchenItemId,
        required this.itemName,
        required this.pricePerUnit,
        required this.category,
    });

    factory IngredientsDatum.fromJson(Map<String, dynamic> json) => IngredientsDatum(
        kitchenItemId: json["kitchenItemId"],
        itemName: json["itemName"],
        pricePerUnit: json["pricePerUnit"],
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "kitchenItemId": kitchenItemId,
        "itemName": itemName,
        "pricePerUnit": pricePerUnit,
        "category": category,
    };
}
