import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_sabatina_alunos/apis/apiService.dart';
import 'package:escola_sabatina_alunos/model/channel.dart';
import 'package:escola_sabatina_alunos/model/video.dart';
import 'package:escola_sabatina_alunos/videos/videosScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class Informativo extends StatefulWidget {
  @override
  _InformativoState createState() => _InformativoState();
}

class _InformativoState extends State<Informativo> {
  Channel _channel;
  String informativo;

  @override
  void initState() {
    super.initState();
    _retornaInformativo();
  }

  Future<dynamic> _retornaInformativo() async {
    FirebaseFirestore.instance
        .collection('videos')
        .doc("informativo")
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          informativo = doc["informativos"];
        });
        _initChannel();
      }
    });
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCZrVZOwtnvVIdsZnDpVb7jw',
        playlistId: informativo);

    setState(() {
      _channel = channel;
    });
  }

  _buildProfileInfo() {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(10.0),
      height: 4,
    );
  }

  _buildVideo(VideoModel video) {
    var dateFormate =
    DateFormat("dd/MM/yyyy").format(DateTime.parse(video.data));

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.all(10.0),
        height: 330,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Icon(Icons.play_arrow, size: 80, color: Colors.white70),
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(video.imagem)),
              ),
            ),
            ListTile(
              title: Text(video.titulo),
              subtitle: Text(video.tituloCanal + "  " + dateFormate),
            )
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _channel != null
          ? NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollDetails) {
          if (_channel.videos.length != int.parse(_channel.videoCount) &&
              scrollDetails.metrics.pixels ==
                  scrollDetails.metrics.maxScrollExtent) {
          }
          return false;
        },
        child: ListView.builder(
          itemCount: 1 + _channel.videos.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildProfileInfo();
            }
            VideoModel video = _channel.videos[index - 1];
            return _buildVideo(video);
          },
        ),
      )
          : Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).accentColor, // Red
          ),
        ),
      ),
    );
  }
}