import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';

import 'account_setup_logic.dart';

class AccountSetupPage extends StatelessWidget {
  final logic = Get.find<AccountSetupLogic>();

  AccountSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.accountSetup,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: SingleChildScrollView(
        child: Column(
          children: [
            10.verticalSpace,
            _buildItemGroupView(
              children: [
                _buildItemView(
                  label: StrRes.mobile,
                  showRightArrow: true,
                  isFirstItem: true,
                ),
                Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w)
                ,
                _buildItemView(
                  label: StrRes.email,
                  showRightArrow: true,
                  isLastItem: true,
                ),
              ],
            ),
            10.verticalSpace,
            _buildItemGroupView(
              children: [
                _buildItemView(
                  label: StrRes.changePassword,
                  showRightArrow: true,
                  isFirstItem: true,
                  isLastItem: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemGroupView({required List<Widget> children}) => Container(
        // padding: EdgeInsets.symmetric(horizontal: 10.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
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
