import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/popular_produk_controller.dart';
import 'package:rumah_kreatif_toba/controllers/wishlist_controller.dart';

import '../../base/show_custom_message.dart';
import '../../base/snackbar_message.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/user_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/currency_format.dart';
import '../../widgets/price_text.dart';
import '../../widgets/small_text.dart';
import '../../widgets/tittle_text.dart';
import '../account/main_account_page.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    Get.find<WishlistController>().getWishlistList();
  }

  @override
  Widget build(BuildContext context) {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUser();
      Get.find<CartController>().getKeranjangList();
    }

    Future<void> _tambahKeranjang(int product_id) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<UserController>().usersList[0];
        var cartController = Get.find<CartController>();
        cartController
            .tambahKeranjang(controller.id, product_id,
            1)
            .then((status) {
          if (status.isSuccess) {
            AwesomeSnackbarButton("Berhasil","Produk berhasil ditambahkan ke keranjang",ContentType.success);
          } else {
            AwesomeSnackbarButton("Gagal",status.message,ContentType.failure);
          }
        });
        cartController.getKeranjangList();
      }
    }

    Future<void> _hapusWishlist(int wishlist_id) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<UserController>();
        await controller.getUser();
        var cartController = Get.find<WishlistController>();
        cartController
            .hapusWishlist(wishlist_id)
            .then((status) {
          if (status.isSuccess) {
            AwesomeSnackbarButton("Berhasil","Produk berhasil dihapus",ContentType.success);
          } else {
            AwesomeSnackbarButton("Gagal",status.message,ContentType.failure);
          }
        });
        cartController.getWishlistList();
      }
    }
    return Scaffold(
      body: _userLoggedIn
          ? RefreshIndicator(
          child: Column(
        children: [
          Container(
            child: Container(
              margin: EdgeInsets.only(
                  top: Dimensions.height30),
              padding: EdgeInsets.only(
                  left: Dimensions.width20, right: Dimensions.width20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: BigText(
                      text: "Favorit",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                      child: Row(
                        children: [
                          GetBuilder<CartController>(builder: (controller) {
                            return GestureDetector(
                              onTap: () {
                                if (Get.find<AuthController>().userLoggedIn()) {
                                  Get.toNamed(RouteHelper.getKeranjangPage());
                                } else {
                                  Get.toNamed(RouteHelper.getMasukPage());
                                }
                              },
                              child: Stack(
                                children: [
                                  AppIcon(
                                    icon: Icons.shopping_cart_outlined,
                                    size: Dimensions.height45,
                                    iconColor: AppColors.redColor,
                                    backgroundColor: Colors.white.withOpacity(0.0),
                                  ),
                                  controller.keranjangList.length >= 1
                                      ? Positioned(
                                      right: 0,
                                      top: 0,
                                      child: AppIcon(
                                        icon: Icons.circle,
                                        size: 20,
                                        iconColor: AppColors.notification_success,
                                      ))
                                      : Container(),
                                  controller.keranjangList.length >= 1
                                      ? Positioned(
                                    right: 6,
                                    top: 3,
                                    child: BigText(
                                      text: controller.keranjangList.length
                                          .toString(),
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            );
                          })
                        ],
                      ))
                ],
              ),
            ),
          ),
          Expanded(child:
          SingleChildScrollView(
            child: GetBuilder<WishlistController>(builder: (wishlistController) {
              return wishlistController.isLoading
                  ? GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: Dimensions.height45*7),
                  itemCount: wishlistController.wishlistList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var gambarproduk = Get.find<PopularProdukController>().imageProdukList.where(
                            (produk) =>
                        produk.productId ==
                            wishlistController
                                .wishlistList[index].productId);
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 150,
                        height: Dimensions.height45*7,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              )
                            ]),
                        margin: EdgeInsets.only(
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                          bottom: Dimensions.height20,),
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //image section
                              Container(
                                height: Dimensions.height45*3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(Dimensions.radius15),
                                        topRight: Radius.circular(Dimensions.radius15)),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${gambarproduk.single.productImageName}',
                                        ))
                                ),
                                // child: SmallText(text: gambarproduk.single.productImageName.toString(),),
                              ),
                              Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    TittleText(
                                      text: wishlistController.wishlistList[index].productName,
                                      size: Dimensions.font16,
                                    ),
                                    PriceText(
                                      text:CurrencyFormat.convertToIdr(
                                          wishlistController.wishlistList[index].price,
                                          0),
                                      color: AppColors.redColor,
                                      size: Dimensions.font16,
                                    ),
                                    SmallText(
                                      text: wishlistController.wishlistList[index].namaMerchant,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: Dimensions.height10/2,
                                              bottom: Dimensions.height10/2,
                                              left: Dimensions.width10/2,
                                              right: Dimensions.width10/2),
                                          child: GestureDetector(
                                              onTap: ()
                                              // {
                                              //   showModalBottomSheet(
                                              //       backgroundColor:
                                              //       Colors.transparent,
                                              //       context: context,
                                              //       builder: (context) {
                                              //         return SingleChildScrollView(
                                              //           child: Container(
                                              //             width: Dimensions
                                              //                 .screenWidth,
                                              //             decoration: BoxDecoration(
                                              //                 color: Colors.white,
                                              //                 borderRadius: BorderRadius.only(
                                              //                     topLeft: Radius
                                              //                         .circular(
                                              //                         Dimensions
                                              //                             .radius20),
                                              //                     topRight: Radius
                                              //                         .circular(
                                              //                         Dimensions
                                              //                             .radius20))),
                                              //             padding: EdgeInsets.only(
                                              //                 top: Dimensions
                                              //                     .height10,
                                              //                 left: Dimensions
                                              //                     .width20,
                                              //                 right: Dimensions
                                              //                     .width20),
                                              //             child: Column(
                                              //               children: [
                                              //                 GestureDetector(
                                              //                   onTap: (){
                                              //                     Navigator.pop(
                                              //                         context);
                                              //                   },
                                              //                   child: Row(children: [
                                              //                     AppIcon(
                                              //                       icon: CupertinoIcons.xmark,
                                              //                       size: Dimensions
                                              //                           .iconSize16,
                                              //                       iconColor:
                                              //                       AppColors
                                              //                           .redColor,
                                              //                       backgroundColor:
                                              //                       Colors.white
                                              //                           .withOpacity(
                                              //                           0.0),
                                              //                     ),
                                              //                     SizedBox(
                                              //                       width: Dimensions
                                              //                           .width20,
                                              //                     ),
                                              //                   ]),
                                              //                 ),
                                              //                 Divider(
                                              //                     color: AppColors
                                              //                         .buttonBackgroundColor),
                                              //                 Container(
                                              //                   height: Dimensions.height45*2,
                                              //                   padding: EdgeInsets.only(
                                              //                       left: Dimensions
                                              //                           .width20,
                                              //                       right: Dimensions
                                              //                           .width20,
                                              //                       top: Dimensions
                                              //                           .height20),
                                              //                   child: Column(
                                              //                     children: [
                                              //                       InkWell(
                                              //                         onTap: () {
                                              //                           _hapusWishlist(wishlistController.wishlistList[index].wishlistId);
                                              //                           Navigator.pop(
                                              //                               context);
                                              //                         },
                                              //                         child:
                                              //                         Row(children: [
                                              //                           AppIcon(
                                              //                             icon: Icons
                                              //                                 .delete,
                                              //                             size: Dimensions
                                              //                                 .iconSize24,
                                              //                             iconColor:
                                              //                             AppColors
                                              //                                 .redColor,
                                              //                             backgroundColor:
                                              //                             Colors.white
                                              //                                 .withOpacity(
                                              //                                 0.0),
                                              //                           ),
                                              //                           SizedBox(
                                              //                             width: Dimensions
                                              //                                 .width20,
                                              //                           ),
                                              //                           BigText(
                                              //                             text: "Hapus",
                                              //                           )
                                              //                         ]),
                                              //                       ),
                                              //                       SizedBox(
                                              //                           height: Dimensions
                                              //                               .height10),
                                              //                     ],
                                              //                   ),
                                              //                 )
                                              //               ],
                                              //             ),
                                              //           ),
                                              //         );
                                              //       });
                                              // },
                                              {
                                                _hapusWishlist(wishlistController.wishlistList[index].wishlistId);
                                              },
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.delete, color: AppColors.redColor, size: Dimensions.iconSize16,),
                                                  ])),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: Dimensions.height10/2,
                                              bottom: Dimensions.height10/2,
                                              left: Dimensions.width10/2,
                                              right: Dimensions.width10/2),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: AppColors.redColor),
                                              borderRadius: BorderRadius.circular(
                                                  Dimensions.radius20 / 2),
                                              color: Colors.white),
                                          child: GestureDetector(
                                              onTap: () {
                                                _tambahKeranjang(wishlistController.wishlistList[index].productId);
                                              },
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.add, color: AppColors.redColor, size: Dimensions.iconSize16,),
                                                    BigText(
                                                      text: "Keranjang",
                                                      color: AppColors.redColor,
                                                      size: Dimensions.height15,
                                                    ),
                                                  ])),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                              //text container
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              )
                  : CircularProgressIndicator(
                color: AppColors.redColor,
              );
            }),
          )),
        ],
      ), onRefresh: () => Get.find<WishlistController>().getWishlistList()) : MainAccountPage(),
    );
  }
}
