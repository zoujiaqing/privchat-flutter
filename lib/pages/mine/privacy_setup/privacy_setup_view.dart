import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:privchat/widgets/group_item_view.dart';

import 'privacy_setup_logic.dart';

class PrivacySetupPage extends StatelessWidget {
  final logic = Get.find<PrivacySetupLogic>();

  PrivacySetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.privacySetup,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: SingleChildScrollView(
        child: Column(
          children: [
            10.verticalSpace,
            GroupItemView(
              children: [
                ItemView(
                  label: StrRes.forbidAddMeToFriend,
                  switchOn: false,
                  showSwitchButton: true,
                  isFirstItem: true,
                ),
                Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
                ItemView(
                  label: StrRes.blacklist,
                  onTap: logic.blacklist,
                  showRightArrow: true,
                ),
              ],
            ),
            10.verticalSpace,
            GroupItemView(
              children: [
                ItemView(
                  label: StrRes.clearChatHistory,
                  textStyle: Styles.ts_FF381F_14sp,
                  onTap: logic.clearChatHistory,
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
}
