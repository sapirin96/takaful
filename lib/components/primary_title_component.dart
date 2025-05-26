import 'package:flutter/material.dart';

class PrimaryTitleComponent extends StatelessWidget {
  final String title;
  final String subtitle;
  final VerticalDirection direction;
  const PrimaryTitleComponent({
    super.key,
    required this.title,
    required this.subtitle,
    this.direction = VerticalDirection.down,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      verticalDirection: direction,
      children: [
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
        ),
      ],
    );
  }
}
