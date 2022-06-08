import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
// import 'package:dio/dio.dart';

import '../../../data/models/province_model.dart';
import '../../../data/models/city_model.dart';
import 'package:http/http.dart' as http;

class HomeView extends GetView<HomeController> {
  // final HomeController homeC = get.lazyput(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongkos Kirim'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          DropdownSearch<Province>(
              asyncItems: (text) async {
                var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/province",
                  queryParameters: {
                    "key": "566430af179baa880bfa80cc68d54c30",
                  },
                );
                return Province.fromJsonList(
                  response.data["rajaongkir"]["results"],
                );
              },
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  border: OutlineInputBorder(),
                ),
              ),
              onChanged: (value) {
                controller.provAsalID.value = value?.provinceId ?? "0";
              }),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<City>(
            asyncItems: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/city?province=${controller.provAsalID.value}",
                queryParameters: {
                  "key": "566430af179baa880bfa80cc68d54c30",
                },
              );
              return City.fromJsonList(
                response.data["rajaongkir"]["results"],
              );
            },
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
                labelText: "Kota/Kab Asal",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: OutlineInputBorder(),
              ),
            ),
            onChanged: (value) {
              controller.cityAsalID.value = value?.cityId ?? "0";
            },
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<Province>(
            asyncItems: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/province",
                queryParameters: {
                  "key": "566430af179baa880bfa80cc68d54c30",
                },
              );
              return Province.fromJsonList(
                response.data["rajaongkir"]["results"],
              );
            },
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
            },
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<City>(
            asyncItems: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/city?province=${controller.provTujuanID.value}",
                queryParameters: {
                  "key": "566430af179baa880bfa80cc68d54c30",
                },
              );
              return City.fromJsonList(
                response.data["rajaongkir"]["results"],
              );
            },
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
                labelText: "Kota/Kab Tujuan",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: OutlineInputBorder(),
              ),
            ),
            onChanged: (value) {
              controller.cityTujuanID.value = value?.cityId ?? "0";
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.beratC,
            autocorrect: false,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(),
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
          ElevatedButton(
            onPressed: () {
              controller.cekOngkir();
            },
            child: Text(
              "Cek Ongkir",
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
      ),
    );
  }
}
