import 'dart:io';
import 'package:fit_manny/model/PageViewData.dart';
import 'package:fit_manny/model/SlideItem.dart';
import 'package:fit_manny/screens/decision.dart';
import 'package:fit_manny/widgets/SlideDots.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GettingStartedScreen extends StatefulWidget {
  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  static const backColor = <int>[0xffbbffa6, 0xffffc9c9, 0xffffffff];
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(backColor[_currentPage]),
                  body: SafeArea(
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          onPageChanged: _onPageChanged,
                          itemCount: slideList.length,
                          itemBuilder: (ctx, i) => SlideItem(i),
                        ),
                      ],
                    ),
                  ),
                  bottomSheet: _currentPage != slideList.length - 1
                      ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                _pageController.animateToPage(
                                    _currentPage - 1,
                                    duration: Duration(milliseconds: 250),
                                    curve: Curves.easeIn);
                              },
                              child: Icon(Icons.arrow_back_ios,color: Colors.black,),
                          ),
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                for (int i = 0; i < slideList.length; i++)
                                  if (i == _currentPage)
                                    SlideDots(true)
                                  else
                                    SlideDots(false)
                              ],
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                _pageController.animateToPage(
                                    _currentPage + 1,
                                    duration: Duration(milliseconds: 250),
                                    curve: Curves.easeIn);
                              },
                              child: Row(
                                children: [

                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  )
                      : MaterialButton(
                    onPressed: () async {
                        final data = await SharedPreferences.getInstance();
                        data.setInt("userState", 1);
                        if (Platform.isIOS) {
                          Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => Decision(),));
                        }
                        else if (Platform.isAndroid) {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Decision(),));
                        }
                    },
                    child: Text(
                      "Start",
                      style:
                      TextStyle(color: Colors.white, fontSize:  16),
                    ),
                    height: Platform.isIOS ? 70.0 : 50,
                    minWidth: MediaQuery.of(context).size.width,
                    color: Colors.teal,
                  )),
    );
  }
}