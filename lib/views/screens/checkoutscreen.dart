import 'package:flutter/material.dart';
import 'package:tikstore/views/screens/delivery_detailsscreen.dart';

class CheckoutScreen extends StatefulWidget {
  final String thumbnailUrl;
  final String sellerUsername;
  final String sellerNumber;
  final String? productName; // Added product name
  final String productDescription; // Added product description
  final double price;

  CheckoutScreen({
    required this.thumbnailUrl,
    required this.sellerUsername,
    required this.sellerNumber,
    required this.productName, // Added product name
    required this.productDescription, // Added product description
    required this.price,
  });
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _stockCount = 1;
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Image.network(
              widget.thumbnailUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),

            SizedBox(height: 10),

            // Sold By and Seller Number texts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Sold By: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.sellerUsername,
                    style: TextStyle(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Centered column for Product Name and Description
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.productName == null
                      ? SizedBox()
                      : Text(
                          widget.productName!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.productDescription,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Stock meter
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_stockCount > 1) _stockCount--;
                    });
                  },
                  icon: Icon(Icons.remove),
                ),
                Text(
                  'Quantity: $_stockCount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _stockCount++;
                    });
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),

            // Message to seller input field
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 300, // Adjust width here
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: 'Enter message to seller',
                    labelText: 'Message to Seller',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      fontSize: 16,
                    ),
                    alignLabelWithHint: false, // Center the label text
                  ),
                  maxLines: null,
                ),
              ),
            ),

            // Proceed to payment button
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DeliveryDetailsScreen(
                            thumbnailUrl: widget.thumbnailUrl,
                            productName: widget.productName,
                            productDescription: widget.productDescription,
                            sellerUsername: widget.sellerUsername,
                            price: widget.price,
                            qty: _stockCount,
                            sellerNumber: widget.sellerNumber,
                            message: messageController.text.trim(),
                          )));
                },
                child: Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
