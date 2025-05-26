import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../packages/conditional_builder.dart';

class CachedNetworkImageComponent extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  final double? circular;
  final Color? color;
  final String placeholderImage;

  const CachedNetworkImageComponent({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.boxFit,
    this.circular = 6,
    this.color,
    this.placeholderImage = 'lib/assets/images/placeholder.png',
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(circular ?? 0),
      child: SizedBox(
        height: height ?? double.infinity,
        width: width ?? double.infinity,
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: ConditionalBuilder(
            condition: imageUrl != null,
            builder: (_) => CachedNetworkImage(
              imageUrl: imageUrl!,
              height: height ?? double.infinity,
              width: width ?? double.infinity,
              useOldImageOnUrlChange: true,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(circular ?? 0),
                  border: Border.all(color: color ?? Colors.transparent),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: boxFit ?? BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => ClipRRect(
                borderRadius: BorderRadius.circular(circular ?? 0),
                child: Image(
                  image: AssetImage(placeholderImage),
                  fit: boxFit ?? BoxFit.cover,
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                'lib/assets/images/placeholder.png',
                fit: BoxFit.cover,
              ),
              // errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            fallback: (_) => ClipRRect(
              borderRadius: BorderRadius.circular(circular ?? 0),
              child: Image(
                image: AssetImage(placeholderImage),
                fit: boxFit ?? BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
