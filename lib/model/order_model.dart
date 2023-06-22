// To parse this JSON data, do
//
//     final driverOrdersModel = driverOrdersModelFromJson(jsonString);

import 'dart:convert';

List<DriverOrdersModel> driverOrdersModelFromJson(String str) => List<DriverOrdersModel>.from(json.decode(str).map((x) => DriverOrdersModel.fromJson(x)));

String driverOrdersModelToJson(List<DriverOrdersModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DriverOrdersModel {
  int? id;
  String? orderId;
  String? driverId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<OrdersItem>? ordersItems;
  Order? order;

  DriverOrdersModel({
    this.id,
    this.orderId,
    this.driverId,
    this.createdAt,
    this.updatedAt,
    this.ordersItems,
    this.order,
  });

  factory DriverOrdersModel.fromJson(Map<String, dynamic> json) => DriverOrdersModel(
    id: json["id"],
    orderId: json["order_id"],
    driverId: json["driver_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    ordersItems: json["orders_items"] == null ? [] : List<OrdersItem>.from(json["orders_items"]!.map((x) => OrdersItem.fromJson(x))),
    order: json["order"] == null ? null : Order.fromJson(json["order"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "driver_id": driverId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "orders_items": ordersItems == null ? [] : List<dynamic>.from(ordersItems!.map((x) => x.toJson())),
    "order": order?.toJson(),
  };
}

class Order {
  int? id;
  String? userId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? orderNo;
  String? transactionId;
  String? restaurantId;
  dynamic address;
  User? user;

  Order({
    this.id,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.orderNo,
    this.transactionId,
    this.restaurantId,
    this.address,
    this.user,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    userId: json["user_id"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    orderNo: json["order_no"],
    transactionId: json["transaction_id"],
    restaurantId: json["restaurant_id"],
    address: json["address"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "order_no": orderNo,
    "transaction_id": transactionId,
    "restaurant_id": restaurantId,
    "address": address,
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  String? name;
  String? email;
  String? phoneNo;
  String? password;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? image;
  UserAddress? userAddress;

  User({
    this.id,
    this.name,
    this.email,
    this.phoneNo,
    this.password,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.userAddress,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phoneNo: json["phone_no"],
    password: json["password"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    image: json["image"],
    userAddress: json["user_address"] == null ? null : UserAddress.fromJson(json["user_address"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone_no": phoneNo,
    "password": password,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "image": image,
    "user_address": userAddress?.toJson(),
  };
}

class UserAddress {
  int? id;
  String? userId;
  String? longitude;
  String? latitude;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserAddress({
    this.id,
    this.userId,
    this.longitude,
    this.latitude,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
    id: json["id"],
    userId: json["user_id"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "longitude": longitude,
    "latitude": latitude,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class OrdersItem {
  int? id;
  String? orderId;
  String? productId;
  String? quantity;
  String? payment;
  DateTime? createdAt;
  DateTime? updatedAt;
  Product? product;

  OrdersItem({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.payment,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory OrdersItem.fromJson(Map<String, dynamic> json) => OrdersItem(
    id: json["id"],
    orderId: json["order_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    payment: json["payment"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "product_id": productId,
    "quantity": quantity,
    "payment": payment,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "product": product?.toJson(),
  };
}

class Product {
  int? id;
  String? categoryId;
  String? subCategoryId;
  String? restaurantId;
  String? name;
  String? image;
  String? description;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? price;

  Product({
    this.id,
    this.categoryId,
    this.subCategoryId,
    this.restaurantId,
    this.name,
    this.image,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    restaurantId: json["restaurant_id"],
    name: json["name"],
    image: json["image"],
    description: json["description"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "restaurant_id": restaurantId,
    "name": name,
    "image": image,
    "description": description,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "price": price,
  };
}
