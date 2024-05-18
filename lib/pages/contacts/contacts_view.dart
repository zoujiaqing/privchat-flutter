import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:privchat/widgets/group_item_view.dart';

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
            GroupItemView(
              children: [
                IconItemView(
                  isFirstItem: true,
                  icon: ImageRes.newFriend,
                  label: StrRes.newFriend,
                  count: logic.friendApplicationCount,
                  onTap: logic.newFriend,
                ),
                Divider(height: 1, color: Styles.c_E8EAEF, indent: 44.w),
                IconItemView(
                  isLastItem: true,
                  icon: ImageRes.newGroup,
                  label: StrRes.newGroup,
                  count: logic.groupApplicationCount,
                  onTap: logic.newGroup,
                ),
              ]),
              10.verticalSpace,
            GroupItemView(
              children: [
                IconItemView(
                  isFirstItem: true,
                  icon: ImageRes.myFriend,
                  label: StrRes.myFriend,
                  onTap: logic.myFriend,
                ),
                Divider(height: 1, color: Styles.c_E8EAEF, indent: 44.w),
                IconItemView(
                  isLastItem: true,
                  icon: ImageRes.myGroup,
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
}
