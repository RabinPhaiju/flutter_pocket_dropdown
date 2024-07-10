import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dropdown_overlay.dart';

class PocketDropdownSearch<T> extends StatefulWidget {
  final double? heightConstraints;
  final bool? isSearch;
  final List<T> items;
  final T? selectedItem;
  final Widget child;
  final Function(T,String)? onChanged;
  final Function(T,T)? compareFn;
  final String? id;
  final bool enabled;
  final InputDecoration? searchDecoration;
  final Function(BuildContext context,T item,bool isSelected) itemBuilder;

  const PocketDropdownSearch({
    Key? key,
    required this.child,
    this.items = const [],
    this.selectedItem,
    this.onChanged,
    this.compareFn,
    this.isSearch = false,
    this.id,
    this.enabled = true,
    this.searchDecoration,
    this.heightConstraints,
    required this.itemBuilder,})  :super(key: key);

  @override
  PocketDropdownSearchState<T> createState() => PocketDropdownSearchState<T>();
}

class PocketDropdownSearchState<T> extends State<PocketDropdownSearch<T>>{
  void closePopup() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: InkWell(
          onTap: () {
            _openMenu();
          },
          child : widget.child
      ),
    );
  }

  RelativeRect _position(RenderBox popupButtonObject, RenderBox overlay) {
    //This process calculates the global positions of the bottom-left and
    // bottom-right corners of the button within the context of the overlay.

    //the ancestor parameter refers to the render object
    // in whose coordinate space the transformation should be calculated.

    // Calculate the show-up area for the dropdown using button's size & position based on the overlay used as the coordinate space.
    return RelativeRect.fromSize(
      Rect.fromPoints(
        popupButtonObject.localToGlobal(popupButtonObject.size.bottomLeft(Offset.zero), ancestor: overlay),
        popupButtonObject.localToGlobal(popupButtonObject.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Size(overlay.size.width, overlay.size.height),
    );
  }


  ///openMenu
  Future _openMenu() {
    // Here we get the render object of our physical button, later to get its size & position
    final popupButtonObject = context.findRenderObject() as RenderBox;
    // Get the render object of the overlay used in Navigator / MaterialApp, i.e. screen size reference
    var overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    Offset positionPopUP = popupButtonObject.localToGlobal(Offset.zero);


    return dropdownOverlay<T>(
      context: context,
      verticalPosition:positionPopUP,
      position: (_position)(
        popupButtonObject,
        overlay,
      ),
      id: widget.id,
      isSearch: widget.isSearch!,
      onChanged: widget.onChanged,
      compareFn: widget.compareFn,
      selectedItem: widget.selectedItem,
      items:widget.items,
      searchDecoration: widget.searchDecoration,
      heightConstraints: widget.heightConstraints,
      itemBuilder:widget.itemBuilder,
    );
  }
}
