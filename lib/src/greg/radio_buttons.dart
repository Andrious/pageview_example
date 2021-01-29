import 'package:pageview_example/src/source.dart';

class RadioButtons<T> extends StatelessWidget {
  RadioButtons({
    Key key,
    String label,
    List<String> text,
    @required List<T> values,
    dynamic initialIndex,
    this.radioGroup,
    void Function(T v) func,
    TextStyle style,
    MainAxisAlignment mainAxisAlignment,
    this.crossAxisAlignment,
  })  : assert(values.isNotEmpty,
            'RadioButtons Widget: List<T> values cannot be empty!'),
        assert((radioGroup == null && func != null) || radioGroup?.func != null,
            'RadioButtons Widget: Must provide a function!'),
        super(key: key) {
    T defaultValue;

    if (initialIndex != null) {
      if (initialIndex is int && initialIndex < values.length) {
        defaultValue = values[initialIndex];
      } else if (initialIndex is T && values.contains(initialIndex)) {
        defaultValue = initialIndex;
      }
    }

    final radioGroup = this.radioGroup ?? RadioGroup<T>(defaultValue, func);

    if (this.radioGroup != null && func != null) {
      radioGroup.func = func;
    }

    if (label != null) {
      radioButtons.add(Text(
        label,
        style: style,
      ));
    }
    // # of items per row.
    final radioRow = <Widget>[];

    for (int i = 0; i < values.length; i++) {
      if (i < text.length) {
        radioRow.add(Text(text[i]));
      } else {
        radioRow.add(const Text(''));
      }

      radioRow.add(Radio(
        value: values[i],
        groupValue: radioGroup.value,
        onChanged: (v) => radioGroup.onChanged<T>(v),
      ));
    }

    radioButtons.add(Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
      children: radioRow,
    ));
  }
  final radioButtons = <Widget>[];
  final CrossAxisAlignment crossAxisAlignment;
  final RadioGroup<T> radioGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: radioButtons,
    );
  }
}

class RadioGroup<E> {
  RadioGroup(this.value, this.func);
  E value;
  void Function(E v) func;

  void onChanged<T>(T v) {
    if (v is E) {
      // Important to assign before func.
      value = v;
      if (func != null) {
        func(v);
      }
    }
  }
}
