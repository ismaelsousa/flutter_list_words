import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:start_up/src/DTOS/album.dto.dart';
import 'package:start_up/src/services/Album.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Startup Name Generator",
      home: RandomWords(),
      theme: ThemeData(primaryColor: Colors.black),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _saved = <WordPair>{};
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  late Future<Album> album;
  final TextEditingController? controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    album = fetchAlbum();
  }

  @override
  void didChangeDependencies() {
    print(_saved);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(oldWidget) {
    print(_saved);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print(_saved);
    super.dispose();
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/
          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _saved.map((WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });

      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(context: context, tiles: tiles).toList()
          : <Widget>[];

      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestions'),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Album>(
            future: album,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                    child: Text(
                  snapshot.data!.title.split(' ')[0],
                ));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }),
        actions: [IconButton(onPressed: _pushSaved, icon: Icon(Icons.list))],
      ),
      body: _buildSuggestions(),
    );
  }
}

/**
 * Future Build is to async render
 */
//  FutureBuilder<Album>(
//             future: album,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Container(
//                     child: Text(
//                   snapshot.data!.title,
//                 ));
//               } else if (snapshot.hasError) {
//                 return Text('${snapshot.error}');
//               }
//               return const CircularProgressIndicator();
//             })