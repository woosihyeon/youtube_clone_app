import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_clone_app/src/models/youtube_video_result.dart';
import 'package:youtube_clone_app/src/repository/youtube_repository.dart';

class YoutubeSearchController extends GetxController {
  String key = 'SearchKey';
  RxList<String> history = RxList<String>.empty(growable: true);
  late SharedPreferences profs;
  late String _currentKeyword;
  Rx<YoutubeVideoResult> youtubeVideoRwsult = YoutubeVideoResult(items: []).obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    _event();
    profs = await SharedPreferences.getInstance();
    List<dynamic>? initData = (profs.get(key) ?? []) as List;
    history(initData.map((_) => _.toString()).toList());

    super.onInit();
  }

  void _event() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          youtubeVideoRwsult.value.nextPagetoken != '') {
        _searchYoutube(_currentKeyword);
      }
    });
  }

  void search(String searchKey) {
    history.addIf(!history.contains(searchKey), searchKey);
    profs.setStringList(key, history);
    _currentKeyword = searchKey;
    _searchYoutube(searchKey);
  }

  void _searchYoutube(String searchKey) async {
    YoutubeVideoResult? youtubeVideoRwsultFromServer =
        await YoutubeRepository.to.search(searchKey,youtubeVideoRwsult.value.nextPagetoken ?? '');
    if (youtubeVideoRwsultFromServer != null &&
        youtubeVideoRwsultFromServer.items != null &&
        youtubeVideoRwsultFromServer.items!.length > 0) {
      youtubeVideoRwsult.update((youtube) {
        youtube!.nextPagetoken = youtubeVideoRwsultFromServer.nextPagetoken;
        youtube.items!.addAll(youtubeVideoRwsultFromServer.items!);
      });
    }
  }
}
