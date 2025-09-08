// To parse this JSON data, do
//
//     final getMenuItemsModel = getMenuItemsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetMenuItemsModel getMenuItemsModelFromJson(String str) => GetMenuItemsModel.fromJson(json.decode(str));

String getMenuItemsModelToJson(GetMenuItemsModel data) => json.encode(data.toJson());

class GetMenuItemsModel {
    bool success;
    String message;
    List<Datum> data;

    GetMenuItemsModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GetMenuItemsModel.fromJson(Map<String, dynamic> json) => GetMenuItemsModel(
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

    Ingredient({
        required this.itemId,
        required this.item,
        required this.quantity,
    });

    factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        itemId: json["itemId"],
        item: json["item"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "item": item,
        "quantity": quantity,
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
