import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/cart_controller.dart';
import 'package:rumah_kreatif_toba/controllers/popular_produk_controller.dart';
import 'package:rumah_kreatif_toba/pages/home/main_home_page.dart';
import 'package:rumah_kreatif_toba/routes/route_helper.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/widgets/app_icon.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';
import 'package:rumah_kreatif_toba/widgets/small_text.dart';

import '../../widgets/currency_format.dart';

class KeranjangPage extends StatelessWidget {
  const KeranjangPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: Dimensions.height20 * 3,
              left: Dimensions.width20,
              right: Dimensions.width20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppIcon(
                    icon: Icons.arrow_back,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.redColor,
                    iconSize: Dimensions.iconSize24,
                  ),
                  SizedBox(width: Dimensions.width20*5,),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.getInitial());
                    },
                    child: AppIcon(
                      icon: Icons.home_outlined,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.redColor,
                      iconSize: Dimensions.iconSize24,
                    ),
                  ),

                  AppIcon(
                    icon: Icons.shopping_cart,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.redColor,
                    iconSize: Dimensions.iconSize24,
                  )
                ],
              )),
          Positioned(
              top: Dimensions.height20 * 5,
              left: Dimensions.width20,
              right: Dimensions.width20,
              bottom: 0,
              child: Container(
                margin: EdgeInsets.only(top: Dimensions.height15),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: GetBuilder<CartController>(builder: (cartController){
                    var _keranjangList = cartController.getItems;
                    return ListView.builder(
                        itemCount: cartController.getItems.length,
                        itemBuilder: (_, index) {
                          return Container(
                            width: double.maxFinite,
                            height: 150,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                          var produkIndex = cartController.getItems[index].productId!;
                                         // cartController.getItems[index].productName!;
                                          print(produkIndex.toString());
                                          // Get.toNamed(RouteHelper.getProdukDetail(
                                          //     popularProduk.popularProdukList[index].productId));
                                          if(produkIndex >= 0){
                                            Get.toNamed(RouteHelper.getProdukDetail(produkIndex));
                                          }

                                          // else{
                                          //   var produkIndex = Get.find<PopularProdukController>().popularProdukList.indexOf(_keranjangList[index].produk!);
                                          // }
                                      },
                                      child:Container(
                                        width: Dimensions.height20 * 5,
                                        height: Dimensions.height20 * 5,
                                        margin: EdgeInsets.only(
                                            bottom: Dimensions.height10),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    "assets/images/coffee.jpg")),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radius20),
                                            color: Colors.white),
                                      ) ,
                                    ),
                                    SizedBox(width: Dimensions.width10),
                                    ExcludeFocus(
                                      child: Container(
                                        height: Dimensions.height20 * 5,
                                        width: Dimensions.width45*6,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            BigText(
                                              text: cartController.getItems[index].productName!,
                                              color: Colors.black45,
                                            ),
                                            SmallText(text: "Spicy"),
                                            Row(
                                              children: [
                                                BigText(
                                                  text:  CurrencyFormat.convertToIdr(cartController.getItems[index]!.price, 0),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width : 150,
                                      padding: EdgeInsets.only(
                                          left: Dimensions.width20,
                                          right: Dimensions.width20),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.buttonBackgroundColor),
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radius20),
                                          color: Colors.white),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              //produk.setQuantity(false);
                                              cartController.addItem(_keranjangList[index].produk!, -1);
                                            },
                                            child: AppIcon(
                                                iconSize: Dimensions.iconSize24,
                                                iconColor: AppColors.redColor,
                                                backgroundColor: Colors.white,
                                                icon: Icons.remove),
                                          ),
                                          SizedBox(
                                            width: Dimensions.width10 / 2,
                                          ),
                                          BigText(
                                              text:
                                              _keranjangList[index].jumlahMasukKeranjang.toString()), //produk.inCartItems.toString()),
                                          SizedBox(
                                            width: Dimensions.width10 / 2,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              cartController.addItem(_keranjangList[index].produk!, 1);
                                            },
                                            child: AppIcon(
                                                iconSize: Dimensions.iconSize24,
                                                iconColor: AppColors.redColor,
                                                backgroundColor: Colors.white,
                                                icon: Icons.add),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  }),
                ),
              ))
        ],
      ),
        bottomNavigationBar: GetBuilder<CartController>(
          builder: (cartController) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: Dimensions.bottomHeightBar,
                  padding: EdgeInsets.only(
                      top: Dimensions.height10,
                      bottom: Dimensions.height10,
                      left: Dimensions.width20,
                      right: Dimensions.width20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: Dimensions.height10,
                            bottom: Dimensions.height10,
                            left: Dimensions.width20,
                            right: Dimensions.width20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.buttonBackgroundColor),
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                            color: Colors.white),
                        child: Row(
                          children: [
                            SizedBox(
                              width: Dimensions.width10 / 2,
                            ),
                            BigText(text: CurrencyFormat.convertToIdr(cartController.totalAmount, 0)),
                            SizedBox(
                              width: Dimensions.width10 / 2,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: Dimensions.height10,
                            bottom: Dimensions.height10,
                            left: Dimensions.width20,
                            right: Dimensions.width20),
                        child: GestureDetector(
                            onTap: () {

                            },
                            child: Row(children: [
                              AppIcon(
                                  iconSize: Dimensions.iconSize24,
                                  iconColor: Colors.white,
                                  backgroundColor: AppColors.redColor,
                                  icon: Icons.add),
                              BigText(
                                text: "Checkout",
                                color: Colors.white,
                              ),
                            ])),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                            color: AppColors.redColor),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        )
    );

  }
}
