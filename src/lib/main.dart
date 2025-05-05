import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:instagramanalyzer/Apps/Instagram/Follower/follower_list.dart';
import 'package:instagramanalyzer/Apps/Instagram/homepage_instagram.dart';
import 'package:instagramanalyzer/Apps/Instagram/Posts/post_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'Apps/Instagram/Messages/message_list.dart';
import 'Apps/Spotify/Song/played_song.dart';
import 'Apps/Spotify/Song/played_songs_list.dart';
import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);

  Hive.registerAdapter(PlayedSongAdapter());

  await Hive.openBox<PlayedSong>('songsBox');


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostList()),
        ChangeNotifierProvider(create: (_) => FollowerList()),
        ChangeNotifierProvider(create: (_) => MesageSenderList()),
        ChangeNotifierProvider(create: (_) => PlayedSongsList()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Homepage(),
    );
  }
}
