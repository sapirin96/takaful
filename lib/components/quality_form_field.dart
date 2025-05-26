import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class QuantityFormField extends StatelessWidget {
  final int value;
  final int min;
  final int max;

  const QuantityFormField({
    super.key,
    this.value = 1,
    this.min = 1,
    this.max = 0,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: 'quantity',
      initialValue: value,
      builder: (FormFieldState<dynamic> field) {
        return SizedBox(
          width: 130,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                child: ButtonTheme(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: IconButton(
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      if (field.value > min) field.didChange(field.value - 1);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Text(
                  "${field.value}",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: ButtonTheme(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (max == 0 || field.value < max) {
                        field.didChange(field.value + 1);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
