import 'package:flutter/material.dart';

class PocketDropdownMenu<T> extends StatefulWidget {
  final List<T> items;
  final Function(T,String)? onChanged;
  final Function(T,T)? compareFn;
  final T? selectedItem;
  final String? id;
  final bool isSearch;
  late InputDecoration? searchDecoration;
  late double? heightConstraints;
  final Function itemBuilder;


  PocketDropdownMenu({super.key, required this.items,this.onChanged,this.compareFn, this.id,this.selectedItem, required this.isSearch, this.searchDecoration, required this.itemBuilder, this.heightConstraints});


  @override
  State<PocketDropdownMenu<T>> createState() => _PocketDropdownMenuState();
}

class _PocketDropdownMenuState<T> extends State<PocketDropdownMenu<T>> {
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List searchFilteredItem=[];
  late InputDecoration searchDecoration;
  double heightConstraints = 200;

  @override
  void initState() {
    if(widget.searchDecoration!=null){
      searchDecoration = widget.searchDecoration!;

    }else{
      searchDecoration = InputDecoration(
        labelText: 'Search',
        contentPadding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      );
    }
    setHeightConstraints();
    searchFilteredItem=widget.items;
    super.initState();
  }

  void setHeightConstraints(){
    if(widget.heightConstraints != null){
      heightConstraints = widget.heightConstraints!;
    }
  }

  filter(value){
    setState(() {
      if (value.isEmpty) {
        searchFilteredItem = widget.items;
      } else {
        searchFilteredItem = widget.items.where((item) =>item.toString().toLowerCase().contains(value.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.background),
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).colorScheme.surface
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.isSearch?
            Container(
              margin: const EdgeInsets.only(bottom: 2),
              child: TextField(
                  controller: textController,
                  onChanged: (value){
                    filter(value);
                  },
                  decoration: searchDecoration
              ),
            ):
            const SizedBox(),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: heightConstraints,
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: scrollController,
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: searchFilteredItem.length,
                    itemBuilder: (context, index) {

                      var item = searchFilteredItem[index];
                      return InkWell(
                          onTap: (){
                            widget.onChanged!(searchFilteredItem[index],widget.id ?? '');
                            Navigator.of(context).pop();
                          },
                          child:_itemWidget(item,widget.selectedItem!=null && widget.compareFn != null ? widget.compareFn!(widget.selectedItem!,item) : false));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _itemWidget(T item,bool isSelected) {
    return widget.itemBuilder(
      context,
      item,
      isSelected,
    );
  }
}

