import 'dart:async';

import 'package:flutter/material.dart';

import '../model/page_entry.dart';

class PageEntryWidget extends StatefulWidget {
  const PageEntryWidget({Key key, this.entry}) : super(key: key);
  final PageEntry entry;

  @override
  _PageEntryWidgetState createState() => _PageEntryWidgetState();
}

class _PageEntryWidgetState extends State<PageEntryWidget> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollToEnd(milliseconds: 1000);
  }

  @override
  Widget build(BuildContext context) => OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        scrollToEnd(milliseconds: 100);

        return Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(
            controller: controller,
            children: <Widget>[
              Image.asset(widget.entry.image, fit: BoxFit.cover),
              const SizedBox(height: 8),
              Text(widget.entry.title,
                  style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 8),
              Text(widget.entry.description,
                  style: Theme.of(context).textTheme.bodyText2),
            ],
          ),
        );
      });

  void scrollToEnd({int milliseconds}) {
    Timer(
      Duration(milliseconds: milliseconds),
      () {
        if (!controller.hasClients) return;
        controller.jumpTo(controller.position.maxScrollExtent);
      },
    );
  }
}
