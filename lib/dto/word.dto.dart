class Word {
  final String name;
  final String type;
  final String difficult;
  final String audio;

  Word({
    required this.name,
    required this.type,
    required this.difficult,
    required this.audio,
  });

  factory Word.fromJson(Map json) => Word(
        name: json['name'],
        type: json['type'],
        difficult: json['difficult'],
        audio: json['audio'],
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'difficult': difficult,
    'audio': audio,
  };
}
