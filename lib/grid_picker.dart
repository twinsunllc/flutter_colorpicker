/// Material color picker

library grid_colorpicker;

import 'package:flutter/material.dart';
import 'dart:math' as math;

const List<Color> defaultColors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
];
class GridPicker extends StatefulWidget {
  final List<Color> availableColors;
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final bool enableLabel, showHexInput;

  GridPicker({
    @required this.pickerColor,
    @required this.onColorChanged,
    this.enableLabel: false,
    this.showHexInput = false,
    this.availableColors = defaultColors,
  });

  @override
  State<StatefulWidget> createState() => _GridPickerState();
}

class _GridPickerState extends State<GridPicker> {
  Color _currentColor;
  TextEditingController _hexController = new TextEditingController();

  double _viewWidth, _viewHeight;
  final _crossAxisCount = 5;

  @override
  initState() {
    super.initState();
    _currentColor = widget.pickerColor ?? widget.availableColors[0];
    _viewWidth = _crossAxisCount * 70.0;
    _hexController.text = _currentColor.value.toRadixString(16).toUpperCase().replaceFirst('FF', '');
    _viewHeight = widget.availableColors.length / _crossAxisCount * 70.0;
  }

  Widget _hexEntry() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: new ListTile(
        title: new TextField(
          textAlign: TextAlign.center,
          controller: _hexController,
        ),
        trailing: IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            var _hexValue = int.parse('0x' + _hexController.text);
            _currentColor = new Color(_hexValue).withOpacity(1.0);
            widget.onColorChanged(_currentColor);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;

    Widget _colorsGrid() {
      var keySize = _orientation == Orientation.portrait ? MediaQuery.of(context).size.width - 80.0 : MediaQuery.of(context).size.height - 140.0;
      var actualWidth = math.min(_viewWidth, keySize);
      var actualHeight = math.min(_viewHeight, keySize);
      return Container(
        width: actualWidth,
        height: actualHeight,
        child: GridView.count(
          crossAxisCount: _crossAxisCount,
          scrollDirection: (_orientation == Orientation.portrait) ? Axis.vertical : Axis.horizontal,
          children: []..addAll(
              widget.availableColors.map(
                (Color _color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentColor = _color;
                        widget.onColorChanged(_currentColor);
                        _hexController.text = _currentColor.value.toRadixString(16).toUpperCase().replaceFirst('FF', '');
                      });
                    },
                    child: Container(
                      color: Color(0),
                      child: Align(
                        child: Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            color: _color,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: (_currentColor.value == _color.value)
                                ? [
                                    (_color == Theme.of(context).cardColor)
                                        ? BoxShadow(
                                            color: Colors.grey[300],
                                            blurRadius: 5.0,
                                          )
                                        : BoxShadow(
                                            color: _color,
                                            blurRadius: 5.0,
                                          ),
                                  ]
                                : null,
                            border: (_color == Theme.of(context).cardColor) ? Border.all(color: Colors.grey[300], width: 1.0) : null,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ),
      );
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _colorsGrid(),
          widget.showHexInput ? _hexEntry() : new Container(),
        ],
      ),
    );
  }
}

bool useWhiteForegroundGrid(Color color) {
  return 1.05 / (color.computeLuminance() + 0.05) > 4.5;
}