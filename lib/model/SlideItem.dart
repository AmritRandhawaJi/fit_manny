import 'package:flutter/material.dart';

import 'PageViewData.dart';

class SlideItem extends StatelessWidget {
  final int index;

  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            Image.asset(slideList[index].image,width:  MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2.5),

            Column(
              children: [
                Text(
                  slideList[index].title,
                  style: TextStyle(fontSize: 20, fontFamily: "Ubuntu",color: Colors.black),

                ),
                SizedBox(height: 20,),
                Text(slideList[index].description,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Ubuntu",
                        color: Colors.black54,),
                    textAlign: TextAlign.center)
              ],
            ),

          ],
        );
  }
}
