import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: 10, // Number of total items
      itemBuilder: (context, index) {
        return ListView.builder(
          physics: PageScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 10, // Number of elements to show in one scroll
          itemBuilder: (context, subIndex) {
            int itemIndex = index * 3 + subIndex; // Calculate actual item index
            if (itemIndex >= 100) return null; // Return null if out of range
            return Container(
              width: 100, // Adjust width as needed
              margin: EdgeInsets.all(8),
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text(
                'Item $itemIndex',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        );
      },
    );
  }
}