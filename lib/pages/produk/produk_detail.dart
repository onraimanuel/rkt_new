import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rumah_kreatif_toba/controllers/cart_controller.dart';
import 'package:rumah_kreatif_toba/controllers/popular_produk_controller.dart';
import 'package:rumah_kreatif_toba/controllers/wishlist_controller.dart';
import 'package:rumah_kreatif_toba/pages/keranjang/keranjang_page.dart';
import 'package:rumah_kreatif_toba/pages/pembelian/beli_langsung_page.dart';
import 'package:rumah_kreatif_toba/routes/route_helper.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/widgets/app_icon.dart';
import 'package:rumah_kreatif_toba/widgets/expandable_text_widget.dart';
import 'package:rumah_kreatif_toba/widgets/price_text.dart';
import 'package:rumah_kreatif_toba/widgets/tittle_text.dart';

import '../../base/show_custom_message.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/produk_models.dart';
import '../../utils/app_constants.dart';
import '../../widgets/big_text.dart';
import '../../widgets/currency_format.dart';

class ProdukDetail extends StatefulWidget {
  const ProdukDetail({Key? key}) : super(key: key);

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  bool isProdukExist = false;
  WishlistController isGetProdukExist = Get.find<WishlistController>();
  PageController pageController = PageController(viewportFraction: 0.90);
  PageController pageControllerPopulerProduct =
      PageController(viewportFraction: 0.90);

  var _currPageValue = 0.0;
  var _currPageValuePopulerProduct = 0.0;
  double _scaleFactor = 0.8;
  double _height = 200;
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
    pageControllerPopulerProduct.addListener(() {
      setState(() {
        _currPageValuePopulerProduct = pageControllerPopulerProduct.page!;
      });
    });

