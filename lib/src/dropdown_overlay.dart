
import 'package:flutter/material.dart';
import 'dropdown_menu.dart';

Future dropdownOverlay<T>({
  required BuildContext context,
  required RelativeRect position,
  required Offset verticalPosition,
  required List<T> items,
  Function(T,String)? onChanged,
  Function(T,T)? compareFn,
  T? selectedItem,
  String? id,
  required bool isSearch,
  InputDecoration? searchDecoration,
  required Function itemBuilder,
  double? heightConstraints,


}) {
  final NavigatorState navigator = Navigator.of(context);
  return navigator.push(
    _OverlayRoute<T>(
        id:id,
        verticalPosition:verticalPosition,
        position: position,
        items:items,
        onChanged: onChanged,
        compareFn:compareFn,
        selectedItem:selectedItem,
        isSearch: isSearch,
        searchDecoration: searchDecoration,
        itemBuilder: itemBuilder,
        heightConstraints:heightConstraints
    ),
  );
}

// Positioning of the menu on the screen.
class _OverlayRouteLayout extends SingleChildLayoutDelegate {
// Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;
  final BuildContext context;
  final  Offset verticalPosition;

  _OverlayRouteLayout(this.context, this.position,  this.verticalPosition, );

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final parentRenderBox = context.findRenderObject() as RenderBox;
//keyBoardHeight is height of keyboard if showing
    double keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;
    double safeAreaTop = MediaQuery.of(context).padding.top;
    double safeAreaBottom = MediaQuery.of(context).padding.bottom;
    double totalSafeArea = safeAreaTop + safeAreaBottom;
    double maxHeight = constraints.minHeight - keyBoardHeight - totalSafeArea;
    return BoxConstraints.loose(
      Size(parentRenderBox.size.width - position.right - position.left, maxHeight,),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;
    double x = position.left;
    double y = position.top;
    // double appbarHeight = View.of(context).padding.top+15;
    double remainingHeight = size.height - verticalPosition.dy;
    //height from top_position of button to bottom of screenHeight
    //vp is height from top of screen to top_position of button. button is child in showOverlay

// check if we are in the bottom
    if (y + childSize.height > size.height - keyBoardHeight) {
      y = size.height - childSize.height - keyBoardHeight;
    }
    //check if height is enough
    if(size.height<= childSize.height){
      return Offset(x, y);
    }

    if(verticalPosition.dy+childSize.height > size.height){
      y = size.height- childSize.height-remainingHeight;
      if(y + childSize.height > size.height - keyBoardHeight){
        y-=keyBoardHeight;
      }
      // x=verticalPosition.dx;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_OverlayRouteLayout oldDelegate) {
    return true;
  }
}

class _OverlayRoute<T> extends PopupRoute {
  final RelativeRect position;
  final  Offset verticalPosition;
  final List<T> items;
  final Function(T,String)? onChanged;
  final Function(T,T)? compareFn;
  final T? selectedItem;
  final String? id;
  final bool isSearch;
  final InputDecoration? searchDecoration;
  final double? heightConstraints;
  final Function itemBuilder;



  _OverlayRoute({this.id,this.selectedItem,required this.position, required this.verticalPosition, required this.items, this.onChanged,this.compareFn,required this.isSearch, this.searchDecoration,this.heightConstraints,required this.itemBuilder});

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {

    return CustomSingleChildLayout(
      delegate: _OverlayRouteLayout(context, position,verticalPosition),
      child: SizedBox(
        // height: items.length>2 ? 200 : 85,
          child: PocketDropdownMenu(items: items,onChanged: onChanged,compareFn: compareFn,selectedItem: selectedItem,id: id, isSearch: isSearch,searchDecoration: searchDecoration,heightConstraints:heightConstraints, itemBuilder: itemBuilder,)
      ),
    );
  }

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => '';

  @override
  Duration get transitionDuration => Duration.zero;
}

