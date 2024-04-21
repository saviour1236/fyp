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
        title: Text('My Cart'),
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
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('buyerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final docId = snapshot.data!.docs[index].id;
                return ListTile(
                  title: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(OrderDetailScreen(orderDetails: data));
                        },
                        child: Image.network(
                          data["order"]["thumbnail"],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order no. ${index + 1}'),
                            SizedBox(height: 5),
                            Text(
                              data["order"]["productName"],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '\$ ${data["order"]["price"]}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'x ${data["order"]["qty"]}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirm Deletion"),
                            content: Text(
                                "Are you sure you want to delete this order?"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("Delete"),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('orders')
                                      .doc(docId)
                                      .delete()
                                      .then((_) => Navigator.of(context).pop());
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  onTap: () {
                    Get.to(OrderDetailScreen(orderDetails: data));
                  },
                );
              });
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        return const Text("Loading...");
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
