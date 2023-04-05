import 'package:flutter/material.dart';
import '../../dto/word.dto.dart';

class WordMiniCard extends StatelessWidget {
  const WordMiniCard({
    super.key,
    this.onPlay,
    this.onShowDefinition,
    required this.word,
  });

  final Word word;
  final Function()? onPlay;
  final Function()? onShowDefinition;

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
              onPressed: () => onPlay?.call(),
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
                        word.name,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '${word.type} ${word.difficult}',
                        style: theme.textTheme.bodySmall!.copyWith(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.6)),
                      ),
                    ],
                  ),
                  Text(
                    word.translation.ru,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => onShowDefinition?.call(),
              icon: const Icon(Icons.description),
            )
          ],
        ),
      ),
    );
  }
}
