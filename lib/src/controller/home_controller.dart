import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:youtube_clone_app/src/models/youtube_video_result.dart';
import 'package:youtube_clone_app/src/repository/youtube_repository.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  Rx<YoutubeVideoResult> youtubeResult = YoutubeVideoResult(items: []).obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    _videoLoad();
    _event();
    // TODO: implement onInit
    super.onInit();
  }

  void _event() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          youtubeResult.value.nextPagetoken != '') {
        _videoLoad();
      }
    });
  }

  void _videoLoad() async {
    YoutubeVideoResult? youtubeVideoResult = await YoutubeRepository.to
        .loadVideos(youtubeResult.value.nextPagetoken ?? '');
    if (youtubeResult != null &&
        youtubeVideoResult!.items != null &&
        youtubeVideoResult.items!.length > 0) {
      youtubeResult.update((youtube) {
        youtube!.nextPagetoken = youtubeVideoResult.nextPagetoken;
        youtube.items!.addAll(youtubeVideoResult.items!);
      });
    }
  }
}
