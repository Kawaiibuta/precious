import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:precious/models/product/product.dart';
import 'package:precious/presenters/product_presenter.dart';
import 'package:precious/resources/utils/string_utils.dart';
import 'package:precious/resources/widgets/custom_search_bar.dart';

const imageList = [
  'assets/images/sale.jpg',
  'assets/images/sale.jpg',
  'assets/images/sale.jpg',
  'assets/images/sale.jpg',
];

const des =
    "This beautiful 14k yellow gold bracelet features a delicate chain with a polished finish. The highlight of the bracelet is a charming heart-shaped charm, adorned with sparkling cubic zirconia gemstones. The charm dangles freely from the chain, adding a touch of movement and whimsy. Secured with a lobster clasp closure, this bracelet is a perfect addition to any jewelry collection. https://picsum.photos/id/237/200/300";

class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({super.key, required this.id});
  final int id;
  static const name = '/productDetail';

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  var selectedSize = -1;
  var favoriteed = false;
  var quantity = 0;
  late Future<Product?> productFuture;
  final productPresenter = ProductPresenter();
  var open = false;
  @override
  void initState() {
    super.initState();
    productFuture = productPresenter.getOne(widget.id).then((e) {
      __handleUp(e);
      return e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: productFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.done &&
                (!snapshot.hasData || snapshot.data == null)) {
              Navigator.of(context).pop();
              return const SizedBox.shrink();
            }
            final product = snapshot.data!;
            return Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CarouselSlider(
                    options: CarouselOptions(
                        viewportFraction: 1,
                        aspectRatio: MediaQuery.of(context).size.width /
                            MediaQuery.of(context).size.height),
                    items: product.img_paths_url.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return InkWell(
                            onTap: () {
                              showImageViewer(
                                  context,
                                  (Uri.parse(i).isAbsolute
                                      ? CachedNetworkImageProvider(i)
                                      : AssetImage(i)) as ImageProvider,
                                  onViewerDismissed: () {
                                print("dismissed");
                              });
                            },
                            child: CachedNetworkImage(
                              imageUrl: i,
                              // placeholder: (context, e) => const Center(
                              //     child: CircularProgressIndicator()),
                              progressIndicatorBuilder:
                                  (context, e, progress) =>
                                      CircularPercentIndicator(
                                radius: 30.0,
                                lineWidth: 5.0,
                                percent: progress.downloaded /
                                    (progress.totalSize ?? progress.downloaded),
                                progressColor: Colors.black,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                AnimatedPositioned(
                    top: 25,
                    left: 0,
                    right: 0,
                    height: open ? 50 : 0,
                    duration: const Duration(seconds: 2),
                    child: const Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: CustomSearchBar())),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          __handleUp(await productFuture);
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.arrow_upward,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void __handleUp(Product? product) {
    if (product == null) return;
    setState(() {
      open = true;
    });
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return Material(
                  child: Stack(
                    children: [
                      Container(
                        height: 600,
                        padding: const EdgeInsets.all(18.0),
                        child: SingleChildScrollView(
                            child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            product.name,
                                            style: GoogleFonts.openSans(
                                                fontSize: 27,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(product.short_description,
                                              style: GoogleFonts.openSans(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Row(
                                    children: [
                                      //Review goes here in the 2.0 version
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        favoriteed = !favoriteed;
                                      });
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: favoriteed
                                                  ? Colors.white
                                                  : Colors.black)),
                                      child: Icon(
                                        favoriteed
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 18.0, bottom: 18.0),
                            child: Row(children: [
                              Text("Sizes:",
                                  style: GoogleFonts.openSans(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))
                            ]),
                          ),
                          Row(children: [
                            ...[8, 9, 10, 11]
                                .asMap()
                                .map((key, value) => MapEntry(
                                      key,
                                      Container(
                                        width: 50,
                                        height: 50,
                                        alignment: Alignment.center,
                                        margin:
                                            const EdgeInsets.only(right: 10.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: selectedSize == key
                                                ? Colors.black
                                                : null),
                                        child: InkWell(
                                          onTap: () {
                                            selectedSize = key;
                                            setState(() {});
                                          },
                                          child: Text(value.toString(),
                                              style: GoogleFonts.openSans(
                                                  fontSize: 17,
                                                  color: selectedSize == key
                                                      ? Colors.white
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ))
                                .values
                                .toList()
                          ]),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Row(
                              children: [
                                Text("Descriptions",
                                    style: GoogleFonts.openSans(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Wrap(
                            children: [
                              ...getLink(product.description).map((e) {
                                if (Uri.parse(e).isAbsolute) {
                                  return InkWell(
                                      onTap: () {
                                        showImageViewer(context,
                                            CachedNetworkImageProvider(e),
                                            onViewerDismissed: () {
                                          print("dismissed");
                                        });
                                      },
                                      child: Image.network(
                                        e,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      ));
                                } else {
                                  return Text(e,
                                      style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500));
                                }
                              })
                            ],
                          ),
                          const SizedBox(
                            height: 70,
                          )
                        ])),
                      ),
                      Positioned(
                          bottom: 30,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                                height: 50,
                                margin: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text("Total price"),
                                          Text(
                                            product.price > 10 ^ 6
                                                ? "${(product.price ~/ pow(10, 6))}Tr"
                                                : "${(product.price ~/ pow(10, 3))}K",
                                            style: GoogleFonts.openSans(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: InkWell(
                                          child: Container(
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.black),
                                            child: const Center(
                                              child: Text("Add to cart",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ))
                                  ],
                                )),
                          )),
                    ],
                  ),
                );
              },
            ));
  }
}
