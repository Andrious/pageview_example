/// The one 'source code' file necessary for this example app.
import 'package:pageview_example/src/source.dart';

/// The class, PageView, is hidden the import file, source.dart
import 'package:flutter/material.dart' as m;

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  State createState() => _MyAppState();
}

class _MyAppState extends SetState<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Rebuild the currently viewing tab
    MainPage.setState(() {});
    DisplayPage.setState(() {});
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Builder(
          builder: (BuildContext context) => Scaffold(
            drawer: PageViewDrawer(),
            appBar: AppBar(
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: TabBar(
                  indicatorColor: Colors.yellow,
                  tabs: [
                    Text('Johannes'),
                    Text('Tensor'),
                  ],
                ),
              ),
            ),
            body: const TabBarView(
              children: [
                MainPage(appTitle: 'PageView Example'),
                DisplayPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Override the Widget itself to impose outside settings.
class PageView extends m.PageView {
  PageView({
    Key key,
    this.scrollDirection,
    this.reverse,
    this.controller,
    this.physics,
    this.pageSnapping,
    this.onPageChanged,
    this.children = const <Widget>[],
    this.dragStartBehavior,
    this.allowImplicitScrolling,
    this.restorationId,
    this.clipBehavior,
  }) : super(key: key) {
    _setPageView();
  }

  PageView.builder({
    Key key,
    this.scrollDirection,
    this.reverse,
    this.controller,
    this.physics,
    this.pageSnapping,
    this.onPageChanged,
    @required this.itemBuilder,
    this.itemCount,
    this.dragStartBehavior,
    this.allowImplicitScrolling,
    this.restorationId,
    this.clipBehavior,
  }) : super(key: key) {
    _setPageView();
  }

  IndexedWidgetBuilder itemBuilder;
  int itemCount;
  List<Widget> children;

  @override
  Axis scrollDirection;
  @override
  bool reverse;
  @override
  PageController controller;
  @override
  ScrollPhysics physics;
  @override
  bool pageSnapping;
  @override
  ValueChanged<int> onPageChanged;
  @override
  SliverChildDelegate childrenDelegate;
  @override
  DragStartBehavior dragStartBehavior;
  @override
  bool allowImplicitScrolling;
  @override
  String restorationId;
  @override
  Clip clipBehavior;

  // Called in constructor.
  // Sets Page View properties.
  // Switches out with any available static fields from the class, PageViewDrawer.
  void _setPageView() {
    //
    scrollDirection =
        PageViewDrawer.scrollDirection ?? scrollDirection ?? Axis.horizontal;

    reverse = PageViewDrawer.reverse ?? reverse ?? false;

    controller = PageViewDrawer.controller ?? controller;

    PageViewDrawer.controller = controller;

    physics = PageViewDrawer.physics ?? physics;

    pageSnapping = PageViewDrawer.pageSnapping ?? pageSnapping ?? true;

    dragStartBehavior = PageViewDrawer.dragStartBehavior ??
        dragStartBehavior ??
        DragStartBehavior.start;

    allowImplicitScrolling = PageViewDrawer.allowImplicitScrolling ??
        allowImplicitScrolling ??
        false;

    clipBehavior =
        PageViewDrawer.clipBehavior ?? clipBehavior ?? Clip.hardEdge;

    // Record the current builder.
    PageViewDrawer.originalBuilder = itemBuilder;

    //
    itemBuilder = PageViewDrawer.itemBuilder ?? itemBuilder;

    /// If using PageView.builder
    if (children == null) {
      childrenDelegate = PageViewDrawer.childrenDelegate ??
          SliverChildBuilderDelegate(itemBuilder, childCount: itemCount);
    } else {
      childrenDelegate =
          PageViewDrawer.childrenDelegate ?? SliverChildListDelegate(children);
    }
  }
}
