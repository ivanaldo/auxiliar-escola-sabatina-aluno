
class VideoModel {
  final String id;
  final String titulo;
  final String imagem;
  final String tituloCanal;
  final String data;

  VideoModel({
    this.id,
    this.titulo,
    this.imagem,
    this.tituloCanal,
    this.data
  });

  factory VideoModel.fromMap(Map<String, dynamic> snippet) {
    return VideoModel(
        id: snippet['resourceId']['videoId'],
        titulo: snippet['title'],
        imagem: snippet['thumbnails']['high']['url'],
        tituloCanal: snippet['channelTitle'],
        data: snippet ["publishedAt"]
    );
  }
}
