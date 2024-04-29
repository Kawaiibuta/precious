import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:precious/data_sources/product_repository.dart';
import 'package:precious/presenters/product_presenter.dart';
import 'package:precious/views/admin/product_page_admin.dart';
import 'package:sidebarx/sidebarx.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});
  static const name = "home_page_admin";
  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

final divider = Divider(color: Colors.white.withOpacity(0.3), height: 1);
final _controller = SidebarXController(selectedIndex: 0, extended: true);

final floatingButtonList = [
  {"icon": Icons.add, "name": "add"},
  {"icon": Icons.delete, "name": "delete"},
  {"icon": Icons.edit, "name": "edit"}
];

final drawerItemList = [
  {
    "icon": Icons.home,
    "name": "Home",
  },
  {"icon": Icons.inventory, "name": "Inventory"},
  {
    "icon": Icons.person,
    "name": "User",
  },
  {
    "icon": Icons.receipt,
    "name": "order",
  },
  {"icon": Icons.monitor, "name": "Statistic"}
];

class _HomePageAdminState extends State<HomePageAdmin> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var openList = [
    {"icon": Icons.add, "name": "add"}
  ];
  List<int> itemList = [];
  final productPresenter = ProductPresenter();
  var controller = SidebarXController(selectedIndex: 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: ProductPageAdmin(
          openFloatingButton: (List<int> i) {
            setState(() {
              openList = i.map((e) => floatingButtonList[e]).toList();
            });
          },
        ),
        drawer: SidebarX(
          controller: _controller,
          theme: SidebarXTheme(
            margin: const EdgeInsets.all(10),
            textStyle: const TextStyle(color: Colors.white),
            selectedTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            itemTextPadding: const EdgeInsets.only(left: 30),
            selectedItemTextPadding: const EdgeInsets.only(left: 30),
            selectedItemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white24,
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
              size: 20,
            ),
          ),
          extendedTheme: SidebarXTheme(
            width: MediaQuery.of(context).size.width / 1.6,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            margin: const EdgeInsets.only(right: 10),
          ),
          footerDivider: divider,
          headerBuilder: (context, extended) {
            return SafeArea(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: CachedNetworkImage(
                            imageUrl:
                                "https://cdn2.thecatapi.com/images/_6x-3TiCA.jpg"),
                      ),
                      const Text(
                        "Hello, \nPhap",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          items: drawerItemList
              .map((e) => SidebarXItem(
                    icon: e["icon"] as IconData,
                    label: e['name'] as String,
                  ))
              .toList(),
        ),
        floatingActionButton: Stack(
          children: [
            ...openList.reversed
                .toList()
                .asMap()
                .map((key, value) => MapEntry(
                    key,
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOut,
                      bottom: openList.isNotEmpty && key != 0 ? key * 65 : 0,
                      right: 10.0,
                      child: Container(
                        width: 60,
                        height: 60,
                        child: FloatingActionButton(
                          backgroundColor: Colors.black,
                          onPressed: () {
                            switch (value['name']) {
                              case "add":
                                Navigator.of(context).pushNamed(
                                    "${(drawerItemList[controller.selectedIndex]['name'] as String).toLowerCase()}_form");
                                break;
                              case "delete":
                                _handleDeleteItem(
                                    (drawerItemList[controller.selectedIndex]
                                            ['name'] as String)
                                        .toLowerCase());
                              default:
                            }
                          },
                          child: Icon(
                            value["icon"] as IconData,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )))
                .values
          ],
        ));
  }

  void _handleDeleteItem(String lowerCase) async {
    if (lowerCase == 'inventory') {
      final futureItemList = ProductPresenter.selectedProduct
          .map((e) => ProductRepository.getOne(e));
      final itemList = await Future.wait(futureItemList);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Delete items"),
                    Text("Do you want to delete ${itemList.length} items?"),
                    DataTable(
                        columns: const [
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Id',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'name',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                        rows: itemList
                            .map((e) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(e!.id!.toString())),
                                    DataCell(Text(e.name)),
                                  ],
                                ))
                            .toList()),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Cancel",
                                style:
                                    GoogleFonts.openSans(color: Colors.black),
                              )),
                          OutlinedButton(
                              onPressed: () async {
                                final futureResult = ProductPresenter
                                    .selectedProduct
                                    .map((e) => ProductRepository.delete(e))
                                    .toList();
                                final result = await Future.wait(futureResult);
                                Fluttertoast.showToast(
                                    msg:
                                        "${result.where((element) => element == true).length} have been removed successfully");

                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black)),
                              child: Text("OK",
                                  style: GoogleFonts.openSans(
                                      color: Colors.white))),
                        ])
                  ],
                ),
              )).then((value) => Navigator.of(context).setState(() {}));
    }
  }
}
