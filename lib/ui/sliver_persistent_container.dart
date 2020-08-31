import 'package:flutter/widgets.dart';

class SliverPersistantContainer extends StatelessWidget {
  final Widget child;
  final double minExtent;
  final double maxExtent;
  final bool pinned;
  final bool floating;

  const SliverPersistantContainer({
    Key key,
    this.minExtent = 0.0,
    @required this.maxExtent,
    this.pinned = true,
    this.floating = false,
    @required this.child,
  })  : assert(child != null),
        assert(maxExtent != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: SliverPersistantContainerHeaderDelegate(
        child: child,
        minExtent: minExtent,
        maxExtent: maxExtent,
      ),
      floating: floating,
      pinned: pinned,
    );
  }
}

class SliverPersistantContainerHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  @override
  final double maxExtent;
  @override
  final double minExtent;

  SliverPersistantContainerHeaderDelegate({
    @required this.child,
    @required this.maxExtent,
    this.minExtent = 0.0,
  })  : assert(child != null),
        assert(maxExtent != null);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedOverflowBox(
      size: Size.fromHeight((maxExtent - shrinkOffset).clamp(minExtent, maxExtent).toDouble()),
      child: child,
    );
  }

  @override
  bool shouldRebuild(SliverPersistantContainerHeaderDelegate oldDelegate) {
    return child != oldDelegate.child ||
        maxExtent != oldDelegate.maxExtent ||
        minExtent != oldDelegate.minExtent;
  }
}
