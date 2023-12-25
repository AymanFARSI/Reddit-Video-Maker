import 'package:flutter/material.dart';

class BackgroundSelect extends StatefulWidget {
  const BackgroundSelect({super.key});

  @override
  State<BackgroundSelect> createState() => _BackgroundSelectState();
}

class _BackgroundSelectState extends State<BackgroundSelect> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Column(
          children: [
            Text(
              "Pre-downloaded Backgrounds",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Coming soon!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
