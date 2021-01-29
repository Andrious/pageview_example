import 'package:pageview_example/src/source.dart';

class PageViewDrawer extends Drawer {
  PageViewDrawer({
    Key key,
    double elevation = 16.0,
    Widget child,
    String semanticLabel,
  })  : child = child ?? _createDrawer(),
        super(
            key: key,
            elevation: elevation,
            child: child,
            semanticLabel: semanticLabel);

  @override
  Widget child;

  static SetState _state;

  static Axis scrollDirection = Axis.horizontal;
  static bool reverse = false;
  static PageController controller;
  static PageController _tempController;
  static VoidCallback _listener;

  static double _initialPage = 0;
  static double _viewportFraction = 1;

  static ScrollPhysics physics = const ClampingScrollPhysics();
  static bool pageSnapping;
  static ValueChanged<int> onPageChanged;
  // No other Delegate to switch out and so this is not used.
  static SliverChildDelegate childrenDelegate;
  static DragStartBehavior dragStartBehavior;
  static bool allowImplicitScrolling;
  static String restorationId;
  static Clip clipBehavior = Clip.hardEdge;

  static IndexedWidgetBuilder itemBuilder;
  static IndexedWidgetBuilder originalBuilder;
  static double _currentPageValue;

  static bool _controller = false;
  static bool _pageSnapping = true;
  static bool _onPageChanged = false;
  static bool _childrenDelegate = false;
  static bool _dragStartBehavior = false;
  static bool _allowImplicitScrolling = false;
  static bool _restorationId = false;
  static bool _itemBuilder = false;

  static Widget _createDrawer() {
    //
    final options = <Widget>[
      RadioButtons<Axis>(
        label: 'Scroll Direction',
        text: const ['Horizontal', 'Vertical'],
        values: const [Axis.horizontal, Axis.vertical],
        initialIndex: scrollDirection,
        func: (v) {
          scrollDirection = v;
          _setupPageView();
        },
      ),
      _switchFunc('Reverse Order', reverse, (v) => reverse = v),
    ];

    /// Can't modify the controller while working transitions.
    if (!_itemBuilder) {
      options
          .add(_switchFunc('Controller', _controller, (v) => _controller = v));
    }

    if (!_itemBuilder && _controller) {
      options.addAll([
        _sliderFunc(
          'Initial Index (Switch tabs for change)',
          _initialPage,
          (v) => _initialPage = v,
          min: 0,
          max: 2,
        ),

        ///Wouldn't be demonstrated properly here.
//        _switchFunc('Keep Alive', _keepPage, (v) => _keepPage = v),
        _sliderFunc('Viewport Fraction', _viewportFraction,
            (v) => _viewportFraction = v,
            min: 0.1, max: 1, divisions: 5),
      ]);
    }

    options.addAll([
      RadioButtons<ScrollPhysics>(
        label: 'Scroll Physics',
        text: const ['Bouncing', 'Clamping'],
        values: const [
          BouncingScrollPhysics(),
          ClampingScrollPhysics(),
        ],
        initialIndex: physics,
        func: (v) {
          physics = v;
          _setupPageView();
        },
      ),
      _switchFunc('Page Snap', _pageSnapping, (v) => _pageSnapping = v),
      _switchFunc('Page Change', _onPageChanged, (v) => _onPageChanged = v),
      _switchFunc('Delegate', _childrenDelegate, (v) => _childrenDelegate = v),
      _switchFunc(
          'Start Behavior', _dragStartBehavior, (v) => _dragStartBehavior = v),
      _switchFunc('Implicit Scrolling', _allowImplicitScrolling,
          (v) => _allowImplicitScrolling = v),
      _switchFunc('Restoration ID', _restorationId, (v) => _restorationId = v),
      RadioButtons<Clip>(
        label: 'Clip Behavior',
        text: const ['hardEdge', 'antiAlias'],
        values: const [
          Clip.hardEdge,
          Clip.antiAlias,
        ],
        initialIndex: clipBehavior,
        func: (v) {
          clipBehavior = v;
          _setupPageView();
        },
      ),
      _switchFunc('Custom Transitions', _itemBuilder, (v) => _itemBuilder = v),
    ]);

    if (_itemBuilder) {
      //
      final itemBuilderGroup = RadioGroup(itemBuilder, (v) {
        // Record is once to prevent stack overflow of course.
        // It's cleared if we tab to the other pageview example.
        itemBuilder = v;
        _setupPageView();
      });

      options.addAll([
        RadioButtons<IndexedWidgetBuilder>(
          text: const ['Transition 1', 'Transition 2'],
          values: const [
            _transition01,
            _transition02,
          ],
          radioGroup: itemBuilderGroup,
        ),
        RadioButtons<IndexedWidgetBuilder>(
          text: const ['Transition 3', 'Transition 4'],
          values: const [
            _transition03,
            _transition04,
          ],
          radioGroup: itemBuilderGroup,
        ),
      ]);
    }

    return ListView(
      children: options,
    );
  }

