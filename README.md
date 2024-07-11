<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_pocket_dropdown/flutter_pocket_dropdown.dart';

class PocketDropdown extends StatefulWidget {
  const PocketDropdown({super.key});

  @override
  State<PocketDropdown> createState() => _PocketDropdownState();
}

class _PocketDropdownState extends State<PocketDropdown> {
  String selectedValue = '';

  void onChanged(String value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pocket Dropdown Search'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PocketDropdownSearch<String>(
            isSearch: false,
            id: 'language_dropdown',
            compareFn: (String a,String b) => a == b,
            selectedItem: selectedValue,
            items: ['flutter','react native','kmp'],
            onChanged:(value,_){
              onChanged(value);
            },
            searchDecoration: InputDecoration(
              labelText: 'Search',
              contentPadding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              suffixIcon: const Icon(Icons.search),
            ),
            itemBuilder: (BuildContext context,String language,bool isSelected) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                margin: const EdgeInsets.symmetric(vertical: 2,horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: isSelected ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.background,
                ),
                child: Text(language,style: TextStyle( color: Theme.of(context).colorScheme.onBackground),),
              );
            },
            child: Container(
                padding: const EdgeInsets.only(left: 5,right: 1,top: 6,bottom: 6),
                decoration: BoxDecoration(
                    border: Border.all(color:Theme.of(context).colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(5)
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    selectedValue == ''
                        ? Text('Select',style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),)
                        : Text(selectedValue,style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                    Icon(Icons.arrow_drop_down,color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),)
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}

```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