    super.initState();
    var wishlistList = Get.find<WishlistController>().wishlistList;
    isProdukExist = wishlistList.any((wishlist) =>
        wishlist.productId ==
        Get.find<PopularProdukController>()
            .detailProdukList[0]
            .productId
            .toInt());
  }

  @override
  Widget build(BuildContext context) {
    var produkList = Get.find<PopularProdukController>().detailProdukList;
    var daftarproduk = produkList.firstWhere(
        (produk) => produk.productId == produkList[0].productId.toInt());

    var wishlistList = Get.find<WishlistController>().wishlistList;
    isProdukExist = wishlistList.any(
        (wishlist) => wishlist.productId == produkList[0].productId.toInt());

    Future<void> _tambahKeranjang(CartController cartController) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<UserController>().usersList[0];
        cartController
            .tambahKeranjang(controller.id, produkList[0].productId.toInt(), 1)
            .then((status) {
          if (status.isSuccess) {
            showCustomSnackBar(
              "Produk berhasil ditambahkan ke keranjang",
              title: "Berhasil",
            );
          } else {
            showCustomSnackBar(status.message);
          }
        });
        cartController.getKeranjangList();
      }
    }

    Future<void> _tambahWishlist() async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<UserController>().usersList[0];

        var wishlistController = Get.find<WishlistController>();
        wishlistController
            .tambahWishlist(controller.id, produkList[0].productId.toInt())
            .then((status) {
          if (status.isSuccess) {
          } else {
            showCustomSnackBar(status.message);
          }
        });
        wishlistController.getWishlistList();
      }
    }

    Future<void> _hapusWishlist(int wishlist_id) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<UserController>();
        await controller.getUser();
        var cartController = Get.find<WishlistController>();
        cartController.hapusWishlist(wishlist_id).then((status) {
          if (status.isSuccess) {
            showCustomSnackBar(
              "Produk berhasil dihapus",
              title: "Berhasil",
            );
            isGetProdukExist.isProdukExist.value = false;
          } else {
            showCustomSnackBar(status.message);
          }
        });
        cartController.getWishlistList();
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: AppIcon(
                          icon: Icons.arrow_back,
                          size: Dimensions.height45,
                          iconColor: AppColors.redColor,
                          backgroundColor: Colors.white.withOpacity(0.0),
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
                                    backgroundColor:
                                        Colors.white.withOpacity(0.0),
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
                                            text: controller
                                                .keranjangList.length
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
              Container(
                height: Dimensions.pageView,
                margin: EdgeInsets.only(top: 10, bottom: 20),
                child: PageView.builder(
                    controller: pageController,
                    itemCount: produkList.length,
                    itemBuilder: (context, position) {
                      return _buildPageItem(position, produkList[position]);
                    }),
              ),
              new DotsIndicator(
                dotsCount: produkList.isEmpty ? 1 : produkList.length,
                position: _currPageValue,
                decorator: DotsDecorator(
                  activeColor: AppColors.redColor,
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
              Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                          top: Dimensions.height20),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radius20),
                              topRight: Radius.circular(Dimensions.radius20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PriceText(
                            text: CurrencyFormat.convertToIdr(
                                daftarproduk.price, 0),
                            color: AppColors.blackColor,
                            size: Dimensions.font20,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (Get.find<AuthController>().userLoggedIn()) {
                                if (isProdukExist) {
                                  Get.find<WishlistController>().setTypeWishlist(daftarproduk.productId, false);
                                  _hapusWishlist(produkList[0].productId.toInt());
                                  isProdukExist = false;
                                } else if (!isProdukExist) {
                                  Get.find<WishlistController>().setTypeWishlist(daftarproduk.productId, true);
                                  _tambahWishlist();
                                  isProdukExist = true;
                                }
                              } else {
                                Get.toNamed(RouteHelper.getMasukPage());
                              }
                            },
                            child: Obx(() =>  Get.find<WishlistController>().getcheckedtypeWishlist[daftarproduk.productId] ?? false ? Icon(Icons.favorite, color: Colors.pink,) : Icon(
                              CupertinoIcons.heart
                            )),
                          )
                        ],
                      )),
                  Container(
                    padding: EdgeInsets.only(
                        left: Dimensions.width20, right: Dimensions.width20),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: BigText(
                      text: daftarproduk.productName.toString(),
                      color: AppColors.blackColor,
                      size: Dimensions.font20,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        bottom: Dimensions.height20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: AppColors.buttonBackgroundColor),
                        BigText(
                          text: "Kategori : ${daftarproduk.namaKategori}",
                          size: Dimensions.font26 / 2,
                        ),
                        BigText(
                          text: "Berat : ${daftarproduk.heavy} gr",
                          size: Dimensions.font26 / 2,
                        ),
                        BigText(
                          text: "Stok : ${daftarproduk.stok}",
                          size: Dimensions.font26 / 2,
                        ),
                        SizedBox(
                          width: Dimensions.height20,
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: Dimensions.height45,),
                  Container(
                    margin: EdgeInsets.only(
                        left: Dimensions.width20, right: Dimensions.width20),
                    child: BigText(
                      text: "Deskripsi",
                      size: Dimensions.font16,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(
                        left: Dimensions.width20, right: Dimensions.width20),
                    child: SingleChildScrollView(
                      child: ExpandableTextWidget(
                          text: daftarproduk.productDescription.toString()),
                    ),
                  ),
                  Divider(color: AppColors.buttonBackgroundColor),
                  Container(
                      margin: EdgeInsets.only(
                          left: Dimensions.width20, right: Dimensions.width20),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimensions.radius15)),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      '${AppConstants.BASE_URL_IMAGE}u_file/foto_merchant/${daftarproduk.fotoMerchant.toString()}',
                                    ))),
                          ),
                          SizedBox(
                            width: Dimensions.width10,
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BigText(
                                  text: daftarproduk.namaMerchant.toString(),
                                  fontWeight: FontWeight.bold,
                                  size: Dimensions.font26 / 2,
                                ),
                                BigText(
                                  text: daftarproduk.cityName.toString(),
                                  size: Dimensions.font16 / 1.5,
                                ),
                                BigText(
                                  text: daftarproduk.subdistrictName.toString(),
                                  size: Dimensions.font16 / 1.5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: GetBuilder<PopularProdukController>(
          builder: (produk) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GetBuilder<CartController>(builder: (cartController) {
                  return Container(
                    height: Dimensions.bottomHeightBar,
                    padding: EdgeInsets.only(
                        top: Dimensions.height10,
                        bottom: Dimensions.height10,
                        left: Dimensions.width20,
                        right: Dimensions.width20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container(
                        //   padding: EdgeInsets.only(
                        //       top: Dimensions.height10 / 2,
                        //       bottom: Dimensions.height10 / 2,
                        //       left: Dimensions.width10,
                        //       right: Dimensions.width10),
                        //   decoration: BoxDecoration(
                        //       border: Border.all(
                        //           color: AppColors.buttonBackgroundColor),
                        //       borderRadius:
                        //           BorderRadius.circular(Dimensions.radius20),
                        //       color: Colors.white),
                        //   child: Row(
                        //     children: [
                        //       GestureDetector(
                        //         onTap: () {
                        //           produk.setQuantity(false);
                        //         },
                        //         child: AppIcon(
                        //             iconSize: Dimensions.iconSize16,
                        //             iconColor: AppColors.redColor,
                        //             backgroundColor: Colors.white,
                        //             icon: Icons.remove),
                        //       ),
                        //       SizedBox(
                        //         width: Dimensions.width10 / 2,
                        //       ),
                        //       BigText(text: produk.inCartItems.toString()),
                        //       SizedBox(
                        //         width: Dimensions.width10 / 2,
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {
                        //           produk.setQuantity(true);
                        //         },
                        //         child: AppIcon(
                        //             iconSize: Dimensions.iconSize16,
                        //             iconColor: AppColors.redColor,
                        //             backgroundColor: Colors.white,
                        //             icon: Icons.add),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        Container(
                          padding: EdgeInsets.only(
                              top: Dimensions.height10 / 2,
                              bottom: Dimensions.height10 / 2,
                              left: Dimensions.width10,
                              right: Dimensions.width10),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.redColor),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius20 / 2),
                              color: Colors.white),
                          child: GestureDetector(
                            onTap: () {
                              if (Get.find<AuthController>().userLoggedIn()) {
                                _tambahKeranjang(cartController);
                              } else {
                                Get.toNamed(RouteHelper.getMasukPage());
                              }
                            },
                            child: AppIcon(
                              icon: Icons.message,
                              iconSize: Dimensions.iconSize24,
                              iconColor: AppColors.redColor,
                              backgroundColor: Colors.white.withOpacity(0.0),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: Dimensions.height20 / 1.1,
                              bottom: Dimensions.height20 / 1.1,
                              left: Dimensions.width10,
                              right: Dimensions.width10),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.redColor),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius20 / 2),
                              color: Colors.white),
                          child: GestureDetector(
                              onTap: () {
                                if (Get.find<AuthController>().userLoggedIn()) {
                                  Get.find<CartController>().items.clear();
                                  Get.find<CartController>()
                                      .addItem(daftarproduk, 1);
                                  Get.to(BeliLangsungPage());
                                } else {
                                  Get.toNamed(RouteHelper.getMasukPage());
                                }
                              },
                              child: Row(children: [
                                BigText(
                                  text: "Beli Langsung",
                                  color: Colors.redAccent,
                                  size: Dimensions.height15,
                                ),
                              ])),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: Dimensions.height10 / 2,
                              bottom: Dimensions.height10 / 2,
                              left: Dimensions.width10,
                              right: Dimensions.width20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius20 / 2),
                              color: AppColors.redColor),
                          child: GestureDetector(
                              onTap: () {
                                if (Get.find<AuthController>().userLoggedIn()) {
                                  _tambahKeranjang(cartController);
                                } else {
                                  Get.toNamed(RouteHelper.getMasukPage());
                                }
                              },
                              child: Row(children: [
                                AppIcon(
                                    iconSize: Dimensions.iconSize16,
                                    iconColor: Colors.white,
                                    backgroundColor: AppColors.redColor,
                                    icon: Icons.add),
                                BigText(
                                  text: "Keranjang",
                                  color: Colors.white,
                                  size: Dimensions.height15,
                                ),
                              ])),
                        )
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        ));
  }

  Widget _buildPageItem(int index, Produk produkList) {
    Matrix4 matrix = new Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            height: Dimensions.pageViewContainer,
            margin: EdgeInsets.only(
                left: Dimensions.width10, right: Dimensions.width10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294cc),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${produkList.productImageName.toString()}',
                    ))),
            // child: BigText(text: produkList.productImageName.toString(),),
          )
        ],
      ),
    );
  }
}
