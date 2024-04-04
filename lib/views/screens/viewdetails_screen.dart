import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  const OrderDetailScreen({Key? key, required this.orderDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              orderDetails['order']['thumbnail'],
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Order ID: ${orderDetails['uid']}',
              style: TextStyle(),
            ),
            SizedBox(height: 10),
            Text(
              'Price per unit: \$${orderDetails['order']['price']}',
              style: TextStyle(),
            ),
            SizedBox(height: 10),
            Text(
              'Quantity: x${orderDetails['order']['qty']}',
              style: TextStyle(),
            ),
            SizedBox(height: 10),
            Text(
              'Total Price: \$${(double.parse(orderDetails['order']['price'].toString()) * int.parse(orderDetails['order']['qty'].toString())).toString()}',
              style: TextStyle(),
            ),
            SizedBox(height: 10),
            Text(
              'Delivery Details: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...List.generate(
                orderDetails['order']['deliveryAddress']
                    .toString()
                    .split(',')
                    .length,
                (index) => Text(orderDetails['order']['deliveryAddress']
                    .toString()
                    .split(',')[index]))
          ],
        ),
      ),
    );
  }
}
