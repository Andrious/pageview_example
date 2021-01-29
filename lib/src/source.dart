
/// A neat tip. Dart allows you to export the very Flutter framework.
export 'package:flutter/material.dart' hide PageView;

/// Neat tip. Export only a specific class.
export 'package:flutter/gestures.dart' show DragStartBehavior;

/// To call the setState() function of a particular State object.
export 'package:set_state/set_state.dart';

/// Access to my own code.
export 'package:pageview_example/src/greg/source.dart';

/// In turn, exports all of Johannes PageView example code.
export 'package:pageview_example/src/johannes/source.dart';

/// Access to all of Tensor's PageView example code.
export 'package:pageview_example/src/tensor/main.dart' hide MyApp;