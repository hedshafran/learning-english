import 'dart:math';

import 'package:flutter/material.dart';
import 'package:noam_learns_english/models/word.dart';

class FlippingCard extends StatefulWidget {
  const FlippingCard({
    super.key,
    required this.currentWord,
  });

  final Word? currentWord;

  @override
  State<FlippingCard> createState() => _FlippingCardState();
}

class _FlippingCardState extends State<FlippingCard> {
  late bool _showFrontSide;

  @override
  void initState() {
    super.initState();
    _showFrontSide = true;
  }

  @override
  void didUpdateWidget(covariant FlippingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _showFrontSide = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(const Size.square(250)),
      child: _buildFlipAnimation(),
    );
  }

  void _switchCard() {
    setState(() {
      _showFrontSide = !_showFrontSide;
    });
  }

  Color getCardColor() {
    return widget.currentWord!.color == 'green'
        ? Colors.green.shade100
        : widget.currentWord!.color == 'yellow'
            ? Colors.yellow.shade100
            : widget.currentWord!.color == 'red'
                ? Colors.red.shade100
                : Colors.white;
  }

  Widget _buildFlipAnimation() {
    return GestureDetector(
      onTap: _switchCard,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeOutBack,
        child: _showFrontSide ? _buildFront() : _buildBack(),
      ),
    );
  }

  Widget __buildLayout({required Key key, required String faceName}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        color: getCardColor(),
      ),
      child: Center(
        child: Text(faceName, style: const TextStyle(fontSize: 40)),
      ),
    );
  }

  Widget _buildFront() {
    return __buildLayout(
      key: const ValueKey(true),
      faceName: widget.currentWord!.english,
    );
  }

  Widget _buildBack() {
    return __buildLayout(
      key: const ValueKey(false),
      faceName: widget.currentWord!.hebrew,
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget?.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }
}
