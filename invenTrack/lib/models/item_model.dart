import 'dart:io';

class ItemModel {
  final int id;
  final String name;
  final int stock;
  final String? imageUrl;
  final File? localImage;

  ItemModel({
    required this.id,
    required this.name,
    required this.stock,
    this.imageUrl,
    this.localImage,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    String? rawImageUrl = json['image'];
    if (rawImageUrl != null) {
      rawImageUrl = rawImageUrl.replaceAll("localhost", "15.15.5.163");
      rawImageUrl = rawImageUrl.replaceAll(":3000", ":5000");
    }
    return ItemModel(
      id: json['id'],
      name: json['name'],
      stock: json['stock'],
      imageUrl: rawImageUrl,
    );
  }
}
