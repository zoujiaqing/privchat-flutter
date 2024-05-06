import 'package:flutter/material.dart';
import 'package:privchat/utils/int_ext.dart';

class ChatInputBox extends StatelessWidget {
  final String? hintText;
  final int? maxLength;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;
  final String? errorText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final BoxConstraints? prefixIconConstraints;
  final BoxDecoration? decoration;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  const ChatInputBox({
    Key? key,
    this.maxLength = 20,
    this.controller,
    this.errorText,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.onEditingComplete,
    this.onSubmitted,
    this.contentPadding = EdgeInsets.zero,
    this.decoration,
    this.keyboardType,
    this.style,
    this.hintStyle,
    this.focusNode,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 75.cale,
      // margin: EdgeInsets.all(5.cale),
      constraints: BoxConstraints(
        minHeight: 75.cale,
        maxHeight: 350.cale,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.cale),
        color: Colors.white,
      ),
      child: TextField(
        // maxLength: maxLength,
        focusNode: focusNode,
        maxLines: null,
        maxLength: 200,
        cursorColor: Color(0xFF3BAB71),
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: keyboardType,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        style: style ?? TextStyle(fontSize: 28.cale, color: Color(0xFF333333)),
        // inputFormatters: inputFormatters,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent)),
          disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent)),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(7.cale),
            //borderSide: BorderSide(width: 0, color: Colors.transparent),
            // borderSide: BorderSide(width: 0, color: Colors.transparent),
          ),
          hintText: hintText,
          prefixIcon: prefixIcon,
          prefixIconConstraints: prefixIconConstraints,
          // hintStyle: hintStyle ?? AppTextStyle.textStyle_28_AAAAAA,
          hintStyle: hintStyle ?? TextStyle(fontSize: 28.cale, color: Color(0xFFAAAAAA)),
          counterText: '', //取消文字计数器
          // border: InputBorder.none,
          isDense: true,
          errorText: errorText,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.cale,
            vertical: 20.cale,
          ),
        ),
        // contentPadding:
        //     EdgeInsets.only(left: 16.cale, right: 16.cale, top: 20.cale),

        // errorText: "输入错误",
      ),
    );
  }
}