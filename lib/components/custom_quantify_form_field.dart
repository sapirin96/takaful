import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';

import '../packages/conditional_builder.dart';
import '../utils/catcher_util.dart';

class CustomQuantityFormField extends StatefulWidget {
  final int value;
  final int? min;
  final int? max;
  final int? start;
  final int? limit;
  final Function(int)? onChanged;
  final bool? showRemove;
  final Function? onRemove;

  const CustomQuantityFormField({
    super.key,
    required this.value,
    this.min,
    this.max,
    this.start = 1,
    this.limit = 6,
    this.onChanged,
    this.showRemove = false,
    this.onRemove,
  });

  @override
  State<CustomQuantityFormField> createState() =>
      _CustomQuantityFormFieldState();
}

class _CustomQuantityFormFieldState extends State<CustomQuantityFormField> {
  final TextEditingController quantityController = TextEditingController();
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    setState(() => quantity = widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: 'quantity',
      initialValue: quantity,
      builder: (FormFieldState<int> field) {
        return SmartSelect<int>.single(
          selectedValue: quantity,
          title: 'Quantity'.tr,
          onChange: (selected) {
            ///
          },
          modalType: S2ModalType.bottomSheet,
          choiceItems: [
            for (var i = (widget.min ?? widget.start!);
                i <= (widget.limit ?? 10);
                i++)
              S2Choice<int>(value: i, title: '$i'),
          ],
          choiceBuilder: (context, state, choice) {
            if (choice.value >= (widget.limit ?? 10)) {
              if (int.parse(choice.value.toString()) == widget.limit) {
                return ListTile(
                  onTap: () async {
                    final result = await Get.dialog<int>(
                      AlertDialog(
                        title: Text('Quantity'.tr),
                        content: TextField(
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'Quantity'.tr,
                          ),
                          controller: quantityController,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text('Cancel'.tr),
                          ),
                          TextButton(
                            onPressed: () {
                              final value =
                                  int.tryParse(quantityController.text.trim());

                              if (value != null) {
                                Get.back(result: value);
                              }
                            },
                            child: Text('Ok'.tr),
                          ),
                        ],
                      ),
                    );
                    if (result != null) {
                      if (widget.max != null && result > widget.max!) {
                        Get.rawSnackbar(
                            message: 'Max quantity is ${widget.max}');
                        return;
                      }

                      setState(() => quantity = result);
                      state.closeModal();
                      field.didChange(result);
                      widget.onChanged?.call(result);
                    }
                  },
                  leading: quantity >= (widget.limit ?? 10)
                      ? const Icon(Icons.radio_button_checked)
                      : const Icon(Icons.radio_button_unchecked),
                  title: Text('Custom Quantity'.tr),
                  trailing: ConditionalBuilder(
                    condition: quantity >= (widget.limit ?? 10),
                    builder: (context) => Text('$quantity'),
                    fallback: (context) => const SizedBox.shrink(),
                  ),
                );
              }

              return const SizedBox();
            }

            return ListTile(
              onTap: () {
                if (widget.max != null && choice.value > widget.max!) {
                  Get.rawSnackbar(message: 'Max quantity is ${widget.max}');
                  return;
                }

                setState(() => quantity = choice.value);
                field.didChange(choice.value);
                state.closeModal();
                widget.onChanged?.call(choice.value);
              },
              leading: choice.selected
                  ? const Icon(Icons.radio_button_checked)
                  : const Icon(Icons.radio_button_unchecked),
              title: Text("${choice.title}"),
            );
          },
          modalActionsBuilder: (context, state) {
            return [
              ConditionalBuilder(
                condition: widget.showRemove == true,
                builder: (_) => TextButton(
                  onPressed: () {
                    widget.onRemove?.call();
                    state.closeModal();
                  },
                  child: Text('Remove'.tr),
                ),
              ),
            ];
          },
          tileBuilder: (context, state) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: TextButton.icon(
                onPressed: () {
                  try {
                    state.showModal();
                  } catch (error, stackTrace) {
                    CatcherUtil.report(error, stackTrace);
                  }
                },
                icon: const Icon(Icons.arrow_drop_down),
                label: Text("$quantity"),
              ),
            );
          },
        );
      },
    );
  }
}
