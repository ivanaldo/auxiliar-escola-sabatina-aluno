import 'dart:convert';
import 'dart:io';
import 'package:escola_sabatina_alunos/model/channel.dart';
import 'package:escola_sabatina_alunos/model/video.dart';
import 'package:http/http.dart' as http;



class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel({String channelId, String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': "AIzaSyDQ2GrtYnd8tbgAmk8spoUduEtFsvtNnu4",
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      // Fetch first batch of videos from uploads playlist
      channel.videos = await fetchVideosFromPlaylist(
        playlistId: playlistId,
      );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<VideoModel>> fetchVideosFromPlaylist({String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '13',
      'pageToken': _nextPageToken,
      'key': "AIzaSyDQ2GrtYnd8tbgAmk8spoUduEtFsvtNnu4",
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first eight videos from uploads playlist
      List<VideoModel> videos = [];
      videosJson.forEach(
            (json) => videos.add(
          VideoModel.fromMap(json['snippet']),
        ),
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

}
