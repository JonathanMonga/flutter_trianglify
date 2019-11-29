import 'package:flutter/material.dart';

import 'package:flutter_trianglify/flutter_trianglify.dart';

class TrianglifySample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Material(
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: MySliverAppBar(expandedHeight: 200),
                  pinned: true,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => ListTile(
                      title: Text("Index: $index"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  static const double BASE_SIZE = 320.0;

  final double expandedHeight;

  MySliverAppBar({@required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
        double scaleFactor = MediaQuery.of(context).size.shortestSide / BASE_SIZE;
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Trianglify(
          bleedX: 0,
          bleedY: 10,
          cellSize: 35,
          gridWidth: MediaQuery.of(context).size.width + (200 * scaleFactor),
          gridHeight: 400 * scaleFactor,
          isDrawStroke: true,
          isFillTriangle: true,
          isFillViewCompletely: false,
          isRandomColoring: false,
          generateOnlyColor: false,
          typeGrid: Trianglify.GRID_RECTANGLE,
          variance: 20,
          palette: Palette.getPalette(Palette.BLUES),
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Text(
              "MySliverAppBar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Card(
              elevation: 10,
              child: SizedBox(
                height: expandedHeight,
                width: MediaQuery.of(context).size.width / 2,
                child: FlutterLogo(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
