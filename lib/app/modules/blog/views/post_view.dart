import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../components/cached_network_image_component.dart';
import '../../../../configs/app_config.dart';
import '../../../data/models/post_model.dart';

class PostView extends StatefulWidget {
  final PostModel post;

  const PostView({super.key, required this.post});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.post.title}'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            CachedNetworkImageComponent(
              imageUrl: widget.post.featuredImageUrl,
              height: 200,
              width: double.infinity,
            ),
            Container(
              padding: const EdgeInsets.all(AppConfig.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.post.publishedAt}',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.post.title}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  HtmlWidget('${widget.post.content}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
