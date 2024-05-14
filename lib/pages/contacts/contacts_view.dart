import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';

import 'contacts_logic.dart';

class ContactsPage extends StatelessWidget {
  final logic = Get.find<ContactsLogic>();

  ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.contacts(
        onClickAddContacts: logic.addContacts,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              10.verticalSpace,
              _buildItemGroupView(children: [
                _buildItemView(
                  assetsName: ImageRes.newFriend,
                  label: StrRes.newFriend,
                  count: logic.friendApplicationCount,
                  onTap: logic.newFriend,
                ),
                Divider(height: 1, color: Styles.c_E8EAEF, indent: 44.w),
                _buildItemView(
                  assetsName: ImageRes.newGroup,
                  label: StrRes.newGroup,
                  count: logic.groupApplicationCount,
                  onTap: logic.newGroup,
                ),
              ]),
              10.verticalSpace,
              _buildItemGroupView(children: [
                _buildItemView(
                  assetsName: ImageRes.myFriend,
                  label: StrRes.myFriend,
                  onTap: logic.myFriend,
                ),
                Divider(height: 1, color: Styles.c_E8EAEF, indent: 44.w),
                _buildItemView(
                  assetsName: ImageRes.myGroup,
                  label: StrRes.myGroup,
                  onTap: logic.myGroup,
                ),
              ]),
              10.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemGroupView({required List<Widget> children}) => Container(
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
    String? assetsName,
    required String label,
    Widget? icon,
    int count = 0,
    bool showRightArrow = true,
    double? height,
    Function()? onTap,
  }) =>
      Ink(
        color: Styles.c_FFFFFF,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height ?? 60.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                if (null != assetsName)
                  assetsName.toImage
                    ..width = 20.w
                    ..height = 20.h,
                if (null != icon) icon,
                12.horizontalSpace,
                label.toText..style = Styles.ts_0C1C33_14sp,
                const Spacer(),
                if (count > 0) UnreadCountView(count: count),
                4.horizontalSpace,
                if (showRightArrow)
                  ImageRes.rightArrow.toImage
                    ..width = 20.w
                    ..height = 20.h,
              ],
            ),
          ),
        ),
      );
}
