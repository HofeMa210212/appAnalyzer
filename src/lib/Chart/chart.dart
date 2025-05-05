
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import '../Color/app_Colors.dart';

class SimpleLineChart extends StatelessWidget {

  final List<List<FlSpot>> dataPoints;
  final curveSmoothness;

  const SimpleLineChart({super.key,
    required this.dataPoints,
    this.curveSmoothness = 0.3
  });

  String timestampToDate(int timestamp){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.day}.${date.month}.${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    List<LineChartBarData> lineData = [];
    final allSpots = dataPoints.expand((e) => e).toList();

    double maxX = allSpots.map((e) => e.x).reduce((a, b) => a > b ? a : b);
    double maxY = allSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    List<Color> colors = AppColors.chartColors;

    for (int i = 0; i < dataPoints.length; i++) {
      List<FlSpot> d = dataPoints[i];
      if (d.isEmpty) d.add(FlSpot(0, 0));

      LineChartBarData data = LineChartBarData(
        spots: d,
        isCurved: true,
        curveSmoothness: curveSmoothness,
        color: colors[i % colors.length], // zyklisch Farbe zuweisen
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        preventCurveOverShooting: true,
      );

      lineData.add(data);
    }

    return  ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: LineChart(
        LineChartData(
          minY: -1,

          gridData: FlGridData(
            show: false,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Color(0x77121212), // Gitterfarbe grau
                strokeWidth: 0.5, // Sehr feine Gitterlinien
              );
            },
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: Color(0x77121212),  // Gitterfarbe grau
                strokeWidth: 0.5, // Sehr feine Gitterlinien
              );
            },
          ),
          titlesData:  FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false
              )
            ),
            topTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: false
                )
            ),
            rightTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: false
                )
            ),
            leftTitles: AxisTitles(

              sideTitles: SideTitles(
                showTitles: true,
                //minIncluded: true,
                  reservedSize: 40,
                getTitlesWidget: (value, meta) {

                  return Container(
                    margin: EdgeInsets.only(top: 15, left: 5),
                    child: Text(
                      value.toInt().toString(),
                      style: GoogleFonts.roboto(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  );
                },


              ),
            ),
          ),

          borderData: FlBorderData(show: false),
          lineBarsData: lineData,
          backgroundColor: Colors.transparent,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              rotateAngle: 0,
              tooltipRoundedRadius: 4,

              fitInsideHorizontally: true,
              fitInsideVertically: true,

              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${timestampToDate(spot.x.toInt())}: ${spot.y}',
                    const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          minX: -1,
          maxX: maxX,
          maxY: maxY,
        ),
      ),
    );
  }
}


class PieChartSample2 extends StatefulWidget {
  final double bothFollowing;
  final double youFollowing;
  final double otherFollowing;
  const PieChartSample2({super.key, required this.bothFollowing, required this.youFollowing, required this.otherFollowing});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Zentrieren der Widgets
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 3,
                  centerSpaceRadius: 35,

                  sections: showingSections(),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 40.0 : 35.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color:  Color(0XFF4CAF50),
            value: widget.bothFollowing,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.transparent,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xFFD32F2F),
            value: widget.youFollowing,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.transparent,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Color(0xFFFFC107),
            value: widget.otherFollowing,

            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.transparent,

            ),
          );

        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}


class SimpleBarChart extends StatefulWidget {
  List<double> data;
  List<String> titles;
  SimpleBarChart({super.key, required this.data, required this.titles});

  @override
  State<SimpleBarChart> createState() => _SimpleBarChartState();
}

