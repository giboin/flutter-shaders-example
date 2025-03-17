import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ScrollAwareBuilder extends StatefulWidget {
  const ScrollAwareBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, double scrollFraction) builder;

  @override
  State<ScrollAwareBuilder> createState() => _ScrollAwareBuilderState();
}

class _ScrollAwareBuilderState extends State<ScrollAwareBuilder> {
  double _centerOfTheScreenInRelationToMe = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getScrollPos();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _onScrollPosChanged();
    });
  }

  void _getScrollPos() {
    Scrollable.of(context).position.addListener(_onScrollPosChanged);
  }

  void _onScrollPosChanged() {
    final scrollable = Scrollable.of(context);
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final myRenderBox = context.findRenderObject() as RenderBox;

    final offset =
        myRenderBox.localToGlobal(Offset.zero, ancestor: scrollableBox).dy;

    final viewportDimension = scrollable.position.viewportDimension / 2;
    final centerViewportOffset = viewportDimension - offset;

    setState(() {
      _centerOfTheScreenInRelationToMe =
          centerViewportOffset / myRenderBox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _centerOfTheScreenInRelationToMe);
  }
}
