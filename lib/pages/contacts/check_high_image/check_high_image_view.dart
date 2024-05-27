import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

import 'check_high_image_logic.dart';

class CheckHighImageViewPage extends StatelessWidget {
  final logic = Get.find<CheckHighImageLogic>();

  CheckHighImageViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: "check"),
      body: Center(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(logic.imageUrl),
          backgroundDecoration: BoxDecoration(color: Colors.black),
        ),
      ),
    );
  }

}