class _SimpleBarChartState extends State<SimpleBarChart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: widget.data.elementAt(0) /100 + 5,
        alignment: BarChartAlignment.spaceEvenly,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  fontSize: 6,
                  color: Colors.transparent,
                  fontWeight: FontWeight.bold,
                );
                switch (value.toInt()) {
                  case 0:
                    return Text(widget.titles.elementAt(0), style: style);
                  case 1:
                    return Text(widget.titles.elementAt(1), style: style);
                  case 2:
                    return Text(widget.titles.elementAt(2), style: style);
                  case 3:
                    return Text(widget.titles.elementAt(3), style: style);
                  case 4:
                    return Text(widget.titles.elementAt(4), style: style);
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              minIncluded: false,
              getTitlesWidget: (value, meta){
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "${value.toInt() * 100}",
                    style: GoogleFonts.roboto(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                );
              }

            ),

            ),

          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: widget.data.elementAt(0), color: AppColors.spotifyGreen, width: 16, borderRadius: BorderRadius.circular(6)),
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: widget.data.elementAt(1), color: AppColors.spotifyGreen, width: 16, borderRadius: BorderRadius.circular(6)),
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: widget.data.elementAt(2), color: AppColors.spotifyGreen, width: 16, borderRadius: BorderRadius.circular(6)),
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(toY: widget.data.elementAt(3), color: AppColors.spotifyGreen, width: 16, borderRadius: BorderRadius.circular(6)),
          ]),
          BarChartGroupData(x: 4, barRods: [
            BarChartRodData(toY: widget.data.elementAt(4), color: AppColors.spotifyGreen, width: 16,borderRadius: BorderRadius.circular(6)),
          ]),
        ],
        barTouchData: BarTouchData(enabled: false),
      ),
    );
  }
}

class HeadMapMessagesHour extends StatefulWidget {

    List<double> data;
    double width;
    double heigth;
    double borderRadius;

  HeadMapMessagesHour({super.key, required this.data, required this.width, required this.heigth, this.borderRadius =0});

  @override
  State<HeadMapMessagesHour> createState() => _HeadMapMessagesHourState();
}

class _HeadMapMessagesHourState extends State<HeadMapMessagesHour> {

  double width = 0.0;
  double heigth = 0.0;
  double maxValue =0;



  @override
  void initState() {
    super.initState();
    width = widget.width;
    heigth = widget.heigth;

  }
  @override
  Widget build(BuildContext context) {
   return Container(
     width: width,
     height: heigth,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(12),
     ),

     child: Row(
       children: List.generate(
         widget.data.length, (index){

           return Column(
             children: [
               Container(
                 width: width / widget.data.length,
                 height: 20,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        index.toString() + " h",
                        style: GoogleFonts.roboto(
                          color: (index % 2 ==0) ? Colors.white60 : Colors.transparent
                        ),
                      ),
                    ),
                  ),
               ),
               Container(
                 width: width / widget.data.length,
                 height: 40,
                 decoration: BoxDecoration(
                   color: Color.lerp(
                     Colors.red[100],
                     Colors.red[900],
                     pow(((widget.data[index] / 100).clamp(0, 1)), 2).toDouble()
                   ),
                   borderRadius: (index == 0) ? BorderRadius.only( bottomLeft: Radius.circular(widget.borderRadius), topLeft: Radius.circular(widget.borderRadius)) : (index == widget.data.length-1) ? BorderRadius.only( bottomRight: Radius.circular(widget.borderRadius), topRight: Radius.circular(widget.borderRadius)) : null,

                 ),
               ),
             ],
           );
       },

       )

       )


   );
  }
}

class HeadMapActivityDay extends StatefulWidget {

  Map<int, double> data;
  bool withText;
  int dayDif;

   HeadMapActivityDay({super.key, required this.data, this.withText =  false, this.dayDif = 0});

  @override
  State<HeadMapActivityDay> createState() => _HeadMapActivityDayState();
}

class _HeadMapActivityDayState extends State<HeadMapActivityDay> {
  bool isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    const int rows = 7;
    const int columns = 53;
    List<String> rowTitles = ["MO", "DI", "MI", "DO", "FR", "SA", "SO"];
    List<String> colTitles = ["JAN", "FEB", "MÄR", "APR", "MAI", "JUN","JUL", "AUG", "SEP", "OKT", "NOV", "DEZ"];





