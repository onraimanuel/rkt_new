import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/controllers/toko_controller.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';
import 'package:rumah_kreatif_toba/widgets/tittle_text.dart';

import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import 'hometoko_page.dart';

class HomeToko extends StatelessWidget {
  const HomeToko({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<TokoController>().profilToko();
    Get.find<TokoController>().homeToko();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Container(
                margin: EdgeInsets.only(
                    top: Dimensions.height30, bottom: Dimensions.height10),
                padding: EdgeInsets.only(
                    left: Dimensions.width20, right: Dimensions.width20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: Dimensions.width15*2,
                      height: Dimensions.height30,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                              AssetImage("assets/images/logo_rkt.png"))),
                    ),
                    Container(
                      width: Dimensions.width15*2,
                      height: Dimensions.height30,
                      margin: EdgeInsets.only(
                          left: Dimensions.width10, right: Dimensions.width10),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/images/Bangga_Buatan_Indonesia_Logo.png"))),
                    ),
                    Get.find<TokoController>().isLoading
                        ? Container(
                            width: Dimensions.screenWidth / 1.8,
                            height: 30,
                            margin: EdgeInsets.only(
                                left: Dimensions.width10,
                                right: Dimensions.width10),
                            child: BigText(
                              text:
                                  "Toko ${Get.find<TokoController>().profilTokoList[0].nama_merchant.toString()}",
                              size: Dimensions.font20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(
                            height:
                                20,
                      width: 20,

                      // set the height of the container to your desired height
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.redColor,
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    )
                  ]),
              margin: EdgeInsets.only(
                  top: Dimensions.height20
              ),

              padding: EdgeInsets.only(
                  top: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: BigText(
                            text: "PENJUALAN",
                            size: Dimensions.font20,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.to(() => HomeTokoPage(initialIndex: 2));
                      //   },
                      //   child:  BigText(
                      //     text: "Lihat Riwayat",
                      //     size: Dimensions.font16,
                      //     fontWeight: FontWeight.bold,
                      //     color: AppColors.notification_success,
                      //   )
                      // )
                    ],
                  ),
                  Divider(color: AppColors.buttonBackgroundColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: TittleText(
                          text: "Pesanan Sedang Berlangsung",
                          size: Dimensions.font20 / 1.5,
                        ),
                      ),
                      Get.find<TokoController>().isLoading
                          ? Container(
                        child: Obx(
                              () => BigText(
                            text: Get.find<TokoController>()
                                .getJumlahPesanan[
                            'jumlah_pesanan_sedang_berlangsung']!
                                .toString(),
                            size: Dimensions.font20 / 1.5,
                          ),
                        ),
                      )
                          : Container(
                        height:
                        20,
                        width: 20,// set the height of the container to your desired height
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.redColor,
                          ),
                        ),
                      )

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: TittleText(
                          text:
                          "Pesanan Berhasil [Belum Konfirmasi Pembayaran]",
                          size: Dimensions.font20 / 1.5,
                        ),
                      ),
                      Get.find<TokoController>().isLoading
                          ? Container(
                        child: Obx(
                              () => BigText(
                            text: Get.find<TokoController>()
                                .getJumlahPesanan[
                            'jumlah_pesanan_berhasil_belum_dibayar']!
                                .toString(),
                            size: Dimensions.font20 / 1.5,
                          ),
                        ),
                      )
                          : Container(
                        height:
                        20,
                        width: 20,
                        // set the height of the container to your desired height
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.redColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: TittleText(
                          text:
                          "Pesanan Berhasil [Telah Konfirmasi Pembayaran]",
                          size: Dimensions.font20 / 1.5,
                        ),
                      ),
                      Get.find<TokoController>().isLoading
                          ? Container(
                        child: Obx(
                              () => BigText(
                            text: Get.find<TokoController>()
                                .getJumlahPesanan[
                            'jumlah_pesanan_berhasil_telah_dibayar']!
                                .toString(),
                            size: Dimensions.font20 / 1.5,
                          ),
                        ),
                      )
                          : Container(
                        height:
                        20,
                        width: 20,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.redColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    )
                  ]),
              margin: EdgeInsets.only(
                  top: Dimensions.height20
              ),

              padding: EdgeInsets.only(
                  top: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: BigText(
                          text: "PRODUK",
                          size: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.to(HomeTokoPage(initialIndex: 3)); // Pass the initial index to the HomeTokoPage constructor
                      //   },
                      //   child: Container(
                      //     child: BigText(
                      //       text: "Tambah Produk",
                      //       size: Dimensions.font16,
                      //       fontWeight: FontWeight.bold,
                      //       color: AppColors.notification_success,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),

                  Divider(color: AppColors.buttonBackgroundColor),
                  Container(
                    margin: EdgeInsets.only(bottom: Dimensions.height10),
                    child: Row(
                      children: [
                        BigText(
                          text: "Daftar Produkmu",
                          size: Dimensions.font16,
                        )
                      ],
                    ),
                  ),
                  Get.find<TokoController>().isLoading
                      ? Container(
                    child: Obx(
                          () => Row(
                            children: [
                              BigText(
                                text: '${Get.find<TokoController>()
                                    .getJumlahPesanan[
                                'jumlah_produk']!
                                    .toString()} produk',
                                size: Dimensions.font20 / 1.5,
                              ),
                            ],
                          )
                    ),
                  )
                      : Container(
                    height:
                    20,
                    width: 20,// set the height of the container to your desired height
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.redColor,
                      ),
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
