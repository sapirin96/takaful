import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:takaful/packages/loading_overlay.dart';

import '../../../../components/form_input_decoration.dart';
import '../../../../components/primary_button_component.dart';
import '../../../../configs/app_config.dart';
import '../../../data/models/zakat_model.dart';
import '../../../data/providers/zakat_provider.dart';

class CreateZakatView extends StatefulWidget {
  const CreateZakatView({super.key});

  @override
  State<CreateZakatView> createState() => _CreateZakatViewState();
}

class _CreateZakatViewState extends State<CreateZakatView> {
  double _zakat = 0;
  double _nisab = 0;
  double _asset = 0;
  double _gold = 0;
  double _silver = 0;
  double _cashOnHand = 0;
  double _cashInBank = 0;
  double _receivable = 0;
  double _payable = 0;
  double _investment = 0;
  double _stock = 0;

  bool _isLoading = false;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _nisabFocusNode = FocusNode();
  final FocusNode _goldFocusNode = FocusNode();
  final FocusNode _silverFocusNode = FocusNode();
  final FocusNode _cashOnHandFocusNode = FocusNode();
  final FocusNode _cashInBankFocusNode = FocusNode();
  final FocusNode _receivableFocusNode = FocusNode();
  final FocusNode _payableFocusNode = FocusNode();
  final FocusNode _investmentFocusNode = FocusNode();
  final FocusNode _stockFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Zakat Calculator'.tr),
          centerTitle: false,
        ),
        body: SafeArea(
          child: FormBuilder(
            key: _formKey,
            child: KeyboardActions(
              tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
              config: KeyboardActionsConfig(
                keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                keyboardBarColor: Colors.grey[200],
                defaultDoneWidget: Text(
                  'Done'.tr,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
                actions: [
                  KeyboardActionsItem(
                    focusNode: _nisabFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _goldFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _silverFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _cashOnHandFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _cashInBankFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _investmentFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _stockFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _receivableFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _payableFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                ],
              ),
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Asset'.tr,
                                  style: Get.textTheme.titleMedium,
                                ),
                                Text(
                                  "\$${_asset.toStringAsFixed(2)}",
                                  style: Get.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Zakat'.tr,
                                  style: Get.textTheme.titleMedium,
                                ),
                                Text(
                                  "\$${_zakat.toStringAsFixed(2)}",
                                  style: Get.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          decoration: const BoxDecoration(
                            color: Colors.deepPurpleAccent,
                          ),
                          child: Text(
                            'Nisab'.tr,
                            style: Get.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 15),
                          child: FormBuilderTextField(
                            name: 'nisab',
                            initialValue: "$_nisab",
                            decoration: formInputDecoration().copyWith(
                              label: Text('Nisab'.tr),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            focusNode: _nisabFocusNode,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: 'This field is required'.tr),
                              FormBuilderValidators.numeric(),
                              FormBuilderValidators.min(0),
                            ]),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                _nisab = double.tryParse(value) ?? 0;
                              });
                              _calculate();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                          ),
                          child: Text(
                            'Jewelry'.tr,
                            style: Get.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'gold',
                                  initialValue: "$_gold",
                                  decoration: formInputDecoration().copyWith(
                                    label: Text('Gold'.tr),
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  focusNode: _goldFocusNode,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        errorText: 'This field is required'.tr),
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.min(0),
                                  ]),
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setState(() {
                                      _gold = double.tryParse(value) ?? 0;
                                    });
                                    _calculate();
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'silver',
                                  initialValue: "$_silver",
                                  decoration: formInputDecoration().copyWith(
                                    label: Text('Silver'.tr),
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  focusNode: _silverFocusNode,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        errorText: 'This field is required'.tr),
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.min(0),
                                  ]),
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setState(() {
                                      _silver = double.tryParse(value) ?? 0;
                                    });
                                    _calculate();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                          ),
                          child: Text(
                            'Cash'.tr,
                            style: Get.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'cash_on_hand',
                                  initialValue: "$_cashOnHand",
                                  decoration: formInputDecoration().copyWith(
                                    label: Text('Cash on hand'.tr),
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  focusNode: _cashOnHandFocusNode,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        errorText: 'This field is required'.tr),
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.min(0),
                                  ]),
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setState(() {
                                      _cashOnHand = double.tryParse(value) ?? 0;
                                    });
                                    _calculate();
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'cash_in_bank',
                                  initialValue: "$_cashInBank",
                                  decoration: formInputDecoration().copyWith(
                                    label: Text('Cash in bank'.tr),
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  focusNode: _cashInBankFocusNode,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        errorText: 'This field is required'.tr),
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.min(0),
                                  ]),
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setState(() {
                                      _cashInBank = double.tryParse(value) ?? 0;
                                    });
                                    _calculate();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Text(
                            'Trade'.tr,
                            style: Get.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'investment',
                                  initialValue: "$_investment",
                                  decoration: formInputDecoration().copyWith(
                                    label: Text('Investment'.tr),
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  focusNode: _investmentFocusNode,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        errorText: 'This field is required'.tr),
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.min(0),
                                  ]),
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setState(() {
                                      _investment = double.tryParse(value) ?? 0;
                                    });
                                    _calculate();
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'stock',
                                  initialValue: "$_stock",
                                  decoration: formInputDecoration().copyWith(
                                    label: Text('Value of stock'.tr),
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  focusNode: _stockFocusNode,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        errorText: 'This field is required'.tr),
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.min(0),
                                  ]),
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setState(() {
                                      _stock = double.tryParse(value) ?? 0;
                                    });
                                    _calculate();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                          ),
                          child: Text(
                            'Loans'.tr,
                            style: Get.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'receivable',
                                  initialValue: "$_receivable",
                                  decoration: formInputDecoration().copyWith(
                                    label: Text('Loan given'.tr),
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  focusNode: _receivableFocusNode,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        errorText: 'This field is required'.tr),
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.min(0),
                                  ]),
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setState(() {
                                      _receivable = double.tryParse(value) ?? 0;
                                    });
                                    _calculate();
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'payable',
                                  initialValue: "$_payable",
                                  decoration: formInputDecoration().copyWith(
                                    label: Text('Loan taken'.tr),
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  focusNode: _payableFocusNode,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        errorText: 'This field is required'.tr),
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.min(0),
                                  ]),
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setState(() {
                                      _payable = double.tryParse(value) ?? 0;
                                    });
                                    _calculate();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(AppConfig.padding),
            child: SafeArea(
              child: PrimaryButtonComponent(
                height: 50,
                onPressed: () async {
                  try {
                    if (_formKey.currentState!.saveAndValidate()) {
                      setState(() {
                        _isLoading = true;
                      });

                      Map<String, dynamic> data = {
                        'asset': _asset,
                        'zakat': _zakat,
                        ..._formKey.currentState!.value,
                      };

                      ZakatModel? zakat = await ZakatProvider.store(
                        data,
                      );

                      if (zakat?.uuid != null) {
                        Get.back(result: true);
                      }
                    }
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: Text(
                  'Save'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _calculate() {
    double asset = _gold +
        _silver +
        _cashOnHand +
        _cashInBank +
        _investment +
        _stock +
        _receivable -
        _payable;

    double zakat = 0;

    if (asset > 0 && asset > _nisab) {
      zakat = asset / 40;
    } else {
      zakat = 0;
    }

    setState(() {
      _asset = asset;
      _zakat = zakat;
    });
  }
}
