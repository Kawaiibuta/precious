import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:precious/resources/app_export.dart';

class CartItem extends StatefulWidget {
  const CartItem(
      {Key? key,
      required this.backgroundImage,
      required this.name,
      required this.quantity,
      required this.maxQuantity,
      this.onQuantityChange,
      this.selected = false,
      this.onTap})
      : super(key: key);
  final ImageProvider<Object> backgroundImage;
  final String name;
  final double quantity;
  final double maxQuantity;
  final void Function(double)? onQuantityChange;
  final void Function()? onTap;
  final bool selected;
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap?.call,
      child: Container(
        decoration: BoxDecoration(
            border: widget.selected ? Border.all() : null,
            borderRadius: BorderRadius.circular(13.h)),
        clipBehavior: Clip.antiAlias,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(widget.selected ? 3.0 : 1.0),
          child: Container(
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.backgroundImage,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(children: [
                Positioned(
                  bottom: 8.0,
                  left: 8.0,
                  child: CustomizableCounter(
                    borderColor: Colors.white,
                    incrementIcon: const Icon(Icons.add),
                    decrementIcon: const Icon(Icons.remove),
                    borderRadius: 500,
                    backgroundColor: Colors.white,
                    showButtonText: false,
                    count: widget.quantity,
                    maxCount: widget.maxQuantity,
                    minCount: 1,
                    onCountChange: _handleOnIncrement,
                  ),
                ),
                Positioned(
                  right: 8.0,
                  top: 8.0,
                  child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                      child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 15,
                          ))),
                ),
                Positioned(
                    bottom: 8.0,
                    right: 8.0,
                    child: Text(
                      widget.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.grey),
                    ))
              ])),
        ),
      ),
    );
  }

  void _handleOnIncrement(double c) {
    if (c == widget.maxQuantity) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.limit_buy);
      return;
    }
    widget.onQuantityChange?.call(c);
  }
}
