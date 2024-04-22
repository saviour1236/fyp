import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tikstore/constants.dart';
import 'package:tikstore/views/screens/viewdetails_screen.dart';

class MyOrderHistory extends StatelessWidget {
  const MyOrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: StreamBuilder(
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
                        Image.network(
                          data?["order"]["thumbnail"],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
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
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (_) => OrderDetailScreen(
                                                  orderDetails: data ?? {},
                                                )));
                                  },
                                  child: const Text('View Details'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {},
                  );
                });
          }

          return const Text("lot");
        },
      ),
    );
  }
}
