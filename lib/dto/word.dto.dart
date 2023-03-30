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

class Definition {
  final String transcription;
  final String meaning;
  final List<String> examples;

  const Definition({
    required this.transcription,
    required this.meaning,
    required this.examples,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      transcription: json['transcription'],
      meaning: json['meaning'],
      examples: List.from(json['examples']),
    );
  }
}