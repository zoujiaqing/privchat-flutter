import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:flutter/cupertino.dart';

class GroupItemView extends StatelessWidget {
  final List<Widget> children;

  const GroupItemView({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
  }
}

class IconItemView extends StatelessWidget {
  final String icon;
  final String label;
  final bool isFirstItem;
  final bool isLastItem;
  final VoidCallback? onTap;

  const IconItemView({
    Key? key,
    required this.icon,
    required this.label,
    this.isFirstItem = false,
    this.isLastItem = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              height: 48.h,
              padding: EdgeInsets.only(left: 12.w, right: 16.w),
              child: Row(
                children: [
                  icon.toImage
                    ..width = 20.w
                    ..height = 20.h,
                  11.horizontalSpace,
                  label.toText..style = Styles.ts_0C1C33_14sp,
                  const Spacer(),
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
}

class ItemView extends StatelessWidget {
  final String label;
  final String? value;
  final String? url;
  final bool isAvatar;
  final bool showRightArrow;
  final VoidCallback? onTap;
  final bool isFirstItem;
  final bool isLastItem;
  final bool switchOn;
  final bool showSwitchButton;
  final ValueChanged<bool>? onChanged;
  final TextStyle? textStyle;
  final bool isQrcode;

  const ItemView({
    Key? key,
    required this.label,
    this.value,
    this.url,
    this.isAvatar = false,
    this.showRightArrow = false,
    this.isFirstItem = false,
    this.isLastItem = false,
    this.onTap,
    this.switchOn = false,
    this.showSwitchButton = false,
    this.onChanged,
    this.textStyle,
    this.isQrcode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: showRightArrow ? onTap : null,
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
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            // margin: EdgeInsets.symmetric(horizontal: 10.w),
            child: SizedBox(
                height: 46.h,
                child: Row(
                  children: [
                    label.toText..style = textStyle ?? Styles.ts_0C1C33_14sp,
                    const Spacer(),
                    if (isAvatar)
                      AvatarView(
                        width: 32.w,
                        height: 32.h,
                        url: url,
                        text: value,
                        textStyle: Styles.ts_FFFFFF_10sp,
                      )
                    else if (isQrcode)
                      ImageRes.mineQr.toImage
                        ..width = 18.w
                        ..height = 18.h
                    else
                      Expanded(
                          flex: 3,
                          child: (IMUtils.emptyStrToNull(value) ?? '').toText
                            ..style = Styles.ts_0C1C33_14sp
                            ..maxLines = 1
                            ..overflow = TextOverflow.ellipsis
                            ..textAlign = TextAlign.right),
                    if (showRightArrow)
                      ImageRes.rightArrow.toImage
                        ..width = 20.w
                        ..height = 20.h,
                    if (showSwitchButton)
                      CupertinoSwitch(
                        value: switchOn,
                        activeColor: Styles.c_0089FF,
                        onChanged: onChanged,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
}
