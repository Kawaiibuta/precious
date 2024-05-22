import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:precious/models/product/product.dart';
import 'package:precious/models/type/type.dart';
import 'package:precious/models/product_category/product_category.dart';
import 'package:precious/presenters/category_presenter.dart';
import 'package:precious/presenters/product_presenter.dart';
import 'package:precious/presenters/type_presenter.dart';
import 'package:precious/resources/app_export.dart';
import 'package:precious/resources/widgets/catagory_button.dart';
import 'package:precious/resources/widgets/custom_search_bar.dart';
import 'package:precious/resources/widgets/product_card.dart';
import 'package:precious/resources/widgets/sale_banner.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, this.changePage});
  static const name = '/landingPage';
  final Function? changePage;
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int categoriesSelected = 0;
  //late Future<List<Product>> getMoreProductFuture;
  List<Type> typeList = [];
  List<Product> productList = [];
  late Future<List<ProductCategory>> categoryListFuture;
  Map<int, Future<List<Product>>> productByType = {};
  ProductPresenter productPresenter = ProductPresenter();
  TypePresenter typePresenter = TypePresenter();
  ProductCategoryPresenter categoryPresenter = ProductCategoryPresenter();

  bool _loadMore = true;

  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    getMoreProduct();
    categoryListFuture = categoryPresenter.getAll();
    typePresenter.getAll().then((value) {
      typeList = value;
    });
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      // Setup the listener.
      _controller.addListener(() {
        if (_controller.position.atEdge) {
          bool isTop = _controller.position.pixels == 0;
          if (!isTop) {
            getMoreProduct();
          }
        }
      });
      for (var element in typeList) {
        productByType.addEntries(<int, Future<List<Product>>>{
          element.id!: typePresenter.getProductByType(element.id!)
        }.entries);
      }
    });
  }

  void getMoreProduct() {
    productPresenter.getAll(more: true).then((value) => setState(() {
          productList.addAll(value);
          _loadMore = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          controller: _controller,
          child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(
        height: 10,
      ),
      Row(
        children: [
          Text(
            'Welcome,',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          )
        ],
      ),
      Row(
        children: [
          Text(
            "Enjoy your shopping",
            style: GoogleFonts.openSans(fontSize: 15, color: Colors.grey),
          )
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      CustomSearchBar(
        onFocus: () {
          debugPrint(widget.changePage.toString());
          if (widget.changePage != null) widget.changePage!(1);
        },
      ),
      const SizedBox(
        height: 10.0,
      ),
      // Sale banner row
      const SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: SaleBanner(
                title: "50% Sale",
                color: Colors.white,
                image: AssetImage('assets/images/sale.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: SaleBanner(
                title: "50% Sale",
                color: Colors.white,
                image: AssetImage('assets/images/sale.png'),
              ),
            )
          ],
        ),
      ),
      FutureBuilder(
          future: categoryListFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              debugPrint(snapshot.hasError.toString());
              return const SizedBox.shrink();
            }
            var categoryList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: categoryList
                        .asMap()
                        .map((i, e) => MapEntry(
                              i,
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: CategoryButton(
                                  title: e.name,
                                  selected: (i == categoriesSelected),
                                  onClick: () => setState(() {
                                    categoriesSelected = i;
                                  }),
                                ),
                              ),
                            ))
                        .values
                        .toList()),
              ),
            );
          }),
      // ...typeList.map((type) {
      //   return Column(children: [
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Text(
      //           type.name,
      //           style: const TextStyle(
      //               fontWeight: FontWeight.bold, fontSize: 17),
      //         ),
      //         TextButton(
      //             onPressed: () {},
      //             child: const Text(
      //               "View all",
      //               style: TextStyle(fontSize: 10.0),
      //             ))
      //       ],
      //     ),
    
      //     FutureBuilder(
      //         future: productByType[type.id],
      //         builder: (context, snapshot) {
      //           if (snapshot.hasError)
      //             return Text(snapshot.error.toString());
      //           if (!snapshot.hasData) {
      //             return const CircularProgressIndicator.adaptive();
      //           }
      //           final products = snapshot.data!;
      //           return Column(
      //             children: [
      //               SingleChildScrollView(
      //                 scrollDirection: Axis.horizontal,
      //                 child: Row(
      //                     children: products
      //                         .map((e) => Padding(
      //                               padding: const EdgeInsets.only(
      //                                   right: 8.0),
      //                               child: ProductCard(
      //                                 product: e,
      //                               ),
      //                             ))
      //                         .toList()),
      //               ),
      //             ],
      //           );
      //         })
      //     // : const SizedBox.shrink(),
      //   ]);
      // }),
    
      const Text("Discovery",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
      GridView.count(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 5,
        mainAxisSpacing: 100,
        shrinkWrap: true,
        crossAxisCount: 2,
        children: <Widget>[
          ...productList.map((e) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ProductCard(
                  product: e,
                ),
              )),
        ],
      ),
      // Load more
      if (_loadMore)
        SizedBox(
            width: 200.h,
            height: 200.v,
            child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onBackground)),
      const SizedBox(
        height: 100,
      )
    ],
          ),
        );
  }
}
