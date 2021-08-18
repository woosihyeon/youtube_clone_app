import 'package:youtube_clone_app/src/models/video.dart';

class YoutubeVideoResult{
  late int? totalResults;
  late int? resultsPerpage;
  late String? nextPagetoken;
  late List<Video>? items;

  YoutubeVideoResult({
    this.totalResults,
    this.resultsPerpage,
    this.nextPagetoken,
    this.items,
  });

  factory YoutubeVideoResult.fromJson(Map<String, dynamic> json) =>
      YoutubeVideoResult(
        totalResults: json['pageInfo']['totalResults'],
        resultsPerpage: json['pageInfo']['resultsPerPage'],
        nextPagetoken: json['nextPageToken'] ?? '',
        items:
            List<Video>.from(json['items'].map((data) => Video.fromJson(data))),
      );
}
