import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../components/word/word_mini_card.dart';
import '../dto/word.dto.dart';
import '../init_db.dart';

var dictDB = DictDB();

class AllWordsPage extends StatefulWidget {
  const AllWordsPage({super.key});

  @override
  State<AllWordsPage> createState() => _AllWordsPageState();
}

class _AllWordsPageState extends State<AllWordsPage> {
  final player = AudioPlayer();
  List<String> difficults = [
    'all',
    'a1',
    'a2',
    'b1',
    'b2',
    'c1',
  ];

  Map<String, List<Word>> wordMap = {
    'all': [],
    'a1': [],
    'a2': [],
    'b1': [],
    'b2': [],
    'c1': [],
  };

  @override
  void initState() {
    super.initState();
    getWords();
  }

  getWords() async {
    await dictDB.init();

    var all = await dictDB.getAllWords();

    byDificult(String dif) => all.where((w) => w.difficult == dif).toList();

    var a1 = byDificult('a1');
    var a2 = byDificult('a2');
    var b1 = byDificult('b1');
    var b2 = byDificult('b2');
    var c1 = byDificult('c1');

    setState(() {
      wordMap['all'] = all;
      wordMap['a1'] = a1;
      wordMap['a2'] = a2;
      wordMap['b1'] = b1;
      wordMap['b2'] = b2;
      wordMap['c1'] = c1;
    });
  }

  play(Word word) {
    // var url = 'https://www.oxfordlearnersdictionaries.com/${word.audio}';
    player.play(UrlSource(word.audio));
  }

  showWordDefinition(Word word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: Border.all(width: 0, color: Colors.transparent),
      builder: (BuildContext context) => WordBottomSheet(
        word: word,
        onPlay: () => play(word),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: difficults.length,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
              tabs: difficults
                  .map(
                    (tab) => Tab(
                      icon: Text(tab.toUpperCase()),
                    ),
                  )
                  .toList()),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TabBarView(
                  children: difficults.map((difficult) {
                    final d = wordMap[difficult]!;
                    var proto =
                        d.isNotEmpty ? WordMiniCard(word: d.first) : null;

                    return ListView.builder(
                      itemCount: d.length,
                      prototypeItem: proto,
                      itemBuilder: (context, index) => WordMiniCard(
                        word: d[index],
                        onPlay: () => play(d[index]),
                        onShowDefinition: () => showWordDefinition(d[index]),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WordBottomSheet extends StatefulWidget {
  const WordBottomSheet({
    super.key,
    required this.word,
    required this.onPlay,
  });

  final Word word;
  final Function onPlay;

  @override
  State<WordBottomSheet> createState() => _WordBottomSheetState();
}

class _WordBottomSheetState extends State<WordBottomSheet> {
  List<Definition> definitions = [];
  Definition? mainDefinition;

  @override
  void initState() {
    super.initState();
    getDefinitions();
  }

  getDefinitions() async {
    var defs = await dictDB.getWordDefinitions(widget.word.name);
    setState(() {
      definitions = defs;
      if (definitions.isNotEmpty) {
        mainDefinition = definitions[0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return makeDismissible(
      context: context,
      child: DraggableScrollableSheet(
        maxChildSize: 0.9,
        minChildSize: 0.3,
        initialChildSize: 0.7,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onBackground.withOpacity(0.8),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                        bottom: Radius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              ListView(
                controller: controller,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => widget.onPlay(),
                        icon: const Icon(Icons.play_arrow),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.word.name,
                        style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.word.transcription,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const Spacer(flex: 1),
                      Text(widget.word.difficult),
                    ],
                  ),
                  Divider(
                    color: theme.colorScheme.onBackground.withOpacity(0.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.word.translation.ru,
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onBackground.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (mainDefinition != null)
                    Text(
                      mainDefinition!.meaning,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'Примеры:',
                    style: theme.textTheme.bodyLarge,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: definitions
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: 6,
                                top: 6,
                              ),
                              child: Text('- ${e.meaning}'),
                            ))
                        .toList(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeDismissible({
    required Widget child,
    required BuildContext context,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(child: child),
    );
  }
}
