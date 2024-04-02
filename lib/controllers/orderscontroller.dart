import 'package:get/get.dart';
import 'package:tikstore/constants.dart';
import 'package:tikstore/models/orderrequestsmodel.dart';
import 'package:uuid/uuid.dart';

class OrderController extends GetxController {
  final RxBool _isLoading = RxBool(false);
  RxBool get isLoading => _isLoading;
  static OrderController instance = Get.find();
  Future<String> createOrder(OrderRequestModel order) async {
    String results = "OK";
    final uid = Uuid().v4();

    final Map<String, dynamic> data = {"uid": uid, "order": order.toJson()};

    await firestore.collection('orders').doc(uid).set(data);
    return results;
  }
}
