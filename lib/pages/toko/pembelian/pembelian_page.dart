import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/pembelian_controller.dart';
import 'package:rumah_kreatif_toba/pages/toko/pembelian/pembelian_detailpage.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import '../../../base/show_custom_message.dart';
import '../../../controllers/pesanan_controller.dart';
import '../../../routes/route_helper.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/currency_format.dart';
import '../../../widgets/price_text.dart';
import '../../../widgets/small_text.dart';

class DaftarPembelianPage extends StatefulWidget {
  const DaftarPembelianPage({Key? key}) : super(key: key);

  @override
  State<DaftarPembelianPage> createState() => _DaftarPembelianPageState();
}

class _DaftarPembelianPageState extends State<DaftarPembelianPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_isLoggedIn) {
      _tabController = TabController(length: 2, vsync: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.find<PembelianController>().getPembelianList();
    Future<void> _detailPembelianList(String kode_pembelian) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<PembelianController>();
        controller.detailPembelian(kode_pembelian).then((status) async {
          if (status.isSuccess) {
            Get.to(PembelianDetailPage());
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
        body: Column(
      children: [
        Container(
          child: Container(
            margin: EdgeInsets.only(
                top: Dimensions.height30, bottom: Dimensions.height10),
            padding: EdgeInsets.only(
                left: Dimensions.width20, right: Dimensions.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: BigText(
                    text: "Daftar Pembelian",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: Dimensions.screenWidth,
          child: TabBar(
            indicatorColor: AppColors.redColor,
            indicatorWeight: 3,
            labelColor: AppColors.redColor,
            unselectedLabelColor: AppColors.orangeColor,
            controller: _tabController,
            tabs: [
              Tab(text: "Menunggu Konfirmasi"),
              Tab(
                text: "Riwayat",
              )
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              GetBuilder<PembelianController>(builder: (controller) {
                var _menungguKonfirmasiList = controller.pembelianList
                    .where((item) => item.statusPembelian == "status2_ambil")
                    .toList();
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: Dimensions.height45 * 5),
                    itemCount: _menungguKonfirmasiList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        width: Dimensions.screenWidth,
                        height: Dimensions.height45 * 3.5,
                        margin: EdgeInsets.only(
                            bottom: Dimensions.height10,
                            top: Dimensions.height10 / 2,
                            left: Dimensions.width20,
                            right: Dimensions.width20),
                        padding: EdgeInsets.all(Dimensions.height10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.buttonBackgroundColor),
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          child: AppIcon(
                                            icon: Icons.shopping_bag_outlined,
                                            iconSize: Dimensions.iconSize24,
                                            iconColor: AppColors.redColor,
                                            backgroundColor:
                                                Colors.white.withOpacity(0.0),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            BigText(
                                              text: "Belanja",
                                              size: Dimensions.font16,
                                            ),
                                            SmallText(
                                                text: _menungguKonfirmasiList[index].name
                                                    .toString())
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.all(Dimensions.height10 / 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radius20 / 2),
                                        color: AppColors.notification_success),
                                    child: BigText(
                                      text: "Perlu Dikemas",
                                      size: Dimensions.iconSize16,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Divider(color: AppColors.buttonBackgroundColor),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(

                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            var produkIndex =
                                            controller
                                                .detailPembelianList[index]
                                                .productId!;
                                            if (produkIndex >= 0) {
                                              Get.toNamed(RouteHelper
                                                  .getProdukDetail(
                                                  produkIndex));
                                            }
                                          },
                                          child: Container(
                                            width:
                                            Dimensions.height20 *
                                                3,
                                            height:
                                            Dimensions.height20 *
                                                3,
                                            margin: EdgeInsets.only(
                                                top: Dimensions
                                                    .height10),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        "assets/images/coffee.jpg")),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    Dimensions
                                                        .radius20),
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: Dimensions.width20,),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width : Dimensions.screenWidth/1.6,
                                              child: BigText(
                                                text: _menungguKonfirmasiList[index]
                                                    .productName,
                                                size: Dimensions.font16,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SmallText(
                                                    text: "${ _menungguKonfirmasiList[index]
                                                        .jumlahPembelianProduk} x "),
                                                PriceText(
                                                  text: CurrencyFormat
                                                      .convertToIdr(
                                                      _menungguKonfirmasiList[index]
                                                          .price,
                                                      0),
                                                  size: Dimensions.font16,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: Dimensions.height10,),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SmallText(text: "Total Belanja"),
                                            PriceText(
                                              text: CurrencyFormat.convertToIdr(
                                                  _menungguKonfirmasiList[index]
                                                      .hargaPembelian,
                                                  0),
                                              size: Dimensions.font16,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _detailPembelianList(_menungguKonfirmasiList[index].kodePembelian
                                          .toString());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: Dimensions.height10 / 2,
                                          bottom: Dimensions.height10 / 2,
                                          left: Dimensions.height10,
                                          right: Dimensions.height10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.redColor),
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radius20 / 2),
                                          color: Colors.white),
                                      child: BigText(
                                        text: "Lihat Detail",
                                        size: Dimensions.iconSize16,
                                        color: AppColors.redColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }),
              GetBuilder<PembelianController>(builder: (controller) {
                var _sudahKonfirmasiList = controller.pembelianList
                    .where((item) => item.statusPembelian != "status2_ambil")
                    .toList();
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: Dimensions.height45 * 5),
                    itemCount: _sudahKonfirmasiList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        width: Dimensions.screenWidth,
                        height: Dimensions.height45 * 3.5,
                        margin: EdgeInsets.only(
                            bottom: Dimensions.height10,
                            top: Dimensions.height10 / 2,
                            left: Dimensions.width20,
                            right: Dimensions.width20),
                        padding: EdgeInsets.all(Dimensions.height10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.buttonBackgroundColor),
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          child: AppIcon(
                                            icon: Icons.shopping_bag_outlined,
                                            iconSize: Dimensions.iconSize24,
                                            iconColor: AppColors.redColor,
                                            backgroundColor:
                                            Colors.white.withOpacity(0.0),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            BigText(
                                              text: "Belanja",
                                              size: Dimensions.font16,
                                            ),
                                            SmallText(
                                                text: _sudahKonfirmasiList[index].name
                                                    .toString())
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                    EdgeInsets.all(Dimensions.height10 / 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radius20 / 2),
                                        color: AppColors.notification_success),
                                    child: BigText(
                                      text: "Perlu Dikemas",
                                      size: Dimensions.iconSize16,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(color: AppColors.buttonBackgroundColor),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(

                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            var produkIndex =
                                            controller
                                                .detailPembelianList[index]
                                                .productId!;
                                            if (produkIndex >= 0) {
                                              Get.toNamed(RouteHelper
                                                  .getProdukDetail(
                                                  produkIndex));
                                            }
                                          },
                                          child: Container(
                                            width:
                                            Dimensions.height20 *
                                                3,
                                            height:
                                            Dimensions.height20 *
                                                3,
                                            margin: EdgeInsets.only(
                                                top: Dimensions
                                                    .height10),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        "assets/images/coffee.jpg")),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    Dimensions
                                                        .radius20),
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: Dimensions.width20,),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width : Dimensions.screenWidth/1.6,
                                              child: BigText(
                                                text: _sudahKonfirmasiList[index]
                                                    .productName,
                                                size: Dimensions.font16,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SmallText(
                                                    text: "${ _sudahKonfirmasiList[index]
                                                        .jumlahPembelianProduk} x "),
                                                PriceText(
                                                  text: CurrencyFormat
                                                      .convertToIdr(
                                                      _sudahKonfirmasiList[index]
                                                          .price,
                                                      0),
                                                  size: Dimensions.font16,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: Dimensions.height10,),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            SmallText(text: "Total Belanja"),
                                            PriceText(
                                              text: CurrencyFormat.convertToIdr(
                                                  _sudahKonfirmasiList[index]
                                                      .hargaPembelian,
                                                  0),
                                              size: Dimensions.font16,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _detailPembelianList(_sudahKonfirmasiList[index].kodePembelian
                                          .toString());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: Dimensions.height10 / 2,
                                          bottom: Dimensions.height10 / 2,
                                          left: Dimensions.height10,
                                          right: Dimensions.height10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.redColor),
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radius20 / 2),
                                          color: Colors.white),
                                      child: BigText(
                                        text: "Lihat Detail",
                                        size: Dimensions.iconSize16,
                                        color: AppColors.redColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              })
            ],
          ),
        ),
      ],
    ));
  }
}