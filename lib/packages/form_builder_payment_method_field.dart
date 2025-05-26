import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../configs/color_config.dart';
import 'conditional_builder.dart';

class FormBuilderPaymentMethodField extends StatefulWidget {
  const FormBuilderPaymentMethodField({
    super.key,
  });

  @override
  State<FormBuilderPaymentMethodField> createState() => _FormBuilderPaymentMethodFieldState();
}

class _FormBuilderPaymentMethodFieldState extends State<FormBuilderPaymentMethodField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method'.tr, style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        FormBuilderField(
          name: 'payment_method_code',
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Payment Method is required'.tr),
          ]),
          builder: (FormFieldState<dynamic> field) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Container(
                //   margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                //   height: 80,
                //   width: Get.width,
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: field.value == 'ABAPAY' ? ColorConfig.blue : ColorConfig.lightGrey,
                //     ),
                //     borderRadius: BorderRadius.circular(10),
                //     color: field.value == 'ABAPAY' ? Colors.blueGrey.shade50 : Colors.transparent,
                //   ),
                //   child: ListTile(
                //     selected: field.value == 'ABAPAY',
                //     minLeadingWidth: 60,
                //     leading: const Image(
                //       image: AssetImage('lib/assets/icons/abapay.png'),
                //       width: 60,
                //       height: 60,
                //     ),
                //     title: Text(
                //       'ABA Pay'.tr,
                //       style: Get.textTheme.titleMedium?.copyWith(
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //     subtitle: AutoSizeText(
                //       'Scan to pay with ABA Mobile'.tr,
                //       style: Get.textTheme.bodyMedium,
                //       maxLines: 1,
                //     ),
                //     trailing: ConditionalBuilder(
                //       condition: field.value == 'ABAPAY',
                //       builder: (BuildContext context) {
                //         return Icon(
                //           Icons.radio_button_checked,
                //           color: ColorConfig.blue,
                //         );
                //       },
                //       fallback: (_) => const SizedBox.shrink(),
                //     ),
                //     onTap: () {
                //       field.didChange('ABAPAY');
                //     },
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  height: 80,
                  width: Get.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: field.value == 'KHQR' ? ColorConfig.blue : ColorConfig.lightGrey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: field.value == 'KHQR' ? Colors.blueGrey.shade50 : Colors.transparent,
                  ),
                  child: ListTile(
                    selected: field.value == 'KHQR',
                    minLeadingWidth: 60,
                    leading: const Image(
                      image: AssetImage('lib/assets/icons/khqr.png'),
                      width: 60,
                      height: 60,
                    ),
                    title: Text(
                      'ABA KHQR'.tr,
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: AutoSizeText(
                      'Scan to pay with any banking app'.tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyMedium,
                    ),
                    trailing: ConditionalBuilder(
                      condition: field.value == 'KHQR',
                      builder: (BuildContext context) {
                        return Icon(
                          Icons.radio_button_checked,
                          color: ColorConfig.blue,
                        );
                      },
                      fallback: (_) => const SizedBox.shrink(),
                    ),
                    onTap: () {
                      field.didChange('KHQR');
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  height: 80,
                  width: Get.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: field.value == 'CARDS' ? ColorConfig.blue : ColorConfig.lightGrey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: field.value == 'CARDS' ? Colors.blueGrey.shade50 : Colors.transparent,
                  ),
                  child: ListTile(
                    selected: field.value == 'CARDS',
                    minLeadingWidth: 60,
                    leading: const Image(
                      image: AssetImage('lib/assets/icons/cards.png'),
                      width: 60,
                      height: 60,
                    ),
                    title: Text(
                      'Credit/Debit Card'.tr,
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Image(
                      image: AssetImage('lib/assets/icons/we_accept.png'),
                      height: 18,
                      alignment: Alignment.centerLeft,
                    ),
                    trailing: ConditionalBuilder(
                      condition: field.value == 'CARDS',
                      builder: (BuildContext context) {
                        return Icon(
                          Icons.radio_button_checked,
                          color: ColorConfig.blue,
                        );
                      },
                      fallback: (_) => const SizedBox.shrink(),
                    ),
                    onTap: () {
                      field.didChange('CARDS');
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
