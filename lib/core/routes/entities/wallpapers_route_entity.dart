class WallpapersRouteEntity {
  final List<String> images;
  final int index;

  WallpapersRouteEntity({
    required this.images,
    required this.index,
  });

  factory WallpapersRouteEntity.fromMap(Map map) {
    return WallpapersRouteEntity(
      images: map['images'],
      index: map['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'images': images,
      'index': index,
    };
  }
}