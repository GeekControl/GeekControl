class IntoxiSeasonsEntity {
  final String title;
  final String image;
  final String date;
  final String description;
  final String href;

  IntoxiSeasonsEntity({
    required this.title,
    required this.image,
    required this.date,
    required this.description,
    required this.href,
  });

  static IntoxiSeasonsEntity fromMap(Map<String, dynamic> map) {
    return IntoxiSeasonsEntity(
      title: map['title'],
      image: map['image'],
      date: map['date'],
      description: map['description'],
      href: map['href'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'date': date,
      'description': description,
      'href': href,
    };
  }
}
