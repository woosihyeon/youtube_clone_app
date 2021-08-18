import 'package:get/get.dart';
import 'package:youtube_clone_app/src/models/statistics.dart';
import 'package:youtube_clone_app/src/models/video.dart';
import 'package:youtube_clone_app/src/models/youtuber.dart';
import 'package:youtube_clone_app/src/repository/youtube_repository.dart';

class VideoController extends GetxController {
  Video? video;
  VideoController({this.video});

  Rx<Statistics> statistics = Statistics().obs;
  Rx<Youtuber> youtuber = Youtuber().obs;

  @override
  void onInit() async {
    Statistics? loadStatistics =
        await YoutubeRepository.to.getVideoInfoById(video!.id.videoId);
    statistics(loadStatistics);
    Youtuber? loadyoutuber = await YoutubeRepository.to
        .getYoutuberInfoById(video!.snippet.channelId!);
    youtuber(loadyoutuber);

    super.onInit();
  }

  String get viewCountString => '조회수 ${statistics.value.viewCount}회';
  String get youtuberThumbnailUrl {
    if(youtuber.value.snippet == null){
      return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQU6e9jfX2J2K7x0gOkNGCIWDXZ19ppeo8NlQ&usqp=CAU';}
    else{
    return youtuber.value.snippet!.thumbnails!.medium.url;}
  }
}
