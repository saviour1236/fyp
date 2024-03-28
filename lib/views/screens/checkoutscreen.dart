import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final String thumbnailUrl;
  final String sellerUsername;
  final String sellerNumber;
  final String productName; // Added product name
  final String productDescription; // Added product description

  CheckoutScreen({
    required this.thumbnailUrl,
    required this.sellerUsername,
    required this.sellerNumber,
    required this.productName, // Added product name
    required this.productDescription, // Added product description
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _stockCount = 1;

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
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.sellerUsername,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Spacer(), // Add space between texts
                  Text(
                    'Seller Number: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.sellerNumber,
                    style: TextStyle(
                      color: Colors.black,
                    ),
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
                  Text(
                    widget.productName,
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
                  'Stock: $_stockCount',
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
                  decoration: InputDecoration(
                    hintText: 'Enter message to seller',
                    labelText: 'Message to Seller',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    alignLabelWithHint: false, // Center the label text
                  ),
                  maxLines: 3,
                ),
              ),
            ),

            // Proceed to payment button
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Action to proceed to payment
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

void main() {
  runApp(MaterialApp(
    home: CheckoutScreen(
      thumbnailUrl:
          'https://t3.ftcdn.net/jpg/01/84/14/54/360_F_184145408_AJ8fpPSNhlAWWDeccmpru57nPIqbxWxx.jpg',
      sellerUsername: 'Username',
      sellerNumber: '+1234567890',
      productName: 'Product Name', // Added product name
      productDescription:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ullamcorper felis eget eros fermentum, a laoreet sapien facilisis. Sed tristique libero sed tortor eleifend, in semper enim feugiat. Phasellus pretium mauris in est feugiat, sit amet viverra purus lacinia.', // Added product description
    ),
  ));
}
