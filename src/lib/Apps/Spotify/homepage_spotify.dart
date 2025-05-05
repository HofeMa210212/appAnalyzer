
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:instagramanalyzer/Apps/Spotify/Song/played_song.dart';
import 'package:instagramanalyzer/Apps/Spotify/spotify_auth.dart';
import 'package:instagramanalyzer/Color/app_Colors.dart';
import 'package:provider/provider.dart';

import '../../Chart/chart.dart';
import '../../json_converter.dart';
import 'Song/played_songs_list.dart';

class HomepageSpotiy extends StatefulWidget {
  const HomepageSpotiy({super.key});

  @override
  State<HomepageSpotiy> createState() => _HomepageSpotiyState();
}

class _HomepageSpotiyState extends State<HomepageSpotiy> {
  final auth = SpotifyAuth();


  void authentificate()async{
    await auth.fetchAccessToken();
  }

  Future<void> loginUser()async{
    await auth.logInUser();
  }

  Future<void> readFromHive() async {
    Provider.of<PlayedSongsList>(context, listen: false).read();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   authentificate();
    readFromHive();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Consumer<PlayedSongsList>(
                builder: (context, songList, child){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.spotifyContainerColor,
                          borderRadius: BorderRadius.circular(6)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "${songList.timeInMinutes} Minuten",
                              style: GoogleFonts.roboto(
                                color: Colors.white70,
                                fontSize: 18
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.spotifyContainerColor,
                          borderRadius: BorderRadius.circular(6)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "${songList.playedSongs.length} Songs",
                              style: GoogleFonts.roboto(
                                color: Colors.white70,
                                fontSize: 18
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            Container(
              height: 400,
              child: SingleChildScrollView(
                child: Consumer<PlayedSongsList>(
                  builder: (context, songList, child) {
                    int length = songList.playedSongs.length.clamp(0, 50);
                    List<PlayedSong> songs = songList.playedSongs;

                    return FutureBuilder<List<String>>(
                      future: songList.mostPlayedCovers(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return CircularProgressIndicator();
                        List<String> urls = snapshot.data!;

                        return Column(
                          spacing: 10,
                          children: List.generate(length, (index) {
                            return Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: AppColors.spotifyContainerColor,
                                  borderRadius: BorderRadius.circular(6)
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(
                                          urls[index],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  songs[index].trackName,
                                                  style: GoogleFonts.roboto(
                                                    color: Colors.white70,
                                                    fontSize: 18, // maximale Größe
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "${(songs[index].totalTime ~/ 60000).toString()} Minuten",
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.white54,
                                                      fontSize: 16
                                                  ),

                                                ),
                                                Text(
                                                  "${(songs[index].msPlayedList.length).toString()} mal",
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.white54,
                                                      fontSize: 16
                                                  ),

                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 20),
              height: 200,
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color: AppColors.basicContainerColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Consumer<PlayedSongsList>(
                builder: (context,songList, child){
                  return Center(
                    child: LineChartSpotify(dataPoints: [songList.getSongChartData()],curveSmoothness: 0.6,),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      String path = await JsonConverter.pickAndUnzipeFile();

                      Provider.of<PlayedSongsList>(context, listen: false).getPlayedSongsFromJson(path);
                    },
                    child: Text("Datei"),
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () async {
                    readFromHive();
                    },
                    child: Text("Laden"),
                  ),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: ()async{
                await loginUser();
              },
              child: Text("Login Spotify"),
            )


          ],
        ),
      ),
      

    );
  }


}
