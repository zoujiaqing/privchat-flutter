import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';

import 'notification_setup_logic.dart';

class NotificationSetupPage extends StatelessWidget {
  final logic = Get.find<NotificationSetupLogic>();

  NotificationSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.notificationSetup,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: SingleChildScrollView(
        child: Column(
          children: [
            10.verticalSpace,
            _buildItemView(
              label: StrRes.notDisturbMode,
              showSwitchButton: true,
              isLastItem: true,
            ),
            _buildItemView(
              label: StrRes.allowRing,
              showSwitchButton: true,
              isLastItem: true,
            ),
            _buildItemView(
              label: StrRes.allowVibrate,
              showSwitchButton: true,
              isLastItem: true,
            ),
          ],
        ),
      ),
    );
  }

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
        margin: EdgeInsets.symmetric(horizontal: 10.w),
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
                    Transform.scale(
                      scale: 0.8,
                      child: 
                        CupertinoSwitch(
                          value: switchOn,
                          activeColor: Styles.c_0089FF,
                          onChanged: onChanged,
                        ),
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
