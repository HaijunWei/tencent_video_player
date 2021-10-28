import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Slider extends StatefulWidget {
  const Slider({
    Key? key,
    required this.value,
    this.bufferValue = 0,
    required this.onChanged,
    this.markValues = const [],
    this.height = 5,
    this.needControl = true,
    this.activeColor,
    this.inactiveColor,
    this.controlColor,
    this.onChangeStart,
    this.onChangeEnd,
  }) : super(key: key);

  final double value;
  final double bufferValue;
  final List<double> markValues;
  final double height;
  final bool needControl;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? controlColor;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;

  @override
  _SliderState createState() => _SliderState();
}

const _kProgressDragWidth = 30.0;

class _SliderState extends State<Slider> {
  double _width = 0;
  double _value = 0;
  double _dragDistance = 0;
  double _left = 0;
  double _newValue = 0;

  void _onHorizontalDragStart(DragStartDetails details) {
    _value = widget.value;
    _dragDistance = 0;
    if (widget.onChangeStart != null) widget.onChangeStart!(_value);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _dragDistance += details.delta.dx;
    const w = _kProgressDragWidth * 0.5;
    _left = (_width * _value - w + _dragDistance).clamp(-w, _width + w);
    _newValue = (_left / _width).clamp(0.0, 1.0);
    widget.onChanged(_newValue);
  }

  void _onHorizontalDragEnd() {
    if (widget.onChangeEnd != null) widget.onChangeEnd!(_newValue);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _width = constraints.maxWidth;
        final width = constraints.maxWidth * widget.value;
        final bufferWidth = constraints.maxWidth * widget.bufferValue;
        return SizedBox(
          height: 20,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Container(
                  height: widget.height,
                  decoration: BoxDecoration(
                    color:
                        widget.inactiveColor ?? Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: widget.height,
                  width: bufferWidth,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: widget.height,
                  width: width,
                  decoration: BoxDecoration(
                    color: widget.activeColor ?? Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              for (var e in widget.markValues)
                Positioned(
                  left: constraints.maxWidth * e - 2.5,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              if (widget.needControl)
                Positioned(
                  left: width - _kProgressDragWidth * 0.5,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragStart: _onHorizontalDragStart,
                    onHorizontalDragUpdate: _onHorizontalDragUpdate,
                    onHorizontalDragEnd: (_) => _onHorizontalDragEnd(),
                    onHorizontalDragCancel: () => _onHorizontalDragEnd(),
                    child: Container(
                      height: 20,
                      width: _kProgressDragWidth,
                      alignment: Alignment.center,
                      child: Container(
                        height: widget.height * 2.5,
                        width: widget.height * 1.5,
                        decoration: BoxDecoration(
                          color: widget.controlColor ?? Colors.white,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
