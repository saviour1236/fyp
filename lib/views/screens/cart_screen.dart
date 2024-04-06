import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikstore/constants.dart';
import 'package:tikstore/views/screens/profile_screen.dart';
import 'package:tikstore/views/screens/viewdetails_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.shopping_basket),
              text: 'Orders Received',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'My Order History',
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: TabBarView(
          controller: _tabController,
          children: [
            OrderReceived(),
            MyOrderHistoryWidget(),
          ],
        ),
      ),
    );
  }
}

class MyOrderHistoryWidget extends StatelessWidget {
  const MyOrderHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore
          .collection('orders')
          .where('buyerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
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
                      InkWell(
                        onTap: () {
                          Get.to(ProfileScreen(uid: data?["buyerID"]));
                        },
                        child: Image.network(
                          data?["order"]["thumbnail"],
                          width: 100,
                          height: 100, // Set height to a non-zero value
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order no. ${index + 1}'),
                            const SizedBox(height: 5),
                            Text(
                              data?["order"]["productName"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '\$ ${data?["order"]["price"]}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'x ${data?["order"]["qty"]}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Reorder Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(
                                    OrderDetailScreen(
                                      orderDetails: data ?? {},
                                    ),
                                  );
                                },
                                child: const Text('View Details'),
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
    );
  }
}

class OrderReceived extends StatelessWidget {
  const OrderReceived({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where(
              'sellerID',
              isEqualTo: firebaseAuth.currentUser!.uid,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final orders = snapshot.data?.docs;

            if (orders!.isEmpty) {
              return const Center(child: Text('No orders found'));
            }
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  onTap: () {
                    Get.to(ProfileScreen(uid: order["buyerID"]));
                  },
                  leading: CachedNetworkImage(
                    imageUrl: order['order']['thumbnail'],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(order?['order']['productName']),
                  subtitle: Text(order?['order']['deliveryAddress']),
                  trailing: Text(
                      'Total: \$${order?['order']['price'] * order?['order']['qty']}'),
                );
              },
            );
          } else {
            return Center(child: Text('No orders found'));
          }
        });
  }
}
