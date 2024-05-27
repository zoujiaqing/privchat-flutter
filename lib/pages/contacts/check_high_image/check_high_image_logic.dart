import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:privchat/pages/contacts/add_by_search/add_by_search_logic.dart';
import 'package:privchat/routes/app_navigator.dart';
import 'package:photo_manager/photo_manager.dart';

class CheckHighImageLogic extends GetxController {

  final images = <AssetEntity>[];

  late String imageUrl;

  @override
  void onInit() {
    imageUrl = Get.arguments['imageUrl'];
    super.onInit();
  }


  Future<void> loadImages() async {
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 1,
    );

  }

}