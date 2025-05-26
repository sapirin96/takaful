import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../../components/primary_button_component.dart';
import '../../../../../components/primary_card_component.dart';
import '../../../../../configs/app_config.dart';
import '../../../../packages/conditional_builder.dart';
import '../../../../packages/loading_overlay.dart';
import '../../../data/models/admin/user_model.dart';
import '../../../data/providers/admin/user_provider.dart';
import '../../../data/providers/data_provider.dart';

class EditUserView extends StatefulWidget {
  final UserModel user;

  const EditUserView({super.key, required this.user});

  @override
  State<EditUserView> createState() => _EditUserViewState();
}

class _EditUserViewState extends State<EditUserView>
    with AutomaticKeepAliveClientMixin<EditUserView> {
  final _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  Future<List<Map<String, dynamic>>>? rolesFuture;

  bool _isLoading = false;
  bool _editPassword = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    rolesFuture = DataProvider.roles();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit User'.tr),
        ),
        body: SafeArea(
          child: FormBuilder(
            key: _formKey,
            initialValue: {
              'name': widget.user.name,
              'email': widget.user.email,
              'role': widget.user.role,
              'role_id': widget.user.roleId,
              'active': widget.user.active,
            },
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
                    focusNode: _nameFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _emailFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _passwordFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppConfig.padding),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PrimaryCardComponent(
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              name: 'name',
                              decoration: InputDecoration(
                                labelText: 'Name'.tr,
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'This field is required'.tr),
                              ]),
                              focusNode: _nameFocusNode,
                            ),
                            FormBuilderTextField(
                              name: 'email',
                              decoration: InputDecoration(
                                labelText: 'Email'.tr,
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'This field is required'.tr),
                                FormBuilderValidators.email(),
                              ]),
                              focusNode: _emailFocusNode,
                            ),
                            ConditionalBuilder(
                              condition: widget.user.role?.toLowerCase() !=
                                  'administrator',
                              builder: (_) =>
                                  FutureBuilder<List<Map<String, dynamic>>>(
                                future: rolesFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return FormBuilderDropdown(
                                      name: 'role_id',
                                      decoration: InputDecoration(
                                        labelText: 'Role'.tr,
                                      ),
                                      items: snapshot.data!.map((role) {
                                        return DropdownMenuItem(
                                          value: role['id'],
                                          child: Text(
                                              "${'${role["name"]}'.capitalizeFirst}"),
                                        );
                                      }).toList(),
                                    );
                                  }

                                  return Container(
                                    height: 40,
                                    width: Get.width,
                                    margin: const EdgeInsets.only(top: 10),
                                    child: SkeletonAvatar(
                                      style: SkeletonAvatarStyle(
                                        width: double.infinity,
                                        height: 40,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            FormBuilderSwitch(
                              name: 'active',
                              title: Text('Active'.tr),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Switch.adaptive(
                                  value: _editPassword,
                                  onChanged: (value) {
                                    setState(() {
                                      _editPassword = value;
                                    });
                                  },
                                ),
                                Text('Edit Password'.tr),
                              ],
                            ),
                            ConditionalBuilder(
                              condition: _editPassword,
                              builder: (_) => FormBuilderTextField(
                                name: 'password',
                                decoration: InputDecoration(
                                  labelText: 'Password'.tr,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                ),
                                validator: _editPassword == true
                                    ? FormBuilderValidators.compose([
                                        FormBuilderValidators.required(
                                            errorText:
                                                'This field is required'.tr),
                                        FormBuilderValidators.minLength(8,
                                            errorText:
                                                'Password must be at least 8 characters'
                                                    .tr),
                                      ])
                                    : null,
                                obscureText: _obscureText,
                                focusNode: _passwordFocusNode,
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
                        ..._formKey.currentState!.value
                      };

                      UserModel? user = await UserProvider.update(
                        widget.user.uuid!,
                        data,
                      );

                      if (user?.uuid != null) {
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

  @override
  bool get wantKeepAlive => true;
}
