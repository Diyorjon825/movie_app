// ignore_for_file: non_constant_identifier_names

import 'dart:math';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PaintIndecator extends StatefulWidget {
  double percent, widthLine;
  PaintIndecator({Key? key, required this.percent, required this.widthLine})
      : super(key: key);

  @override
  _PaintIndecatorState createState() => _PaintIndecatorState();
}

class _PaintIndecatorState extends State<PaintIndecator> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PaintCircle(
          BackColor: Colors.black87,
          FullColor: Colors.greenAccent.shade700,
          FulledColor: Colors.greenAccent.shade200.withOpacity(0.3),
          percent: widget.percent / 100,
          widthLine: widget.widthLine,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            (widget.percent != 0) ? '${widget.percent.round()}%' : 'NR',
            style: const TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}

class PaintCircle extends StatefulWidget {
  final Color BackColor;
  final Color FullColor;
  final Color FulledColor;
  final double percent;
  final double widthLine;
  const PaintCircle({
    Key? key,
    required this.percent,
    required this.BackColor,
    required this.FulledColor,
    required this.FullColor,
    required this.widthLine,
  }) : super(key: key);

  @override
  _PainterCircleState createState() => _PainterCircleState();
}

class _PainterCircleState extends State<PaintCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _animation = Tween<double>(begin: 0, end: widget.percent).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutExpo),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (ctx, ch) => CustomPaint(
        painter: PainterWidget(
          _animation.value,
          widget.BackColor,
          widget.FullColor,
          widget.FulledColor,
          widget.widthLine,
        ),
      ),
    );
  }
}

class PainterWidget extends CustomPainter {
  final double widthLine;
  final Color BackColor;
  final Color FullColor;
  final Color FulledColor;
  final double percent;
  PainterWidget(this.percent, this.BackColor, this.FullColor, this.FulledColor,
      this.widthLine);
  @override
  void paint(Canvas canvas, Size size) {
    final backCirclePaint = Paint()..color = BackColor;
    canvas.drawOval(Offset.zero & size, backCirclePaint);

    final lastCirclePaint = Paint();
    lastCirclePaint.color = FulledColor;
    lastCirclePaint.style = PaintingStyle.stroke;
    lastCirclePaint.strokeWidth = widthLine;
    canvas.drawArc(
      Offset(widthLine / 2, widthLine / 2) &
          Size(size.width - widthLine, size.height - widthLine),
      pi * 2 * percent - pi / 2,
      pi * 2 * (1 - percent),
      false,
      lastCirclePaint,
    );

    final fullCirclePaint = Paint();
    fullCirclePaint.color = FullColor;
    fullCirclePaint.style = PaintingStyle.stroke;
    fullCirclePaint.strokeWidth = widthLine;
    fullCirclePaint.strokeCap = StrokeCap.round;
    canvas.drawArc(
      Offset(widthLine / 2, widthLine / 2) &
          Size(size.width - widthLine, size.height - widthLine),
      -pi / 2,
      pi * 2 * percent,
      false,
      fullCirclePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
