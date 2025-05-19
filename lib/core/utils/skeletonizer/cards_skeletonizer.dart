import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardsSkeletonizer extends StatelessWidget {
  final int itemCount;
  const CardsSkeletonizer({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: itemCount,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Container(
                    height: 130,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                ),
                const Padding(padding: EdgeInsets.all(6)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 20,
                        width: 180,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(3, (index) {
                          double width;
                          switch (index) {
                            case 0:
                              width = 140;
                              break;
                            case 1:
                              width = 100;
                              break;
                            default:
                              width = 160;
                          }
                          return Padding(
                            padding:
                                EdgeInsets.only(bottom: index == 2 ? 0 : 6),
                            child: Container(
                              height: 14,
                              width: width,
                              color: Colors.grey[300],
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
