import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/base/show_custom_message.dart';
import 'package:rumah_kreatif_toba/controllers/toko_controller.dart';
import 'package:rumah_kreatif_toba/controllers/user_controller.dart';
import 'package:rumah_kreatif_toba/models/city.dart';
import 'package:rumah_kreatif_toba/models/province.dart';
import 'package:rumah_kreatif_toba/models/subdistrict.dart';
import 'package:rumah_kreatif_toba/pages/alamat/daftaralamat.dart';
import 'package:rumah_kreatif_toba/pages/home/home_page.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/controllers/alamat_controller.dart';

import '../../../utils/colors.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/big_text.dart';

class TambahAlamatToko extends GetView<AlamatController> {
  var ProvinsiController = TextEditingController();
  var KabupatenController = TextEditingController();
  var KecamatanController = TextEditingController();
  var JalanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> _tambahAlamat(provAsalId, cityAsalId, subdistrictId) async {
      String jalan = JalanController.text.trim();

      if (controller.provAsalId.value.isEmpty) {
        showCustomSnackBar("Provinsi masih kosong", title: "Provinsi");
      } else if (controller.cityAsalId.value.isEmpty) {
        showCustomSnackBar("kabupaten / Kota masih kosong", title: "Kabupaten / Kota");
      } else if (controller.subAsalId.value.isEmpty) {
        showCustomSnackBar("Kecamatan masih kosong", title: "kecamatan");
      } else if (JalanController == null) {
        showCustomSnackBar("Jalan masih kosong", title: "Jalan");
      } else {
        var merchantController = Get.find<TokoController>().profilTokoList[0];
        var controller = Get.find<AlamatController>();
        controller.tambahAlamatToko(merchantController.merchant_id,
            controller.province.value , controller.city.value, controller.sub.value, jalan, provAsalId, cityAsalId, subdistrictId )
            .then((status) async {});
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: AppIcon(
                      icon: Icons.arrow_back,
                      iconColor: AppColors.redColor,
                      backgroundColor: Colors.white,
                      iconSize: Dimensions.iconSize24,
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.width20,
                  ),
                  BigText(
                    text: "Alamat",
                    size: Dimensions.font20,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  DropdownSearch<Province>(
                    showSearchBox: true,
                    popupItemBuilder: (context, item, isSelected) => ListTile(
                      title: Text("${item.province}"),
                    ),
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Provinsi",
                      hintText: "Pilih Provinsi",
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.redColor),
                      ),
                    ),
                    onFind: (text) async {
                      var response = await Dio().get(
                        "https://pro.rajaongkir.com/api/province",
                        queryParameters: {
                          "key": "41df939eff72c9b050a81d89b4be72ba",
                        },
                      );


                      return Province.fromJsonList(
                          response.data["rajaongkir"]["results"]);
                    },

                    onChanged: (value) {
                      controller.provAsalId.value = value?.provinceId ?? "0";
                      controller.province.value  = value?.province ?? "0";
                      ;
                    },

                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownSearch<City>(
                      showSearchBox: true,
                      popupItemBuilder: (context, item, isSelected) => ListTile(
                        title: Text("${item.type} ${item.cityName}"),
                      ),
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Kabupaten / Kota",
                        hintText: "Pilih Kabupaten / Kota",
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        focusColor: AppColors.redColor,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.redColor),
                        ),
                      ),
                      onFind: (text) async {
                        var response = await Dio().get(
                          "https://pro.rajaongkir.com/api/city?province=${controller.provAsalId}",
                          queryParameters: {
                            "key": "41df939eff72c9b050a81d89b4be72ba",
                          },
                        );
                        return City.fromJsonList(
                            response.data["rajaongkir"]["results"]);
                      },
                      onChanged: (value) {
                        controller.cityAsalId.value = value?.cityId ?? "0";
                        controller.city.value = value?.cityName ?? "0";

                      }),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownSearch<Subdistrict>(
                      showSearchBox: true,
                      popupItemBuilder: (context, item, isSelected) => ListTile(
                        title: Text("${item.subdistrictName}"),
                      ),
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Kecamatan",
                        hintText: "Pilih Kecamatan",
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.redColor),
                        ),
                      ),
                      onFind: (text) async {
                        var response = await Dio().get(
                          "https://pro.rajaongkir.com/api/subdistrict?city=${controller.cityAsalId}",
                          queryParameters: {
                            "key": "41df939eff72c9b050a81d89b4be72ba",
                          },
                        );
                        return Subdistrict.fromJsonList(
                            response.data["rajaongkir"]["results"]);
                      },
                      onChanged: (value) {
                        controller.subAsalId.value = value?.subdistrictId ?? "0";
                        controller.sub.value = value?.subdistrictName ?? "0";
                      }

                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: JalanController,
                    decoration: InputDecoration(
                      labelText: "Jalan",
                      hintText: "Masukkan Jalan Alamat",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.redColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 35,
            ),
            GestureDetector(
              onTap: () => {
                _tambahAlamat(controller.provAsalId.value, controller.cityAsalId.value, controller.subAsalId.value),

              },
              child: Container(
                alignment: Alignment.bottomCenter,
                width: 306,
                height: 45,
                // alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.redColor,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: BigText(
                    text: "Tambah",
                    fontWeight: FontWeight.bold,
                    size: Dimensions.font20,
                    color: AppColors.redColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
