
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import '../Color/app_Colors.dart';

class SmallDataContainer extends StatefulWidget {
  final Widget child;
  final Widget description;
  final String header;

  SmallDataContainer({required this.child, required this.description, required this.header});

  @override
  State<SmallDataContainer> createState() => _SmallDataContainerState();
}

class _SmallDataContainerState extends State<SmallDataContainer> {
  bool isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: (isMobile) ? MediaQuery.of(context).size.width * 0.95 : MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
          color: AppColors.basicContainerColor2,
          borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            widget.header,
            style: GoogleFonts.roboto(
              color: Colors.white70,
              fontSize: 24,
            ),
          ),

          Center(
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width * (isMobile ? 0.8 : 0.2),
              decoration: BoxDecoration(
                  color: AppColors.basicContainerColor,
                  borderRadius: BorderRadius.circular(12)
              ),
              child: widget.description,
            ),
          ),

          widget.child,
        ],
      ),
    );
  }
}



class BigDataContainer extends StatefulWidget {
  final Widget child;
  final Widget description;
  final String header;

  BigDataContainer({required this.child, required this.description, required this.header});

  @override
  State<BigDataContainer> createState() => _BigDataContainerState();
}

class _BigDataContainerState extends State<BigDataContainer> {
  bool isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: (isMobile) ? MediaQuery.of(context).size.width * 0.95 : MediaQuery.of(context).size.width * 0.46,
      height: 500,
      decoration: BoxDecoration(
          color: AppColors.basicContainerColor2,
          borderRadius: BorderRadius.circular(12)
      ),

      child:  Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            widget.header,
            style: GoogleFonts.roboto(
              color: Colors.white70,
              fontSize: 24,

            ),
          ),

          Container(
            height: 100,
            width: MediaQuery.of(context).size.width * (isMobile ? 0.8 : 0.4),
            decoration: BoxDecoration(
                color: AppColors.basicContainerColor,
                borderRadius: BorderRadius.circular(12)
            ),
            child: widget.description,
          ),

          widget.child
        ],
      ),
    );
  }
}


class buildResponsiveRowOrColumn extends StatefulWidget {
  List<Widget> children;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;

  buildResponsiveRowOrColumn({
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center
});

  @override
  State<buildResponsiveRowOrColumn> createState() => _buildResponsiveRowOrColumnState();
}

class _buildResponsiveRowOrColumnState extends State<buildResponsiveRowOrColumn> {
    bool isMobile = defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
  @override
  Widget build(BuildContext context) {
    return isMobile
        ? Column(
      children: widget.children,
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      spacing: 10,
    )
        : Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: widget.children,
    );
  }
}


