import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikstore/controllers/orderscontroller.dart';
import 'package:tikstore/models/orderrequestsmodel.dart';
import 'package:tikstore/views/screens/order_history.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final String thumbnailUrl;
  final String sellerUsername;
  final String sellerNumber;
  final String? productName;
  final String productDescription;
  final double price;
  final int qty;
  final String message;
  final String sellerId;
  const DeliveryDetailsScreen({
    super.key,
    required this.thumbnailUrl,
    required this.sellerUsername,
    required this.sellerNumber,
    this.productName,
    required this.price,
    required this.qty,
    this.message = '',
    required this.productDescription,
    required this.sellerId,
  });
  @override
  _DeliveryDetailsScreenState createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  String _selectedProvince = 'Select Province'; // Set default province
  String _selectedCity = 'Select City'; // Set default city
  String _enteredTole = ''; // To store the entered tole
  String _customerName = ''; // To store the customer's name
  String _phoneNumber = ''; // To store the customer's phone number
  OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivery Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image
              Image.network(
                'https://t3.ftcdn.net/jpg/01/84/14/54/360_F_184145408_AJ8fpPSNhlAWWDeccmpru57nPIqbxWxx.jpg',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 10),
              // Dropdown for selecting province
              Container(
                width: 250,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: SizedBox(),
                  hint: Text('Select province'),
                  value: _selectedProvince,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedProvince = newValue!;
                    });
                  },
                  items: <String>[
                    'Select Province',
                    'Jhapa Province',
                    'Morang Province',
                    'Bagmati Province'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 10),
              // Dropdown for selecting city
              Container(
                width: 250,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: SizedBox(),
                  hint: Text('Select city'),
                  value: _selectedCity,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCity = newValue!;
                    });
                  },
                  items: <String>[
                    'Select City',
                    'Lalitpur',
                    'Kathmandu',
                    'Bhaktapur'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 10),
              // Input field for entering tole
              SizedBox(
                width: 250,
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Tole',
                    labelText: 'Tole',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _enteredTole = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              // Input field for entering customer's name
              SizedBox(
                width: 250,
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Name',
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _customerName = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              // Input field for entering customer's phone number
              SizedBox(
                width: 250,
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Phone Number',
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _phoneNumber = value;
                    });
                  },
                  keyboardType: TextInputType.phone,
                ),
              ),
              SizedBox(height: 20),
              // Confirm Purchase button
              ElevatedButton(
                onPressed: () async {
                  OrderRequestModel order = OrderRequestModel(
                      productName: widget.productName ?? "",
                      thumbnail: widget.thumbnailUrl,
                      price: widget.price,
                      qty: widget.qty,
                      productDescription: widget.productDescription,
                      sellerName: widget.sellerUsername,
                      deliveryAddress:
                          '$_selectedCity, $_selectedProvince, $_enteredTole, $_customerName, $_phoneNumber');

                  final result = await orderController.createOrder(
                    order,
                    widget.message,
                    sellerId: widget.sellerId,
                  );
                  if (result == 'OK') {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => MyOrderHistoryScreen()));
                  }
                },
                child: Text('Confirm Purchase'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
