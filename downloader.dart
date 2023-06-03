import 'dart:async';
import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

Future<void> main() async {
  String link = wantLinkFromUser();
  final videoId = getYoutubeVideoId(link);
  await downloadVideo(videoId);
}

Future<void> downloadVideo(String videoId) async {
  final yt = YoutubeExplode();
  final downloadFile = await wantFileName();
  final manifest = await yt.videos.streams.getManifest(videoId);

  final video = manifest.muxed.bestQuality;

  final sink = downloadFile.openWrite();

  try {
    await yt.videos.streams.get(video).pipe(sink);
  } catch (e) {
    print(e);
  }
  print('.......Downloaded.......');
}

Future<File> wantFileName() async {
  print('Provide a file name');
  final name = stdin.readLineSync();
  if (name != null) {
    return await File('downloads/$name.mp4').create();
  } else {
    wantFileName();
  }
  throw Exception('file name doesnt provided');
}

String wantLinkFromUser() {
  print('Provide a youtube video link');
  String? link = stdin.readLineSync();
  if (link != null) {
    return link;
  } else {
    throw Exception('link is not provided');
  }
}

String getYoutubeVideoId(String link) {
  int id = link.indexOf('v=');
  return link = link.substring(id + 2, id + 13);
}
