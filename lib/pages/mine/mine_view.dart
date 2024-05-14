import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';

import 'mine_logic.dart';
import 'package:privchat/widgets/group_item_view.dart';

class MinePage extends StatelessWidget {
  final logic = Get.find<MineLogic>();

  MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.mine(
        onScan: null,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => _buildMyInfoView()),
            10.verticalSpace,
            GroupItemView(
              children: [
                IconItemView(
                  icon: ImageRes.profileEdit,
                  label: StrRes.myInfo,
                  onTap: logic.viewMyInfo,
                  isTopRadius: true,
                ),
                Divider(height: 1, color: Styles.c_E8EAEF, indent: 44.w),
                IconItemView(
                  icon: ImageRes.accountSetup,
                  label: StrRes.accountSetup,
                  onTap: logic.accountSetup,
                ),
                Divider(height: 1, color: Styles.c_E8EAEF, indent: 44.w),
                IconItemView(
                  icon: ImageRes.notificationSetup,
                  label: StrRes.notificationSetup,
                  onTap: logic.notificationSetup,
                ),
                Divider(height: 1, color: Styles.c_E8EAEF, indent: 44.w),
                IconItemView(
                  icon: ImageRes.settingSetup,
                  label: StrRes.systemSetup,
                  onTap: logic.systemSetup,
                ),
                Divider(height: 1, color: Styles.c_E8EAEF, indent: 44.w),
                IconItemView(
                  icon: ImageRes.privacySetup,
                  label: StrRes.privacySetup,
                  onTap: logic.privacySetup,
                  isBottomRadius: true,
                ),
              ],
            ),
            10.verticalSpace,
            GroupItemView(
              children: [
                IconItemView(
                  icon: ImageRes.aboutUs,
                  label: StrRes.aboutUs,
                  onTap: logic.aboutUs,
                  isTopRadius: true,
                  isBottomRadius: true,
                ),
              ]),
            10.verticalSpace,
            GroupItemView(
              children: [
                IconItemView(
                  icon: ImageRes.logout,
                  label: StrRes.logout,
                  onTap: logic.logout,
                  isTopRadius: true,
                  isBottomRadius: true,
                ),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _buildMyInfoView() => Container(
        margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          children: [
            AvatarView(
              url: logic.imLogic.userInfo.value.faceURL,
              text: logic.imLogic.userInfo.value.nickname,
              width: 48.w,
              height: 48.h,
              textStyle: Styles.ts_FFFFFF_14sp,
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (logic.imLogic.userInfo.value.nickname ?? '').toText
                    ..style = Styles.ts_0C1C33_17sp_medium,
                  4.verticalSpace,
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: logic.copyID,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        (StrRes.account + StrRes.colon + ' ').toText
                          ..style = Styles.ts_8E9AB0_14sp,
                        (logic.imLogic.userInfo.value.account ?? '').toText
                          ..style = Styles.ts_8E9AB0_14sp,
                        ImageRes.mineCopy.toImage
                          ..width = 16.w
                          ..height = 16.h,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: logic.viewMyQrcode,
              child: Row(
                children: [
                  ImageRes.mineQr.toImage
                    ..width = 18.w
                    ..height = 18.h,
                  8.horizontalSpace,
                  ImageRes.rightArrow.toImage
                    ..width = 24.w
                    ..height = 24.h,
                ],
              ),
            )
          ],
        ),
      );
}
