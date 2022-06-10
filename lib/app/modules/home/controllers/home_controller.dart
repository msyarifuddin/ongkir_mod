import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/city_model.dart';
import '../../../data/models/ongkir_model.dart';
import '../../../data/models/province_model.dart';

class HomeController extends GetxController {
  TextEditingController beratC = TextEditingController();

  List<Ongkir> ongkosKirim = [];
  RxBool isLoading = false.obs;
  RxBool isLoadKota = false.obs;
  RxString labelKotaAsal = "Kota/Kab Asal".obs;
  RxString labelKotaTujuan = "Kota/Kab Tujuan".obs;

  RxString provAsalID = "0".obs;
  RxString cityAsalID = "0".obs;
  RxString provTujuanID = "0".obs;
  RxString cityTujuanID = "0".obs;

  RxString codeKurir = "".obs;
  // RxString berat = "0".obs;

  void cekOngkir() async {
    // print("provasal= " + provAsalID.value);
    // print("cityasal= " + cityAsalID.value);
    // print("provtujuan= " + provTujuanID.value);
    // print("citytujuan= " + cityTujuanID.value);
    // print("berat= " + beratC.text);
    // print("kurir= " + codeKurir.value);
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
                ["costs"] ??
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

  String urlApi = "https://api.rajaongkir.com/starter/";
  String keyApi = "566430af179baa880bfa80cc68d54c30";

  List<Province> dataProv = [];

  Future getallProv() async {
    try {
      var response = await http.get(Uri.parse(urlApi + "province"), headers: {
        "key": keyApi,
      });
      dataProv = Province.fromJsonList(
          json.decode(response.body)["rajaongkir"]["results"]);
    } catch (e) {
      //print jika terjadi error
      print("Terjadi kesalahan");
      print(e);
    }
  }

  // List<City> dataKotaAsal = [];
  RxList dataKotaAsal = [].obs;
  // RxString respKotaAsal = "".obs;
  void GetCityAsal(String? idKota) async {
    try {
      isLoadKota.value = true;
      labelKotaAsal.value = "Loading.....";
      var response = await http
          .get(Uri.parse(urlApi + "city?province=${idKota}"), headers: {
        "key": keyApi,
      });
      print("kota asal=" + response.body);
      // respKotaAsal.value = response.body.toString();
      dataKotaAsal.value = City.fromJsonList(
          json.decode(response.body)["rajaongkir"]["results"]);
      isLoadKota.value = false;
      labelKotaAsal.value = "Kota/Kab Asal";
    } catch (e) {
      //print jika terjadi error
      print("Terjadi kesalahan");
      print(e);
    }
  }

  RxList dataKotaTujuan = [].obs;
  void GetCityTujuan(String? idKota) async {
    try {
      isLoadKota.value = true;
      labelKotaTujuan.value = "Loading.....";
      var response = await http
          .get(Uri.parse(urlApi + "city?province=${idKota}"), headers: {
        "key": keyApi,
      });
      print("kota tujuan=" + response.body);
      dataKotaTujuan.value = City.fromJsonList(
          json.decode(response.body)["rajaongkir"]["results"]);
      isLoadKota.value = false;
      labelKotaTujuan.value = "Kota/Kab Tujuan";
    } catch (e) {
      //print jika terjadi error
      print("Terjadi kesalahan");
      print(e);
    }
  }
}
