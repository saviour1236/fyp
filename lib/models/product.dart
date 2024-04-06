class OrderRequestModel {
  final String? orderId;
  final String productName;
  final String thumbnail;
  final String price;
  final String? productDescription;
  final String? sellerName;
  final String? deliveryAddress;
  final int qty;

  OrderRequestModel({
    this.orderId,
    required this.productName,
    required this.thumbnail,
    required this.price,
    required this.qty,
    this.sellerName,
    this.deliveryAddress,
    this.productDescription,
  }); 

  // toJson 
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'productName': productName,
      'thumbnail': thumbnail,
      'price': price,
      'qty': qty,
      'productDescription': productDescription,
      'sellerName': sellerName,
      'deliveryAddress': deliveryAddress,
    };
  } 

  /// fromJson
  
  factory OrderRequestModel.fromJson(Map<String, dynamic> json) {
    return OrderRequestModel(
      orderId: json['orderId'],
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
