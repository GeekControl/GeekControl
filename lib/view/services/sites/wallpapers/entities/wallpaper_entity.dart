class WallpaperEntity {
  String name;
  String uri;
  int size;
  bool isDownloaded;

  WallpaperEntity({
    required this.name,
    required this.uri,
    required this.size,
    required this.isDownloaded,
  });

  List<dynamic> toList() {
    return [
      name,
      uri,
      size,
      isDownloaded,
    ];
  }
}
