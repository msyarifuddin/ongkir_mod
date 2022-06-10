import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../data/models/province_model.dart';
import '../../../data/models/city_model.dart';
import 'package:http/http.dart' as http;

class HomeView extends GetView<HomeController> {
  // String urlApi = "https://api.rajaongkir.com/starter/";
  // String keyApi = "566430af179baa880bfa80cc68d54c30";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongkos Kirim'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: controller.getallProv(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading"),
              );
            } else {
              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  DropdownSearch<Province>(
                      items: controller.dataProv,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text(
                              "${item.province}",
                            ),
                          );
                        },
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Provinsi Asal",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      onChanged: (value) {
                        controller.provAsalID.value = value?.provinceId ?? "0";
                        controller.GetCityAsal(value?.provinceId);
                        // print("datakotaasal=" + controller.dataKotaAsal);
                        // controller.dataKotaAsal.forEach((element) {
                        //   print(element.cityName);
                        // });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () {
                      return AbsorbPointer(
                        absorbing: controller.isLoadKota.value,
                        child: DropdownSearch<dynamic>(
                          items: controller.dataKotaAsal.value,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            itemBuilder: (context, item, isSelected) {
                              return ListTile(
                                title: Text(
                                  "${item.type} ${item.cityName}",
                                ),
                              );
                            },
                          ),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: controller.labelKotaAsal.value,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          onChanged: (value) {
                            controller.cityAsalID.value = value?.cityId ?? "0";
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownSearch<Province>(
                    items: controller.dataProv,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(
                          title: Text(
                            "${item.province}",
                          ),
                        );
                      },
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Provinsi Tujuan",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (value) {
                      controller.provTujuanID.value = value?.provinceId ?? "0";
                      controller.GetCityTujuan(value?.provinceId);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    return AbsorbPointer(
                      absorbing: controller.isLoadKota.value,
                      child: DropdownSearch<dynamic>(
                        items: controller.dataKotaTujuan.value,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          itemBuilder: (context, item, isSelected) {
                            return ListTile(
                              title: Text(
                                "${item.type} ${item.cityName}",
                              ),
                            );
                          },
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: controller.labelKotaTujuan.value,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        onChanged: (value) {
                          controller.cityTujuanID.value = value?.cityId ?? "0";
                        },
                      ),
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: controller.beratC,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Berat (gram)",
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: 15,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownSearch<Map<String, dynamic>>(
                    items: [
                      {
                        "code": "jne",
                        "name": "JNE",
                      },
                      {
                        "code": "pos",
                        "name": "POS Indonesia",
                      },
                      {
                        "code": "tiki",
                        "name": "TIKI",
                      },
                    ],
                    popupProps: PopupProps.menu(
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(
                          title: Text("${item['name']}"),
                        );
                      },
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Kurir",
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (value) {
                      controller.codeKurir.value = value?['code'] ?? "";
                    },
                    dropdownBuilder: (context, selectedItem) {
                      return Text(
                        "${selectedItem?['name'] ?? "Pilih Kurir"}",
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => ElevatedButton(
                      onPressed: () {
                        if (controller.isLoading.isFalse) {
                          controller.cekOngkir();
                        }
                      },
                      child: Text(controller.isLoading.isFalse
                          ? "Cek Ongkir"
                          : "Loading..."),
                    ),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: Text("Get Prov"),
                  // ),
                ],
              );
            }
          }),
    );
  }
}
