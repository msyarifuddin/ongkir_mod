import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/ongkir_model.dart';

class HomeController extends GetxController {
  TextEditingController beratC = TextEditingController();

  List<Ongkir> ongkosKirim = [];
  RxBool isLoading = false.obs;

  RxString provAsalID = "0".obs;
  RxString cityAsalID = "0".obs;
  RxString provTujuanID = "0".obs;
  RxString cityTujuanID = "0".obs;

  RxString codeKurir = "".obs;
  // RxString berat = "0".obs;

  void cekOngkir() async {
    print("provasal= " + provAsalID.value);
    print("cityasal= " + cityAsalID.value);
    print("provtujuan= " + provTujuanID.value);
    print("citytujuan= " + cityTujuanID.value);
    print("berat= " + beratC.text);
    print("kurir= " + codeKurir.value);
    if (provAsalID.value != "0" &&
        provTujuanID.value != "0" &&
        cityAsalID.value != "0" &&
        cityTujuanID.value != "0" &&
        codeKurir.value != "" &&
        beratC.text != "") {
      //eksekusi
      try {
        isLoading.value = true;
        var response = await http.post(
          Uri.parse("https://api.rajaongkir.com/starter/cost"),
          headers: {
            "key": "566430af179baa880bfa80cc68d54c30",
            "content-type": "application/x-www-form-urlencoded",
          },
          body: {
            "origin": cityAsalID.value,
            "destination": cityTujuanID.value,
            "weight": beratC.text,
            "courier": codeKurir.value,
          },
        );

        print("resp=" + response.body);
        print("----------------------");
        isLoading.value = false;
        List ongkir1 = json.decode(response.body)["rajaongkir"]["results"][0]
                ["cost"] ??
            [] as List;
        print(ongkir1);
        ongkosKirim = Ongkir.fromJsonList(ongkir1);
        Get.defaultDialog(
          title: "ONGKOS KIRIM",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ongkosKirim
                .map((e) => ListTile(
                      title: Text("${e.service!.toUpperCase()}"),
                      subtitle: Text("Rp ${e.cost![0].value}"),
                    ))
                .toList(),
          ),
        );
        // print(ongkosKirim);
        // ongkosKirim.forEach((element) {
        //   print(element.toJson());
        // });
      } catch (e) {
        print(e);
        Get.defaultDialog(
          title: "ERROR",
          middleText: "Tidak dapat mengecek ongkir",
        );
      }
    } else {
      Get.defaultDialog(
        title: "ERROR",
        middleText: "Data Input belum lengkap",
      );
    }
  }

  // final count = 0.obs;
  // @override
  // void onInit() {
  //   super.onInit();
  //   getProvInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {}
  // void increment() => count.value++;
  // dynamic resp1 = "";
  // List allProv = [];

  // void getProvInit() async {
  //   try {
  //     // resp1 = await Dio().get(
  //     //   "https://api.rajaongkir.com/starter/province",
  //     //   queryParameters: {
  //     //     "key": "566430af179baa880bfa80cc68d54c30",
  //     //   },
  //     // );
  //     resp1 = http.get(
  //       Uri.parse("https://api.rajaongkir.com/starter/province"),
  //       headers: {
  //         "key": "566430af179baa880bfa80cc68d54c30",
  //       },
  //     );
  //     print(resp1.body["rajaongkir"]["result"]);
  //     // List data = (json.decode(resp1.body) as Map<String, dynamic>)["data"];
  //     // ["rajaongkir"]["results"]
  //   } catch (e) {
  //     print("Terjadi Kesalahan");
  //     print(e);
  //   }
  // }
}
