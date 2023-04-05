class Word {
  final String name;
  final String type;
  final String difficult;
  final String audio;
  final String transcription;
  final Translation translation;

  Word({
    required this.name,
    required this.type,
    required this.difficult,
    required this.audio,
    required this.transcription,
    required this.translation,
  });

  factory Word.fromJson(Map json) => Word(
        name: json['name'],
        type: json['type'],
        difficult: json['difficult'],
        audio: json['audio'],
        transcription: json['transcription'],
        translation: Translation.fromJson(json['translation']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'difficult': difficult,
        'audio': audio,
        'transcription': transcription
      };
}

class Translation {
  final String ru;

  Translation({
    required this.ru,
  });

  factory Translation.fromJson(Map json) => Translation(
        ru: json['ru'],
      );

  Map<String, dynamic> toJson() => {
        'ru': ru,
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
