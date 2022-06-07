import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString provAsalID = "0".obs;
  RxString cityAsalID = "0".obs;
  RxString provTujuanID = "0".obs;
  RxString cityTujuanID = "0".obs;

  RxString codeKurir = "".obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
