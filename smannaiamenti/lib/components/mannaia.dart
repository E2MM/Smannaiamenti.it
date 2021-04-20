import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Mannaia extends StatefulWidget {
  Mannaia({
    required this.child,
    this.trail = true,
    Color? color,
    double? size,
    this.delay = const Duration(),
    this.curve = Curves.elasticOut,
    Widget? customCursor,
    Color? trailColor,
    double? trailSize,
    Duration? trailDelay,
    Curve? trailCurve,
    double? trailOpacity,
    Widget? trailCustomCursor,
    MouseCursor? nativeCursor,
    Key? key,
  }) : super(key: key) {
    trailDelay ??= delay + const Duration(milliseconds: 300);
    trailCurve ??= curve;

    if (customCursor != null) {
      trailCustomCursor ??= Opacity(
        opacity: trailOpacity ?? 0.3,
        child: Transform.scale(
          scale: trailSize ?? 1.2,
          child: customCursor,
        ),
      );
    } else {
      color ??= Colors.black;
      size ??= 8;

      if (trailCustomCursor == null) {
        trailColor ??= color.withOpacity(0.3);
        trailSize ??= size * 1.5;
      }
    }

    this.trail = trail;
    this.color = color;
    this.size = size;
    this.delay = delay;
    this.curve = curve;
    this.customCursor = customCursor;
    this.trailColor = trailColor;
    this.trailSize = trailSize;
    this.trailDelay = trailDelay;
    this.trailCurve = trailCurve;
    this.trailOpacity = trailOpacity;
    this.trailCustomCursor = trailCustomCursor;
    this.nativeCursor = nativeCursor;
  }

  ///
  /// The child in which fancy cursor takes effect.
  /// All the other parameters are optional.
  ///
  /// **`Required`**
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   child: YourWidget(),
  /// )
  /// ```
  final Widget child;

  /// The color of the cursor.
  ///
  /// *Optional*
  ///
  /// Defaults to `Colors.black`
  ///
  /// **Do not pass this with [customCursor]**
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   color: Colors.pink,
  ///   child: YourWidget(),
  /// )
  /// ```
  Color? color;

  /// The color of the trail.
  ///
  /// *Optional*
  ///
  /// Defaults to `color.withOpacity(0.3)`
  ///
  /// cursor color with 30% opacity
  ///
  /// **Do not pass this with [trailCustomCursor]**
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   trailColor: Colors.pink.withOpacity(0.5),
  ///   child: YourWidget(),
  /// )
  /// ```
  Color? trailColor;

  /// The size of the cursor.
  ///
  /// *Optional*
  ///
  /// Defaults to `8`
  ///
  /// **Do not pass this with [customCursor]**
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   size: 16,
  ///   child: YourWidget(),
  /// )
  /// ```
  double? size;

  /// The size of the cursor.
  ///
  /// *Optional*
  ///
  /// Defaults to `size * 1.5`
  ///
  /// 1.5 times the cursor [size]
  ///
  /// **Do not pass this with [trailCustomCursor]**
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   trailSize: 32,
  ///   child: YourWidget(),
  /// )
  /// ```
  double? trailSize;

  /// Delay between actual cursor and fancy cursor
  ///
  /// *Optional*
  ///
  /// Defaults to `Duration()` - 0ms
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   delay: Duration(milliseconds: 200),
  ///   child: YourWidget(),
  /// )
  /// ```
  Duration delay;

  /// Delay between actual cursor and cursor trail
  ///
  /// *Optional*
  ///
  /// Defaults to `this.delay + Duration(milliseconds: 300)`
  ///
  /// 300ms more than the cursor [delay]
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   delay: Duration(milliseconds: 200),
  ///   child: YourWidget(),
  /// )
  /// ```
  Duration? trailDelay;

  /// Animation curve that the fancy cursor
  /// follows to reach actual cursor position
  ///
  /// *Optional*
  ///
  /// Defaults to `Curves.elasticOut`
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   curve: Curves.easeInOut,
  ///   delay: Duration(seconds: 1),
  ///   child: YourWidget(),
  /// )
  /// ```
  Curve curve;

  /// Animation curve that the trail follows to reach actual cursor position
  ///
  /// *Optional*
  ///
  /// Defaults to `Curves.elasticOut`
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   trailCurve: Curves.easeInOut,
  ///   trailDelay: Duration(seconds: 1),
  ///   child: YourWidget(),
  /// )
  /// ```
  Curve? trailCurve;

  /// Custom cursor widget to replace the default circle
  ///
  /// *Optional*
  ///
  /// **Do not pass this with [color] and [size]**
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   customCursor: Image.asset('assets/cursor.gif'),
  ///   child: YourWidget(),
  /// )
  /// ```
  Widget? customCursor;

  /// Custom cursor widget to replace the default trail
  ///
  /// *Optional*
  ///
  /// Defaults to trail version of [customCursor],
  /// if passed with [customColor]
  ///
  ///
  /// **Do not pass this with [trailColor] and [trailSize]**
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   customCursor: Image.asset('assets/cursorTrail.gif'),
  ///   child: YourWidget(),
  /// )
  /// ```
  Widget? trailCustomCursor;

  /// Wheather trail is enabled.
  ///
  /// *Optional*
  ///
  /// Defaults to `true`.
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   trail: false,
  ///   child: YourWidget(),
  /// )
  /// ```
  bool trail;

  /// Opacity of the custom trail.
  /// Works only with [customCursor].
  /// Irrelavent with [trailCustomCursor].
  ///
  /// *Optional*
  ///
  /// Defaults to `0.3`.
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   trailOpacity: 0.6,
  ///   child: YourWidget(),
  /// )
  /// ```
  double? trailOpacity;

  /// Native cursor on top of the fancy cursor
  ///
  /// *Optional*
  ///
  /// Defaults to `SystemMouseCursors.none`.
  ///
  /// *Example*
  /// ```dart
  /// FancyCursor(
  ///   nativeCursor: SystemMouseCursors.cell,
  ///   child: YourWidget(),
  /// )
  /// ```
  MouseCursor? nativeCursor;

  @override
  _MannaiaState createState() => _MannaiaState();
}

class _MannaiaState extends State<Mannaia> {
  Offset position = Offset.zero;

  @override
  Widget build(BuildContext context) => Material(
        child: MouseRegion(
          cursor: widget.nativeCursor ?? SystemMouseCursors.none,
          onHover: (phe) {
            setState(() => position = phe.position);
          },
          child: Stack(
            children: [
              widget.child,
              if (widget.trail)
                AnimatedPositioned(
                  duration: widget.trailDelay!,
                  curve: widget.trailCurve!,
                  top: position.dy - ((widget.trailSize ?? 0) / 2),
                  left: position.dx - ((widget.trailSize ?? 0) / 2),
                  child: IgnorePointer(
                    child: widget.trailCustomCursor ??
                        Container(
                          decoration: BoxDecoration(
                            color: widget.trailColor,
                            borderRadius:
                                BorderRadius.circular(widget.trailSize! / 2),
                          ),
                          height: widget.trailSize,
                          width: widget.trailSize,
                        ),
                  ),
                ),
              AnimatedPositioned(
                duration: widget.delay,
                curve: widget.curve,
                top: position.dy - (widget.size ?? 0) / 2,
                left: position.dx - (widget.size ?? 0) / 2,
                child: IgnorePointer(
                  child: widget.customCursor ??
                      Container(
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.circular(widget.size! / 2),
                        ),
                        height: widget.size,
                        width: widget.size,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
}
