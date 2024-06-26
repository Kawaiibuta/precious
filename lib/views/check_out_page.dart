import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:precious/data_sources/order_repository.dart';
import 'package:precious/presenters/check_out_presenter.dart';
import 'package:precious/resources/app_export.dart';
import 'package:precious/models/cart/cart.dart';
import 'package:precious/resources/widgets/custom_elevated_button.dart';
import 'package:precious/resources/widgets/product_card_large.dart';
import 'package:precious/resources/widgets/round_container_box.dart';
import 'package:precious/views/order_success_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CheckOutPage extends StatefulWidget {
  final Cart cart;
  const CheckOutPage(this.cart, {super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage>
    implements CheckOutPageContract {
  bool _isAddressEdit = false;

  final _detailAddressController = TextEditingController();

  final _provinceAddressController = TextEditingController();

  final _countryAddressController = TextEditingController();

  final _detailAddressFocusNode = FocusNode();

  final _provinceFocusNode = FocusNode();

  final _countryFocusNode = FocusNode();

  final _numberFormat = NumberFormat.compactSimpleCurrency(locale: 'vi');

  late CheckOutPresenter _presenter;

  var _currentMethod = PaymentMethod.cash;

  @override
  void initState() {
    super.initState();
    _presenter = CheckOutPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            body: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(16.h),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                AppLocalizations.of(context)!
                                    .checkout_product_list_title,
                                style: Theme.of(context).textTheme.titleLarge),
                            for (var item in widget.cart.items)
                              ProductCardLarge(item.variant),

                            SizedBox(height: 30.v),
                            // DELIVERY ADDRESS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    AppLocalizations.of(context)!
                                        .delivery_address_title,
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                IconButton(
                                    onPressed: () => setState(() {
                                          if (!_isAddressEdit) {
                                            _isAddressEdit = true;
                                            _detailAddressFocusNode
                                                .requestFocus();
                                          } else {
                                            _isAddressEdit = false;
                                          }
                                        }),
                                    icon: Icon(
                                        _isAddressEdit
                                            ? Icons.check
                                            : Icons.edit,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground)),
                              ],
                            ),
                            SizedBox(height: 16.v),
                            RoundContainerBox(
                                hasShadow: true,
                                shadowWidth: 1.h,
                                padding: EdgeInsets.only(
                                    left: 16.h, top: 8.h, bottom: 8.h),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!_isAddressEdit)
                                        Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .country_title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    _countryAddressController
                                                        .text,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium),
                                              ),
                                            ])
                                      else ...[
                                        Text(
                                            AppLocalizations.of(context)!
                                                .country_title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                        TextFormField(
                                          controller: _countryAddressController,
                                          focusNode: _countryFocusNode,
                                          onTap: _countryFocusNode.requestFocus,
                                        )
                                      ],
                                      SizedBox(height: 8.v),
                                      if (!_isAddressEdit)
                                        Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .province_or_city_title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    _provinceAddressController
                                                        .text,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium),
                                              ),
                                            ])
                                      else ...[
                                        Text(
                                            AppLocalizations.of(context)!
                                                .province_or_city_title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                        TextFormField(
                                            controller:
                                                _provinceAddressController,
                                            focusNode: _provinceFocusNode,
                                            onTap:
                                                _provinceFocusNode.requestFocus)
                                      ],
                                      SizedBox(height: 8.v),
                                      if (!_isAddressEdit)
                                        Flex(
                                            direction: Axis.horizontal,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .address_detail_title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    _detailAddressController
                                                        .text,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium),
                                              ),
                                            ])
                                      else ...[
                                        Text(
                                            AppLocalizations.of(context)!
                                                .address_detail_title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                        TextFormField(
                                          controller: _detailAddressController,
                                          focusNode: _detailAddressFocusNode,
                                          onTap: _detailAddressFocusNode
                                              .requestFocus,
                                        )
                                      ],
                                    ])),
                            SizedBox(height: 40.v),
                            // Payment
                            Text(
                              AppLocalizations.of(context)!.payment_title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            RadioListTile(
                                title: Row(
                                  children: [
                                    Image.asset('assets/images/momo.png',
                                        width: 20.h, height: 20.v),
                                    SizedBox(width: 8.v),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .momo_payment_method_title,
                                    ),
                                  ],
                                ),
                                value: PaymentMethod.momo,
                                groupValue: _currentMethod,
                                onChanged: _changePaymentMethod),
                            RadioListTile(
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .direct_payment_method_title,
                                ),
                                value: PaymentMethod.onDelivery,
                                groupValue: _currentMethod,
                                onChanged: _changePaymentMethod)
                          ]),
                    ),
                  ),
                ),
                Container(
                  height: 100.v,
                  padding: EdgeInsets.all(16.h),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        blurRadius: 8.h,
                        blurStyle: BlurStyle.outer),
                  ]),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                AppLocalizations.of(context)!.total_price_title,
                                style: Theme.of(context).textTheme.bodyLarge),
                            Text(_numberFormat.format(getPrice()),
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        CustomElevatedButton(
                            width: 160.h,
                            buttonStyle: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary),
                            text: AppLocalizations.of(context)!
                                .place_order_button_title,
                            buttonTextStyle:
                                Theme.of(context).textTheme.labelLarge,
                            onPressed: _placeOrder),
                      ]),
                )
              ],
            )));
  }

  double getPrice() {
    return widget.cart.items.fold(0, (pValue, e) => pValue + e.price);
  }

  void _placeOrder() {
    if (_currentMethod == PaymentMethod.cash) {
      showSnackBar(AppLocalizations.of(context)!.choose_payment_method_msg);
      return;
    }
    if (_detailAddressController.text.isEmpty ||
        _provinceAddressController.text.isEmpty ||
        _countryAddressController.text.isEmpty) {
      showSnackBar(AppLocalizations.of(context)!.empty_address_msg);
      return;
    }
    var address =
        '${_detailAddressController.text}, ${_provinceAddressController.text}, ${_countryAddressController.text}';
    _presenter.checkout(widget.cart, address, _currentMethod);
  }

  void _changePaymentMethod(PaymentMethod? value) => setState(() {
        _currentMethod = value!;
      });

  @override
  void onGetRedirectLinkFailed(Exception e) {
    if (e is DioException) {
      showSnackBar(AppLocalizations.of(context)!
          .unexpected_error_msg(e.response?.statusMessage ?? 'UNKNOWN'));
    }
    showSnackBar(AppLocalizations.of(context)!.unexpected_error_msg('UNKNOWN'));
  }

  void showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(AppLocalizations.of(context)!.unexpected_error_msg(msg))));
  }

  @override
  void onGetRedirectLinkSuccess(String url) {
    Navigator.of(context).pushNamed(OrderSuccessPage.name);
  }
}
