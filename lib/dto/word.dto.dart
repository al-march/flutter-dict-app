class Word {
  final String name;
  final String type;
  final String difficult;
  final String audio;
  final String transcription;

  Word({
    required this.name,
    required this.type,
    required this.difficult,
    required this.audio,
    required this.transcription,
  });

  factory Word.fromJson(Map json) => Word(
        name: json['name'],
        type: json['type'],
        difficult: json['difficult'],
        audio: json['audio'],
        transcription: json['transcription'],
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'difficult': difficult,
    'audio': audio,
    'transcription': transcription
  };
}

class Definition {
  final String meaning;
  final String examples;

  const Definition({
    required this.meaning,
    required this.examples,
  });

  factory Definition.fromJson(Map json) {
    return Definition(
      meaning: json['meaning'],
      examples: json['examples'],
    );
  }
}