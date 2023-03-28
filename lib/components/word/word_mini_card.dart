
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../dto/word.dto.dart';

class WordMiniCard extends StatefulWidget {
  const WordMiniCard({
    super.key,
    required this.word,
  });

  final Word word;

  @override
  State<WordMiniCard> createState() => _WordMiniCardState();
}

class _WordMiniCardState extends State<WordMiniCard> {

  final player = AudioPlayer();
  // TODO: реализовать остановку при повторном нажатии
  bool isPlaying = false;

  play() {
    var url = 'https://www.oxfordlearnersdictionaries.com/${widget.word.audio}';
    player.play(UrlSource(url));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: play,
              icon: const Icon(Icons.play_arrow),
            ),
            const SizedBox(width: 4.0),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.word.name,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '${widget.word.type} ${widget.word.difficult}',
                        style: theme.textTheme.bodySmall!.copyWith(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.6)),
                      ),
                    ],
                  ),
                  Text(
                    'Перевод',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.description))
          ],
        ),
      ),
    );
  }
}
