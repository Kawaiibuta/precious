import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key, this.onFocus, this.onChange});
  final Function? onFocus;
  final void Function(String)? onChange;
  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint(widget.onFocus.toString());
        if (widget.onFocus != null) widget.onFocus!();
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        // width: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xfff3f4f6)),
        child: Row(
          children: [
            const Icon(Icons.search),
            Expanded(
                child: TextField(
              onChanged: widget.onChange,
              decoration: const InputDecoration.collapsed(
                  hintText: "Search anything here"),
            ))
          ],
        ),
      ),
    );
  }
}
