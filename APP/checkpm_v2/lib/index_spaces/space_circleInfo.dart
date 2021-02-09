import 'package:flutter/material.dart';
import 'package:circle_chart/circle_chart.dart';
import '../main.dart';

space_circle(double pm10, double pm2p5) {
  return Column(
    children: [
      Text(
        'Now State',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: CircleChart(
                progressNumber: pm10,
                maxNumber: 160,
                width: 300,
                height: 220,
                progressColor: make_color('pm10', pm10),
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
                progressNumber: pm2p5,
                maxNumber: 80,
                width: 300,
                height: 220,
                progressColor: make_color('pm2p5', pm2p5),
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
        ),
      ),
    ],
  );
}