    return  SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Container(
          height: MediaQuery.of(context).size.width * (isMobile ? 0.25 : 0.08 * rows),
            margin: EdgeInsets.only(top: 15, right: 10),
            child: Column(
              children: List.generate(
                  7,
                      (index){
                    return Container(
                      height: MediaQuery.of(context).size.width * (isMobile ? 0.25 : 0.08 * rows) / 7,
                      child: FittedBox(
                        child: Text(
                          rowTitles[index],
                          style: GoogleFonts.roboto(
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
          ),

          Column(
            children: [

              Container(
                width: MediaQuery.of(context).size.width * 1.95,
                height: 15,
                child: Row(
                  children: List.generate(
                      12,
                          (index){
                        return Container(
                          width: MediaQuery.of(context).size.width * 1.95 / 12,
                          child: FittedBox(
                            child: Text(
                              colTitles[index],
                              style: GoogleFonts.roboto(
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.width * (isMobile ? 0.25 : 0.08 * rows),
                width: MediaQuery.of(context).size.width * 1.95,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // wichtig!
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, // 7 Reihen
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    childAspectRatio: 1, // Quadratisch
                  ),
                  itemCount: widget.data.length + widget.dayDif - 2,
                  itemBuilder: (context, index) {
                    double value = widget.data[index + 1 - widget.dayDif - 2] ?? 0;

                    return Tooltip(
                      message: value.toString(),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: (index <= widget.dayDif - 2)
                              ? Colors.transparent
                              : Color.lerp(AppColors.spotifyContainerColor, Colors.green[900], (value / 100).clamp(0, 1)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: widget.withText
                            ? Text(
                          value.toString(),
                          style: const TextStyle(fontSize: 8, color: Colors.white),
                        )
                            : Container(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );


  }
}


class LineChartSpotify extends StatelessWidget {

  final List<List<FlSpot>> dataPoints;
  final curveSmoothness;

  const LineChartSpotify({super.key,
    required this.dataPoints,
    this.curveSmoothness = 0.3
  });

  String timestampToDate(int timestamp){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.day}.${date.month}.${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    List<LineChartBarData> lineData = [];
    final allSpots = dataPoints.expand((e) => e).toList();

    double maxX = allSpots.map((e) => e.x).reduce((a, b) => a > b ? a : b) * 1.05;
    double maxY =  allSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.05;

    List<Color> colors = AppColors.chartColors;
    colors[0] = AppColors.spotifyGreen;

    for (int i = 0; i < dataPoints.length; i++) {
      List<FlSpot> d = dataPoints[i];
      if (d.isEmpty) d.add(FlSpot(0, 0));

      LineChartBarData data = LineChartBarData(
        spots: d,
        isCurved: true,
        curveSmoothness: curveSmoothness,
        color: colors[i % colors.length], // zyklisch Farbe zuweisen
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        preventCurveOverShooting: true,
        barWidth: 3
      );

      lineData.add(data);
    }

    return  ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: LineChart(
        LineChartData(
          minY: -1,

          gridData: FlGridData(
            show: false,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Color(0x77121212), // Gitterfarbe grau
                strokeWidth: 0.5, // Sehr feine Gitterlinien
              );
            },
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: Color(0x77121212),  // Gitterfarbe grau
                strokeWidth: 0.5, // Sehr feine Gitterlinien
              );
            },
          ),
          titlesData:  FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: false
                )
            ),
            topTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: false
                )
            ),
            rightTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: false
                )
            ),
            leftTitles: AxisTitles(

              sideTitles: SideTitles(
                showTitles: true,
                //minIncluded: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {

                  return Container(
                    margin: EdgeInsets.only(top: 15, left: 5),
                    child: Text(
                      value.toInt().toString(),
                      style: GoogleFonts.roboto(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  );
                },


              ),
            ),
          ),

          borderData: FlBorderData(show: false),
          lineBarsData: lineData,
          backgroundColor: Colors.transparent,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              rotateAngle: 0,
              tooltipRoundedRadius: 4,

              fitInsideHorizontally: true,
              fitInsideVertically: true,

              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${timestampToDate(spot.x.toInt())}: ${spot.y}',
                    const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          minX: -1,
          maxX: maxX,
          maxY: maxY,
        ),
      ),
    );
  }
}
