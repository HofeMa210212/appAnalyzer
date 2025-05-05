

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagramanalyzer/Apps/Instagram/homepage_instagram.dart';
import 'package:instagramanalyzer/Apps/Spotify/homepage_spotify.dart';
import 'package:instagramanalyzer/Color/app_Colors.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedApp = 0;
  List<Widget> pages = [
    HomepageInstagram(),
    HomepageSpotiy()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: Text(
            "Statistics",
            style: GoogleFonts.roboto(
              color: Colors.white54,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
        ),
        centerTitle: true,
      ),


      body: Column(
        children: [

          Center(
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.basicContainerColor,
                borderRadius: BorderRadius.circular(6)
              ),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 10000),
                    curve: Curves.easeInOutCubicEmphasized,
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.4,
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.4 * selectedApp),
                    decoration: BoxDecoration(
                      color: AppColors.spotifyGreen,
                      borderRadius: BorderRadius.circular(6)
                    ),

                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedApp = 0;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.transparent
                          ),
                          child: Center(
                            child: Text(
                              "Instagram",
                              style: GoogleFonts.roboto(
                                color: Colors.white70,
                                fontSize: 20
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedApp = 1;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.transparent
                          ),
                          child: Center(
                            child: Text(
                              "Spotify",
                              style: GoogleFonts.roboto(
                                color: Colors.white70,
                                fontSize: 20
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),


          Expanded(
            child: Container(
             
              child: IndexedStack(
                children: pages,
                index: selectedApp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
