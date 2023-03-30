import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../components/word/word_mini_card.dart';
import '../dto/word.dto.dart';
import '../init_db.dart';

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
    var dictDB = DictDB();
    await dictDB.init();

    var all = await dictDB.getAllWords();
    var a1 = await dictDB.getWords('a1');
    var a2 = await dictDB.getWords('a2');
    var b1 = await dictDB.getWords('b1');
    var b2 = await dictDB.getWords('b2');
    var c1 = await dictDB.getWords('c1');

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
    var url = 'https://www.oxfordlearnersdictionaries.com/${word.audio}';
    player.play(UrlSource(url));
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: difficults.map((difficult) {
              final d = wordMap[difficult]!;
              var proto = d.isNotEmpty ? WordMiniCard(word: d.first) : null;

              return ListView.builder(
                itemCount: d.length,
                prototypeItem: proto,
                itemBuilder: (context, index) => WordMiniCard(
                  word: d[index],
                  onPlay: () => play(d[index]),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
