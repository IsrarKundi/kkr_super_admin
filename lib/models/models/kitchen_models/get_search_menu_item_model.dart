// To parse this JSON data, do
//
//     final getSearchMenuItemModel = getSearchMenuItemModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetSearchMenuItemModel getSearchMenuItemModelFromJson(String str) => GetSearchMenuItemModel.fromJson(json.decode(str));

String getSearchMenuItemModelToJson(GetSearchMenuItemModel data) => json.encode(data.toJson());

class GetSearchMenuItemModel {
    bool success;
    String message;
    List<Datum> data;

    GetSearchMenuItemModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GetSearchMenuItemModel.fromJson(Map<String, dynamic> json) => GetSearchMenuItemModel(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    String name;
    String section;
    int sellingPrice;
    String description;
    List<Ingredient> ingredients;
    int totalCost;
    ProfitMargin profitMargin;

    Datum({
        required this.id,
        required this.name,
        required this.section,
        required this.sellingPrice,
        required this.description,
        required this.ingredients,
        required this.totalCost,
        required this.profitMargin,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        section: json["section"],
        sellingPrice: json["sellingPrice"],
        description: json["description"],
        ingredients: List<Ingredient>.from(json["ingredients"].map((x) => Ingredient.fromJson(x))),
        totalCost: json["totalCost"],
        profitMargin: ProfitMargin.fromJson(json["profitMargin"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "section": section,
        "sellingPrice": sellingPrice,
        "description": description,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x.toJson())),
        "totalCost": totalCost,
        "profitMargin": profitMargin.toJson(),
    };
}

class Ingredient {
    String itemId;
    String item;
    int quantity;
    int pricePerUnit;
    int totalCost;

    Ingredient({
        required this.itemId,
        required this.item,
        required this.quantity,
        required this.pricePerUnit,
        required this.totalCost,
    });

    factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        itemId: json["itemId"],
        item: json["item"],
        quantity: json["quantity"],
        pricePerUnit: json["pricePerUnit"],
        totalCost: json["totalCost"],
    );

    Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "item": item,
        "quantity": quantity,
        "pricePerUnit": pricePerUnit,
        "totalCost": totalCost,
    };
}

class ProfitMargin {
    int profitMarginValue;
    double profitMarginPercent;

    ProfitMargin({
        required this.profitMarginValue,
        required this.profitMarginPercent,
    });

    factory ProfitMargin.fromJson(Map<String, dynamic> json) => ProfitMargin(
        profitMarginValue: json["profitMarginValue"],
        profitMarginPercent: json["profitMarginPercent"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "profitMarginValue": profitMarginValue,
        "profitMarginPercent": profitMarginPercent,
    };
}
