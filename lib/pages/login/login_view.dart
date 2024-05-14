import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';

import 'login_logic.dart';

class LoginPage extends StatelessWidget {
  final logic = Get.find<LoginLogic>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // color: Styles.c_F8F9FA,
      child: TouchCloseSoftKeyboard(
        isGradientBg: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              88.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StrRes.welcome.toText
                          ..style = Styles.ts_0C1C33_20sp_semibold,
                        29.verticalSpace,
                        // _buildItemGroupView(
                        //   children: [
                        //     _buildItemView(
                        //       label: StrRes.languageSetup,
                        //       showRightArrow: true,
                        //       isLastItem: true,
                        //     ),
                        //     Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
                        //     _buildItemView(
                        //       label: StrRes.phoneNumber,
                        //       showRightArrow: true,
                        //       isLastItem: true,
                        //     ),
                        //     Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w)
                        //     ,
                        //     _buildItemView(
                        //       label: StrRes.password,
                        //       showRightArrow: true,
                        //       isLastItem: true,
                        //     ),
                        //   ],
                        // ),
                        // 10.verticalSpace,
                        InputBox.phone(
                          label: StrRes.phoneNumber,
                          hintText: StrRes.plsEnterPhoneNumber,
                          code: logic.areaCode.value,
                          onAreaCode: logic.openCountryCodePicker,
                          controller: logic.phoneCtrl,
                        ),
                        16.verticalSpace,
                        InputBox.password(
                          label: StrRes.password,
                          hintText: StrRes.plsEnterPassword,
                          controller: logic.pwdCtrl,
                        ),
                        30.verticalSpace,
                        Button(
                          text: StrRes.login,
                          enabled: logic.enabled.value,
                          onTap: logic.login,
                        ),
                        10.verticalSpace,
                        RichText(
                          text: TextSpan(
                            text: StrRes.noAccountYet,
                            style: Styles.ts_8E9AB0_12sp,
                            children: [
                              TextSpan(
                                text: StrRes.registerNow,
                                style: Styles.ts_0089FF_12sp,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = logic.registerNow,
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemGroupView({required List<Widget> children}) => Container(
        // margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.r),
            topRight: Radius.circular(6.r),
            bottomLeft: Radius.circular(6.r),
            bottomRight: Radius.circular(6.r),
          ),
        ),
        child: Column(children: children),
      );

  Widget _buildItemView({
    required String label,
    TextStyle? textStyle,
    String? value,
    bool switchOn = false,
    bool isFirstItem = false,
    bool isLastItem = false,
    bool showRightArrow = false,
    bool showSwitchButton = false,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      Container(
        child: Ink(
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(isFirstItem ? 10.r : 0),
              topLeft: Radius.circular(isFirstItem ? 10.r : 0),
              bottomLeft: Radius.circular(isLastItem ? 10.r : 0),
              bottomRight: Radius.circular(isLastItem ? 10.r : 0),
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 46.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  label.toText..style = textStyle ?? Styles.ts_0C1C33_14sp,
                  const Spacer(),
                  if (showSwitchButton)
                    CupertinoSwitch(
                      value: switchOn,
                      activeColor: Styles.c_0089FF,
                      onChanged: onChanged,
                    ),
                  if (showRightArrow)
                    ImageRes.rightArrow.toImage
                      ..width = 20.w
                      ..height = 20.h,
                ],
              ),
            ),
          ),
        ),
      );
}
