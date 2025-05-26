import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/blog/controllers/blog_controller.dart';
import 'package:takaful/components/empty_result_component.dart';

import '../../../../components/cached_network_image_component.dart';
import '../../../../components/primary_card_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/flutter_pagewise.dart';
import '../../../data/models/post_model.dart';
import '../../../data/providers/post_provider.dart';
import 'post_view.dart';

class BlogView extends StatefulWidget {
  const BlogView({super.key});

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  final BlogController controller = Get.find<BlogController>();

  PagewiseLoadController<PostModel>? pagewiseLoadController;

  @override
  void initState() {
    pagewiseLoadController = PagewiseLoadController(
      pageFuture: (pageIndex, params) => PostProvider.paginated(
        page: pageIndex! + 1,
        perPage: AppConfig.pageSize,
      ),
      pageSize: AppConfig.pageSize,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'.tr),
        centerTitle: false,
      ),
      body: SafeArea(
        child: PagewiseListView(
          pageLoadController: pagewiseLoadController,
          itemBuilder: (context, PostModel post, index) {
            return InkWell(
              onTap: () {
                Get.to(() => PostView(post: post));
              },
              child: PrimaryCardComponent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      textDirection: TextDirection.ltr,
                      fit: StackFit.loose,
                      children: [
                        CachedNetworkImageComponent(
                          imageUrl: post.featuredImageUrl,
                          height: 200,
                          width: Get.width,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${post.publishedAt}",
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${post.title}",
                        style: Get.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          noItemsFoundBuilder: (context) {
            return EmptyResultComponent(
              onPressed: () {
                pagewiseLoadController?.reset();
              },
            );
          },
        ),
      ),
    );
  }
}
