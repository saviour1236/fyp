import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tikstore/constants.dart';
import 'package:tikstore/views/screens/viewdetails_screen.dart';

class MyOrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Order History',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
        ),
        body: 
        
        StreamBuilder(
          stream: firestore
              .collection('orders')
              .where('buyerID',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data?.docs[index].data();
                    return ListTile(
                      title: Row(
                        children: [
                          // Thumbnail
                          Image.network(
                            data?["order"]["thumbnail"],
                            width: 100,
                            height: 100, // Set height to a non-zero value
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Order no. ${index + 1}'),
                                SizedBox(height: 5),
                                Text(
                                  data?["order"]["productName"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '\$ ${data?["order"]["price"]}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'x ${data?["order"]["qty"]}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                // Reorder Button
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (_) => OrderDetailScreen(
                                                    orderDetails: data ?? {},
                                                  )));
                                    },
                                    child: Text('View Details'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Add onTap callback to handle order details navigation
                      onTap: () {
                        // Navigate to order details screen
                        // You can implement this based on your navigation setup
                      },
                    );
                  });
            }

            return Text("lot");
          },
        )

        // SingleChildScrollView(
        //   padding: EdgeInsets.all(20),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       SizedBox(height: 20),

        //       // Order Number with Thumbnail, Product Name, Product Price, and Product Quantity

        //       Divider(), // Add a divider between orders

        //       // Order Number with Thumbnail, Product Name, Product Price, and Product Quantity for Order no.2
        //       ListTile(
        //         title: Row(
        //           children: [
        //             // Thumbnail for Order no.2
        //             Image.network(
        //               'https://t3.ftcdn.net/jpg/01/84/14/54/360_F_184145408_AJ8fpPSNhlAWWDeccmpru57nPIqbxWxx.jpg',
        //               width: 100,
        //               height: 100, // Set height to a non-zero value
        //               fit: BoxFit.cover,
        //             ),
        //             SizedBox(width: 10),
        //             // Product Details for Order no.2
        //             Expanded(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text('Order no. 2'),
        //                   SizedBox(height: 5),
        //                   Text(
        //                     'Product Name',
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   SizedBox(height: 5),
        //                   Text(
        //                     '\$ 100',
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   SizedBox(height: 5),
        //                   Text(
        //                     'x1',
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   SizedBox(height: 10),
        //                   // Reorder Button for Order no.2
        //                   Align(
        //                     alignment: Alignment.centerRight,
        //                     child: ElevatedButton(
        //                       onPressed: () {
        //                         // Action to reorder Order no.2
        //                       },
        //                       child: Text('Reorder'),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //         // Add onTap callback to handle order details navigation for Order no.2
        //         onTap: () {
        //           // Navigate to order details screen for Order no.2
        //           // You can implement this based on your navigation setup
        //         },
        //       ),
        //       Divider(), // Add a divider between orders

        //       // Order Number with Thumbnail, Product Name, Product Price, and Product Quantity for Order no.3
        //       ListTile(
        //         title: Row(
        //           children: [
        //             // Thumbnail for Order no.3
        //             Image.network(
        //               'https://t3.ftcdn.net/jpg/01/84/14/54/360_F_184145408_AJ8fpPSNhlAWWDeccmpru57nPIqbxWxx.jpg',
        //               width: 100,
        //               height: 100, // Set height to a non-zero value
        //               fit: BoxFit.cover,
        //             ),
        //             SizedBox(width: 10),
        //             // Product Details for Order no.3
        //             Expanded(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text('Order no. 3'),
        //                   SizedBox(height: 5),
        //                   Text(
        //                     'Product Name',
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   SizedBox(height: 5),
        //                   Text(
        //                     '\$ 100',
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   SizedBox(height: 5),
        //                   Text(
        //                     'x1',
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   SizedBox(height: 10),
        //                   // Reorder Button for Order no.3
        //                   Align(
        //                     alignment: Alignment.centerRight,
        //                     child: ElevatedButton(
        //                       onPressed: () {
        //                         // Action to reorder Order no.3
        //                       },
        //                       child: Text('Reorder'),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //         // Add onTap callback to handle order details navigation for Order no.3
        //         onTap: () {
        //           // Navigate to order details screen for Order no.3
        //           // You can implement this based on your navigation setup
        //         },
        //       ),
        //       Divider(), // Add a divider between orders
        //       // Continue Shopping Button
        //       SizedBox(height: 20),
        //       Center(
        //         child: ElevatedButton(
        //           onPressed: () {
        //             // Action to continue shopping
        //           },
        //           child: Text('Continue Shopping'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        );
  }
}
