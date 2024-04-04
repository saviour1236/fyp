class OrderRequestModel {
  final String productName;
  final String thumbnail;
  final double price;
  final String? productDescription;
  final String? sellerName;
  final String? deliveryAddress;
  final int qty;

  OrderRequestModel(
      {this.productDescription,
      required this.productName,
      required this.thumbnail,
      required this.price,
      required this.qty,
      this.sellerName,
      this.deliveryAddress});
  // toJson
  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'thumbnail': thumbnail,
      'price': price,
      'qty': qty,
      'productDescription': productDescription,
      'sellerName': sellerName,
      'deliveryAddress': deliveryAddress,
    };
  }

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) {
    return OrderRequestModel(
      productName: json['productName'],
      thumbnail: json['thumbnail'],
      price: json['price'],
      qty: json['qty'],
      productDescription: json['productDescription'],
      sellerName: json['sellerName'],
      deliveryAddress: json['deliveryAddress'],
    );
  }
}
