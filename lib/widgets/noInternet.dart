import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  final String route;
  NoInternet(this.route);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "No internet, please check your internet connection",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        Center(
          child: Transform.scale(
            scale: 3,
            child: IconButton(
              icon: const Icon(
                Icons.refresh,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(route);
              },
            ),
          ),
        )
      ],
    );
  }
}
