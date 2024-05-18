import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:privchat/widgets/group_item_view.dart';

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
            GroupItemView(
              children: [
                ItemView(
                  label: StrRes.notDisturbMode,
                  showSwitchButton: true,
                  isFirstItem: true,
                ),
                Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
                ItemView(
                  label: StrRes.allowRing,
                  showSwitchButton: true,
                ),
                Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
                ItemView(
                  label: StrRes.allowVibrate,
                  showSwitchButton: true,
                  isLastItem: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
