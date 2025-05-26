import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';

class ListViewSkeletonComponent extends StatelessWidget {
  const ListViewSkeletonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: ListView(
        children: [
          for (var i = 0; i < 10; i++)
            SkeletonItem(
              child: ListTile(
                leading: const SkeletonAvatar(),
                title: SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: 1,
                    spacing: 6,
                    lineStyle: SkeletonLineStyle(
                      randomLength: true,
                      height: 10,
                      borderRadius: BorderRadius.circular(8),
                      minLength: MediaQuery.of(context).size.width / 2,
                      maxLength: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
                subtitle: SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: 2,
                    spacing: 6,
                    lineStyle: SkeletonLineStyle(
                      randomLength: true,
                      height: 10,
                      borderRadius: BorderRadius.circular(8),
                      minLength: MediaQuery.of(context).size.width / 2,
                      maxLength: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
