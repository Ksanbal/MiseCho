import 'package:flutter/material.dart';
import 'package:circle_chart/circle_chart.dart';
import '../main.dart';

space_circle() {
  return Row(
    children: [
      Expanded(
        child: CircleChart(
          progressNumber: 60,
          maxNumber: 160,
          width: 300,
          height: 220,
          progressColor: make_color('pm10', 60),
          backgroundColor: Colors.white,
          rateTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          children: [
            Text(
              'Mise',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
      Expanded(
        child: CircleChart(
          progressNumber: 46,
          maxNumber: 80,
          width: 300,
          height: 220,
          progressColor: make_color('pm2p5', 46),
          backgroundColor: Colors.white,
          rateTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          children: [
            Text(
              'ChoMise',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    ],
  );
}