  // ignore: avoid_positional_boolean_parameters
  static Widget _switchFunc(
          String title, bool value, void Function(bool v) func) =>
      SwitchListTile(
        title: Text(title),
        value: value,
        onChanged: (v) {
          func(v);
          // Set up the page view properties.
          _setupPageView();
        },
      );

  static Widget _sliderFunc(
    String title,
    double value,
    double Function(double v) func, {
    double min = 4.0,
    double max = 16.0,
    int divisions = 2,
    bool round = false,
  }) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Slider(
          value: round ? value.roundToDouble() : value,
          min: min,
          max: max,
          divisions: divisions,
          label: round ? value.round().toString() : value.toString(),
          onChanged: (v) {
            func(v);
            // Set up the page view properties.
            _setupPageView();
          },
        )
      ]);

  // Set up the page view properties.
  static void _setupPageView() {
    //

    if (!_itemBuilder) {
      //
      itemBuilder = null;

      if (_controller) {
//        _tempController?.dispose();

        /// This is a hack! Don't replace the PageController
        /// Merely supply different viewportFraction value
        /// This was only for demonstration purposes.
        _tempController = PageController(
          initialPage: _initialPage.toInt(),
//        keepPage: _keepPage,
          viewportFraction: _viewportFraction,
        );
        // Can't dispose here. It's still being used.
//        controller?.dispose();
        controller = _tempController;
      } else {
        if (_tempController != null) {
 //         _tempController.dispose();
          _tempController = null;
        }

        if (_listener != null) {
          controller.removeListener(_listener);
          controller = null;
          _listener = null;
        }
      }
    } else {

      _currentPageValue = controller?.page;

      if (_listener == null) {
        /// Can't have the Controller setting as well.

        _listener = () {
          _state?.setState(() {
            _currentPageValue = controller.page;
          });
        };
        controller.addListener(_listener);
      }
    }

    pageSnapping = _pageSnapping;

    if (_onPageChanged) {
      onPageChanged = (int value) {};
    } else {
      onPageChanged = null;
    }

    if (_dragStartBehavior) {
      dragStartBehavior = DragStartBehavior.down;
    } else {
      dragStartBehavior = null;
    }

    allowImplicitScrolling = _allowImplicitScrolling;

//    restorationId;

    _state ??= SetState.root;

    _state?.setState(() {});
  }

  static Widget _transition01(BuildContext context, int index) {
    if (index == _currentPageValue.floor()) {
      return Transform(
        transform: Matrix4.identity()..rotateX(_currentPageValue - index),
        child: originalBuilder(context, index),
      );
    } else if (index == _currentPageValue.floor() + 1) {
      return Transform(
        transform: Matrix4.identity()..rotateX(_currentPageValue - index),
        child: originalBuilder(context, index),
      );
    } else {
      return originalBuilder(context, index);
    }
  }

  static Widget _transition02(BuildContext context, int index) {
    if (index == _currentPageValue.floor()) {
      return Transform(
        transform: Matrix4.identity()
          ..rotateY(_currentPageValue - index)
          ..rotateZ(_currentPageValue - index),
        child: originalBuilder(context, index),
      );
    } else if (index == _currentPageValue.floor() + 1) {
      return Transform(
        transform: Matrix4.identity()
          ..rotateY(_currentPageValue - index)
          ..rotateZ(_currentPageValue - index),
        child: originalBuilder(context, index),
      );
    } else {
      return originalBuilder(context, index);
    }
  }

  static Widget _transition03(BuildContext context, int index) {
    if (index == _currentPageValue.floor()) {
      return Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.004)
          ..rotateY(_currentPageValue - index)
          ..rotateZ(_currentPageValue - index),
        child: originalBuilder(context, index),
      );
    } else if (index == _currentPageValue.floor() + 1) {
      return Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.004)
          ..rotateY(_currentPageValue - index)
          ..rotateZ(_currentPageValue - index),
        child: originalBuilder(context, index),
      );
    } else {
      return originalBuilder(context, index);
    }
  }

  static Widget _transition04(BuildContext context, int index) {
    if (index == _currentPageValue.floor()) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(_currentPageValue - index)
          ..rotateY(_currentPageValue - index)
          ..rotateZ(_currentPageValue - index),
        child: originalBuilder(context, index),
      );
    } else if (index == _currentPageValue.floor() + 1) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(_currentPageValue - index)
          ..rotateY(_currentPageValue - index)
          ..rotateZ(_currentPageValue - index),
        child: originalBuilder(context, index),
      );
    } else {
      return originalBuilder(context, index);
    }
  }
}
