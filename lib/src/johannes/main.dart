// import 'package:flutter/material.dart';
//
// import 'data/data.dart';
// import 'widget/page_circle_indicator.dart';
// import 'widget/page_entry_widget.dart';

import 'package:pageview_example/src/source.dart';

/// Uncomment to try Johannes' example app separately.

// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key key, this.appTitle = 'PageView'}) : super(key: key);
//   final String appTitle;
//   @override
//   Widget build(BuildContext context) => MaterialApp(
//         title: appTitle,
//         theme: ThemeData(primaryColor: Colors.teal),
//         home: MainPage(appTitle: appTitle),
//       );
// }

class MainPage extends StatefulWidget {
  const MainPage({Key key, this.appTitle}) : super(key: key);
  final String appTitle;

  @override
  _MainPageState createState() => _MainPageState();

  static void setState(VoidCallback fn){
    final state = SetState.of<_MainPageState>();
    state?.setState(fn);
  }
}

class _MainPageState extends SetState<MainPage> {
  //
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.appTitle),
        ),
        body: Stack(
          children: <Widget>[
            PageView.builder(
              onPageChanged: (int index) {
                currentPageNotifier.value = index;
              },
              controller: PageController(
                initialPage: currentPageNotifier.value,
              ),
              itemBuilder: (BuildContext buildContext, int index) =>
                  PageEntryWidget(entry: pages[index]),
              itemCount: pages.length,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: PageCircleIndicator(
                itemCount: pages.length,
                currentPageNotifier: currentPageNotifier,
              ),
            ),
          ],
        ),
      );
}
