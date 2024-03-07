class PlayerModalBulk {
  String name;
  String number;
  String url;
  bool isSelected;

  PlayerModalBulk(
      {this.name = '',
      this.number = '',
      this.url = '',
      this.isSelected = false});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
      'url': url,
    };
  }

  factory PlayerModalBulk.fromJson(Map<String, dynamic> json) {
    return PlayerModalBulk(
      name: json['name'] ?? '',
      number: json['number'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
