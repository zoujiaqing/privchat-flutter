import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';

import '../contacts/contacts_view.dart';
import '../conversation/conversation_view.dart';
import '../mine/mine_view.dart';
import 'home_logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double bottomPadding = 0;
    if (Platform.isIOS) {
      bottomPadding = 16.h;
    } else {
      bottomPadding = 16.h;
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.green,
      systemNavigationBarColor: Colors.green,
    ));
    return Obx(() => Scaffold(
          backgroundColor: Styles.c_FFFFFF,
          body: IndexedStack(
            index: logic.index.value,
            children: [
              ConversationPage(),
              ContactsPage(),
              MinePage(),
            ],
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: BottomBar(
              index: logic.index.value,
              items: [
                BottomBarItem(
                  selectedImgRes: ImageRes.homeTab1Sel,
                  unselectedImgRes: ImageRes.homeTab1Nor,
                  label: StrRes.home,
                  imgWidth: 28.w,
                  imgHeight: 28.h,
                  onClick: logic.switchTab,
                  onDoubleClick: logic.scrollToUnreadMessage,
                  count: logic.unreadMsgCount.value,
                ),
                BottomBarItem(
                  selectedImgRes: ImageRes.homeTab2Sel,
                  unselectedImgRes: ImageRes.homeTab2Nor,
                  label: StrRes.contacts,
                  imgWidth: 28.w,
                  imgHeight: 28.h,
                  onClick: logic.switchTab,
                  count: logic.unhandledCount.value,
                ),
                BottomBarItem(
                  selectedImgRes: ImageRes.homeTab4Sel,
                  unselectedImgRes: ImageRes.homeTab4Nor,
                  label: StrRes.mine,
                  imgWidth: 28.w,
                  imgHeight: 28.h,
                  onClick: logic.switchTab,
                ),
              ],
            ),
          ),
        ));
  }
}
